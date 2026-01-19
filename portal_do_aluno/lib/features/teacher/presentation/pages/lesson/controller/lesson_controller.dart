import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:portal_do_aluno/core/submit%20state/submit_states.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/conteudo_service.dart';
import 'package:portal_do_aluno/features/teacher/data/models/lesson_record.dart';

class LessonController {
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

  Future<SubmitState> submit() async {
    if (!isFormValid) {
      return submitState.value = Error('Preencha todos os campos');
    }
    submitState.value = Loading();
    try {
      await _serviceConteudo.cadastrarPresencaConteudoProfessor(
        turmaId: turmaId!,
        conteudoPresenca: buildLesson(),
      );

      clear();
      return submitState.value = Success();
    } catch (e) {
      return submitState.value = Error('Erro ao cadastrar conteudo');
    }
  }

  void dispose() {
    conteudoController.dispose();
    observacoesController.dispose();
  }
}
