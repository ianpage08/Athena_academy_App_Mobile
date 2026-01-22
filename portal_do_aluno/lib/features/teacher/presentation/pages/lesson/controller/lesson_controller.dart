import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/conteudo_service.dart';
import 'package:portal_do_aluno/features/teacher/data/models/lesson_record.dart';




class LessonController{

  final submitState = ValueNotifier<SubmitState>(Initial());
  final ConteudoPresencaService _serviceConteudo = ConteudoPresencaService();
  Stream<QuerySnapshot<Map<String, dynamic>>> getDisciplinas() =>
      _firestore.collection('disciplinas').snapshots();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController conteudoController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();
  final ValueNotifier<String?> turmaSelecionada = ValueNotifier<String?>(null);
  final ValueNotifier<String?> disciplinaSelecionada = ValueNotifier<String?>(
    null,
  );

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

  LessonRecord buildLesson() {
    return LessonRecord(
      id: '',
      classId: turmaId!,
      conteudo: conteudoController.text,
      data: dataSelecionada!,
      observacoes: observacoesController.text,
    );
  }

  Future<void> submit() async {
    if (!isFormValid) {
      submitState.value = SubmitError(
        AppError(
          message: 'Preencha todos os campos',
          type: AppErrorType.validation,
        ),
      );
    }
    submitState.value = SubmitLoading();
    try {
      await _serviceConteudo.cadastrarPresencaConteudoProfessor(
        turmaId: turmaId!,
        conteudoPresenca: buildLesson(),
      );

      clear();
      submitState.value = SubmitSuccess('Conteudo cadastrado com sucesso');
    } on FirebaseException {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.network,
          message: 'Erro de conexão. Verifique sua internet.',
        ),
      );
    } catch (e) {
      SubmitError(AppError(type: AppErrorType.unknown, message: 'Erro inesperado. Tente novamente'));
    }
  }


  void dispose() {
    conteudoController.dispose();
    observacoesController.dispose();
  }
}
