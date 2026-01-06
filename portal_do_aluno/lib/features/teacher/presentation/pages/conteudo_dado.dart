import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:portal_do_aluno/features/teacher/data/datasources/conteudo_service.dart';
import 'package:portal_do_aluno/features/teacher/data/models/conteudo_presenca.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/selected_provider.dart';
import 'package:portal_do_aluno/shared/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/shared/widgets/data_picker_calendario.dart';
import 'package:portal_do_aluno/shared/helpers/snack_bar_helper.dart';
import 'package:portal_do_aluno/shared/widgets/firestore/stream_drop.dart';
import 'package:portal_do_aluno/shared/widgets/text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/botao_selecionar_turma.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class OqueFoiDado extends StatefulWidget {
  const OqueFoiDado({super.key});

  @override
  State<OqueFoiDado> createState() => _OqueFoiDadoState();
}

class _OqueFoiDadoState extends State<OqueFoiDado> {
  final _conteudoController = TextEditingController();
  final _observacoesController = TextEditingController();

  final ValueNotifier<String?> turmaSelecionada = ValueNotifier<String?>(null);

  String? turmaId;
  String? disciplinaId;
  DateTime? dataSelecionada;
  bool isLoading = false;

  final ConteudoPresencaService _service = ConteudoPresencaService();

  Stream<QuerySnapshot<Map<String, dynamic>>> getDisciplinas() =>
      FirebaseFirestore.instance.collection('disciplinas').snapshots();

  Future<void> salvarConteudo() async {
    if (turmaId == null ||
        disciplinaId == null ||
        dataSelecionada == null ||
        _conteudoController.text.isEmpty) {
      snackBarPersonalizado(
        context: context,
        mensagem: 'Preencha todos os campos obrigatórios',
        cor: Colors.redAccent,
      );
      return;
    }

    final conteudo = ConteudoPresenca(
      id: '',
      classId: turmaId!,
      conteudo: _conteudoController.text,
      data: dataSelecionada!,
      observacoes: _observacoesController.text,
    );

    try {
      setState(() => isLoading = true);

      await _service.cadastrarPresencaConteudoProfessor(
        conteudoPresenca: conteudo,
        turmaId: turmaId!,
      );

      if (!mounted) return;

      snackBarPersonalizado(
        context: context,
        mensagem: 'Conteúdo salvo com sucesso!',
        cor: Colors.green,
      );

      _conteudoController.clear();
      _observacoesController.clear();
      context.read<SelectedProvider>().limparDrop('disciplina');
    } catch (e) {
      snackBarPersonalizado(
        context: context,
        mensagem: 'Erro ao salvar conteúdo',
        cor: Colors.redAccent,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Conteúdo ministrado'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Informações da aula'),
                    const SizedBox(height: 20),

                    BotaoSelecionarTurma(
                      turmaSelecionada: turmaSelecionada,
                      onTurmaSelecionada: (id, _) => turmaId = id,
                    ),

                    const SizedBox(height: 16),

                    StreamDrop(
                      dropId: 'disciplina',
                      minhaStream: getDisciplinas(),
                      mensagemError: 'Nenhuma disciplina encontrada',
                      textLabel: 'Disciplina',
                      nomeCampo: 'nome',
                      icon: const Icon(Icons.menu_book),
                      onSelected: (id, _) => disciplinaId = id,
                    ),

                    const SizedBox(height: 16),

                    DataPickerCalendario(
                      onDate: (data) => dataSelecionada = data,
                    ),

                    const SizedBox(height: 32),
                    const Divider(height: 1),
                    const SizedBox(height: 32),

                    _sectionTitle('Conteúdo ministrado'),
                    const SizedBox(height: 16),

                    TextFormFieldPersonalizado(
                      prefixIcon: CupertinoIcons.book,
                      maxLines: 5,
                      controller: _conteudoController,
                      label: 'Conteúdo',
                      hintText:
                          'Ex: Revisão de equações do 1º grau e introdução a inequações',
                    ),

                    const SizedBox(height: 16),

                    TextFormFieldPersonalizado(
                      prefixIcon: CupertinoIcons.doc_text,
                      maxLines: 3,
                      controller: _observacoesController,
                      label: 'Observações',
                      hintText:
                          'Pendências, avisos ou materiais para a próxima aula',
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: BotaoSalvar(salvarconteudo: salvarConteudo),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
