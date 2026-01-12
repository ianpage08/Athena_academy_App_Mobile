import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_comunicado_firestore.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/exercicio_firestore.dart';
import 'package:portal_do_aluno/features/teacher/data/models/student_task.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/features/admin/helper/limitar_tamanho_texto.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_date_picker_field.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';
import 'package:portal_do_aluno/core/notifications/enviar_notication.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ExerciseAssignmentPage extends StatefulWidget {
  const ExerciseAssignmentPage({super.key});

  @override
  State<ExerciseAssignmentPage> createState() => _ExerciseAssignmentPageState();
}

class _ExerciseAssignmentPageState extends State<ExerciseAssignmentPage> {
  final ComunicadoService _comunicadoService = ComunicadoService();
  final ExercicioSevice _exercicioSevice = ExercicioSevice();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'titulo': TextEditingController(),
    'conteudo': TextEditingController(),
  };

  final ValueNotifier<String?> turmaSelecionada = ValueNotifier(null);
  String? turmaId;
  DateTime? dataSelecionada;

  List<TextEditingController> get _allControllers =>
      _controllers.values.toList();

  void limparCampos() {
    FormHelper.limparControllers(controllers: _allControllers);
    turmaSelecionada.value = null;
    turmaId = null;
    dataSelecionada = null;
  }

  Future<void> _cadastrarExercicio(String professorId) async {
    if (!FormHelper.isFormValid(
      formKey: _formKey,
      listControllers: _allControllers,
    )) {
      return showAppSnackBar(
        context: context,
        mensagem: 'Preencha todos os campos corretamente.',
        cor: Colors.orange,
      );
    }

    if (dataSelecionada == null) {
      return showAppSnackBar(
        context: context,
        mensagem: 'Selecione a data de entrega',
        cor: Colors.orange,
      );
    }

    try {
      final profDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(professorId)
          .get();

      final exercicio = StudentTask(
        id: '',
        titulo: _controllers['titulo']!.text,
        conteudoDoExercicio: _controllers['conteudo']!.text,
        professorId: professorId,
        nomeDoProfessor: profDoc['name'],
        turmaId: turmaId!,
        dataDeEnvio: Timestamp.now(),
        dataDeEntrega: Timestamp.fromDate(dataSelecionada!),
        dataDeExpiracao: Timestamp.fromDate(
          dataSelecionada!.add(const Duration(days: 7)),
        ),
      );

      await _exercicioSevice.cadastrarNovoExercicio(exercicio, turmaId!);

      showAppSnackBar(
        context: context,
        mensagem: 'Exercício cadastrado com sucesso!',
        cor: Colors.green,
      );

      limparCampos();
      await _notificarAlunos();
    } catch (e) {
      showAppSnackBar(
        context: context,
        mensagem: 'Erro ao cadastrar exercício',
        cor: Colors.red,
      );
    }
  }

  Future<void> _notificarAlunos() async {
    final tokens = await _comunicadoService.getTokensDestinatario('alunos');
    final resumo = limitarCampo(_controllers['conteudo']!.text, 40);

    for (final token in tokens) {
      enviarNotification(token, 'Novo exercício disponível', resumo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final professorId = context.watch<UserProvider>().userId;

    if (professorId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de Exercício'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildCard(),
                  const SizedBox(height: 24),
                  SaveButton(
                    salvarconteudo: () async {
                      await _cadastrarExercicio(professorId);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 CARD PRINCIPAL
  Widget _buildCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('Turma'),
            SelectClassButton(
              turmaSelecionada: turmaSelecionada,
              onTurmaSelecionada: (id, nome) {
                turmaId = id;
                turmaSelecionada.value = nome;
              },
            ),

            const SizedBox(height: 24),
            _divider(),

            _section('Conteúdo do Exercício'),
            CustomTextFormField(
              prefixIcon: Icons.title,
              controller: _controllers['titulo']!,
              hintText: 'Ex: Atividade para casa',
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              prefixIcon: Icons.notes,
              controller: _controllers['conteudo']!,
              maxLines: 4,
              hintText: 'Ex: Resolver exercícios da página 10 a 20',
            ),

            const SizedBox(height: 24),
            _divider(),

            _section('Data de Entrega'),
            CustomDatePickerField(
              isSelecionada: dataSelecionada,
              onDate: (data) => dataSelecionada = data,
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Divider(height: 1),
  );
}
