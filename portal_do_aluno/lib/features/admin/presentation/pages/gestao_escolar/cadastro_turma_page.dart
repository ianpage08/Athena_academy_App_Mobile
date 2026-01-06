import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_turma_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/turma.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/shared/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/shared/helpers/snack_bar_helper.dart';
import 'package:portal_do_aluno/shared/widgets/text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class CadastroTurma extends StatefulWidget {
  const CadastroTurma({super.key});

  @override
  State<CadastroTurma> createState() => _CadastroTurmaState();
}

class _CadastroTurmaState extends State<CadastroTurma> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CadastroTurmaService cadastrarNovaTurma = CadastroTurmaService();

  final Map<String, TextEditingController> _mapController = {
    'serie': TextEditingController(),
    'turno': TextEditingController(),
    'qtdAlunos': TextEditingController(),
    'professorTitular': TextEditingController(),
  };

  List<TextEditingController> get _allControllers =>
      _mapController.values.toList();

  Future<void> _cadastroTurma() async {
    if (!FormHelper.isFormValid(
      formKey: _formKey,
      listControllers: _allControllers,
    )) {
      snackBarPersonalizado(
        context: context,
        mensagem: 'Preencha todos os campos corretamente.',
        cor: Colors.red,
      );
      return;
    }

    final novaTurma = ClasseDeAula(
      id: '',
      serie: _mapController['serie']!.text,
      turno: _mapController['turno']!.text,
      qtdAlunos: int.parse(_mapController['qtdAlunos']!.text),
      professorTitular: _mapController['professorTitular']!.text,
    );

    try {
      await cadastrarNovaTurma.cadatrarNovaTurma(novaTurma);

      if (!mounted) return;

      snackBarPersonalizado(
        context: context,
        mensagem: 'Turma cadastrada com sucesso! 🎉',
        cor: Colors.green,
      );

      FormHelper.limparControllers(controllers: _allControllers);
    } catch (_) {
      if (!mounted) return;
      snackBarPersonalizado(
        context: context,
        mensagem: 'Erro ao cadastrar turma. Tente novamente.',
        cor: Colors.red,
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _allControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de Turma'),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  const Text(
                    'Dados da Turma',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Informe os dados básicos para criar uma nova turma.',
                  ),

                  const SizedBox(height: 24),

                  // CAMPOS
                  TextFormFieldPersonalizado(
                    controller: _mapController['professorTitular']!,
                    prefixIcon: Icons.person,
                    label: 'Professor titular',
                    hintText: 'Ex: Maria Silva',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),

                  TextFormFieldPersonalizado(
                    controller: _mapController['turno']!,
                    prefixIcon: Icons.schedule,
                    label: 'Turno',
                    hintText: 'Matutino / Vespertino',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16),

                  TextFormFieldPersonalizado(
                    controller: _mapController['serie']!,
                    prefixIcon: Icons.class_,
                    label: 'Série',
                    hintText: '9º Ano',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16),

                  TextFormFieldPersonalizado(
                    controller: _mapController['qtdAlunos']!,
                    prefixIcon: Icons.group,
                    label: 'Quantidade de alunos',
                    hintText: 'Ex: 25',
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 32),

                  // BOTÃO
                  SizedBox(
                    width: double.infinity,
                    child: BotaoSalvar(salvarconteudo: _cadastroTurma),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
