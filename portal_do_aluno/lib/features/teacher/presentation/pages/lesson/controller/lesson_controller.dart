import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/conteudo_service.dart';
import 'package:portal_do_aluno/features/teacher/data/models/lesson_record.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';

class LessonController {
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
  bool isLoading = false;

  bool get validateForm {
    return turmaId == null ||
        disciplinaId == null ||
        dataSelecionada == null ||
        conteudoController.text.isEmpty ||
        observacoesController.text.isEmpty;
  }

  void clear() {
    disciplinaId = null;
    dataSelecionada = null;
    conteudoController.clear();
    observacoesController.clear();
  }

  LessonRecord buildLessson() {
    return LessonRecord(
      id: '',
      classId: turmaId!,
      conteudo: conteudoController.text,
      data: dataSelecionada!,
      observacoes: observacoesController.text,
    );
  }

  Future<bool> submit(BuildContext context) async {
    try {
      await _serviceConteudo.cadastrarPresencaConteudoProfessor(
        turmaId: turmaId!,
        conteudoPresenca: buildLessson(),
      );

      return true;
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(
          context: context,
          mensagem: 'Erro ao salvar conteudo',
          cor: Colors.redAccent,
        );
      }
    }
    return false;
  }

  void dispose() {
    conteudoController.dispose();
    observacoesController.dispose();
  }
}
