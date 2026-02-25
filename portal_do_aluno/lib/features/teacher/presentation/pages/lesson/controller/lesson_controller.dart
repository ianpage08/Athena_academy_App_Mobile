import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/helper/anexo_helper.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/conteudo_service.dart';
import 'package:portal_do_aluno/features/teacher/data/models/lesson_record.dart';

class LessonController {
  final submitState = ValueNotifier<SubmitState>(Initial());
  final ConteudoPresencaService _serviceConteudo = ConteudoPresencaService();
  Stream<QuerySnapshot<Map<String, dynamic>>> getDisciplinas() =>
      _firestore.collection('disciplinas').snapshots();

  Future<String> getTeacherId(String userId) async {
    final snapshot = await _firestore.collection('usuarios').doc(userId).get();
    if (!snapshot.exists) {
      throw Exception('Usuário não encontrado');
    }
    final data = snapshot.data()!;
    if (data['type'] != 'teacher') {
      throw Exception('Usuario não é professor');
    }
    
    return snapshot.id;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController conteudoController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();
  final ValueNotifier<String?> turmaSelecionada = ValueNotifier<String?>(null);
  final ValueNotifier<String?> disciplinaSelecionada = ValueNotifier<String?>(
    null,
  );

  final List<XFile> imgSelected = [];
  String? turmaId;
  String? disciplinaId;
  DateTime? dataSelecionada;

  bool get isFormValid {
    return turmaId != null &&
        disciplinaId != null &&
        dataSelecionada != null &&
        conteudoController.text.isNotEmpty &&
        observacoesController.text.isNotEmpty;
  }

  void clear() {
    conteudoController.clear();
    observacoesController.clear();
  }

  LessonRecord buildLesson(List<String> urls) {
    return LessonRecord(
      id: '',
      classId: turmaId!,
      conteudo: conteudoController.text,
      data: dataSelecionada!,
      observacoes: observacoesController.text,
      anexo: urls,
    );
  }

  Future<void> submit(String teacherId) async {
    if (!isFormValid) {
      submitState.value = SubmitError(
        AppError(
          message: 'Preencha todos os campos',
          type: AppErrorType.validation,
        ),
      );
      return;
    }

    if (imgSelected.isEmpty) {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.validation,
          message: 'Selecione a imagem do Relatorio para enviar',
        ),
      );
      return;
    }

    submitState.value = SubmitLoading();
    try {
      final userId = await getTeacherId(teacherId);
      final uploadUrls = await uploadImagensReport(imgSelected, userId);

      await _serviceConteudo.cadastrarPresencaConteudoProfessor(
        turmaId: turmaId!,
        conteudoPresenca: buildLesson(uploadUrls),
      );

      clear();
      imgSelected.clear();
      submitState.value = SubmitSuccess('Conteudo cadastrado com sucesso');
    } on FirebaseException {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.network,
          message: 'Erro de conexão. Verifique sua internet.',
        ),
      );
    } catch (e) {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.unknown,
          message: 'Erro inesperado. Tente novamente',
        ),
      );
    }
  }

  

  void dispose() {
    conteudoController.dispose();
    observacoesController.dispose();
  }
}
