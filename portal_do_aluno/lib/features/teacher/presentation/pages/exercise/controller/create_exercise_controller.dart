import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/notifications/enviar_notication.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_comunicado_firestore.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/features/admin/helper/limitar_tamanho_texto.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/exercicio_firestore.dart';
import 'package:portal_do_aluno/features/teacher/data/models/student_task.dart';

class CreateExerciseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ExercicioSevice _exercicioSevice = ExercicioSevice();
  final ComunicadoService _comunicadoService = ComunicadoService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController conteudoController = TextEditingController();

  final ValueNotifier<String?> turmaSelecionada = ValueNotifier<String?>(null);

  String? turmaId;
  DateTime? dataSelecionada;
  

  /// 🔹 Constrói o objeto a partir do estado do controller
  StudentTask buildTask({
    required String professorId,
    required String nomeProfessor,
  }) {
    return StudentTask(
      id: '',
      titulo: tituloController.text.trim(),
      conteudoDoExercicio: conteudoController.text.trim(),
      professorId: professorId,
      nomeDoProfessor: nomeProfessor,
      turmaId: turmaId!,
      dataDeEnvio: Timestamp.now(),
      dataDeEntrega: Timestamp.fromDate(dataSelecionada!),
      dataDeExpiracao: Timestamp.fromDate(
        dataSelecionada!.add(const Duration(days: 7)),
      ),
    );
  }

  Future<bool> submit(String professorId) async {
    if (!FormHelper.isFormValid(
      formKey: formKey,
      listControllers: [tituloController, conteudoController],
    )) {
      return false;
    }

    if (turmaId == null || dataSelecionada == null) {
      return false;
    }

    try {
      final profDoc = await _firestore
          .collection('usuarios')
          .doc(professorId)
          .get();

      final task = buildTask(
        professorId: professorId,
        nomeProfessor: profDoc['name'],
      );

      await _exercicioSevice.cadastrarNovoExercicio(task, turmaId!);
      await notificarTurma();
      clear();

      return true;
    } catch (e) {
      debugPrint('Erro ao cadastrar exercício: $e');
      return false;
    } 
  }

  Future<void> notificarTurma() async {
    final tokens = await _comunicadoService.getTokensDestinatario('alunos');

    final resumo = limitarCampo(conteudoController.text, 40);

    for (final token in tokens) {
      enviarNotification(token, 'Novo exercício disponível', resumo);
    }
  }

  void clear() {
    turmaId = null;
    dataSelecionada = null;
    turmaSelecionada.value = null;
    tituloController.clear();
    conteudoController.clear();
  }

  void dispose() {
    tituloController.dispose();
    conteudoController.dispose();
  }
}
