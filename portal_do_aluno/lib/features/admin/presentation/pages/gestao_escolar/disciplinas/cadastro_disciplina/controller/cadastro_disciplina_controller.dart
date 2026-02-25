import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';

import 'package:portal_do_aluno/features/admin/data/datasources/cadastrar_diciplina_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/diciplinas.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';

class CadastroDisciplinaController {
  final submitState = ValueNotifier<SubmitState>(Initial());
  final DisciplinaService _service = DisciplinaService();

  final formKey = GlobalKey<FormState>();

  final TextEditingController nomeDisciplinaController =
      TextEditingController();
  final TextEditingController nomeProfessorController =
      TextEditingController();
  final TextEditingController aulasPrevistasController =
      TextEditingController();
  final TextEditingController cargaHorariaController =
      TextEditingController();

  List<TextEditingController> get _controllers => [
        nomeDisciplinaController,
        nomeProfessorController,
        aulasPrevistasController,
        cargaHorariaController,
      ];

  Disciplina buildDisciplina() {
    return Disciplina(
      id: '',
      nome: nomeDisciplinaController.text.trim(),
      professor: nomeProfessorController.text.trim(),
      aulaPrevistas:
          int.tryParse(aulasPrevistasController.text) ?? 0,
      cargaHoraria:
          int.tryParse(cargaHorariaController.text) ?? 0,
    );
  }

  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
  }

  Future<void> submit() async {
    final isValid = FormHelper.isFormValid(
      formKey: formKey,
      listControllers: _controllers,
    );

    if (!isValid) {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.validation,
          message: 'Preencha todos os campos',
        ),
      );
      return;
    }

    submitState.value = SubmitLoading();

    try {
      await _service.cadastrarNovaDisciplina(buildDisciplina());
      clear();
      submitState.value =
          SubmitSuccess('Disciplina cadastrada com sucesso!');
    } catch (_) {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.unknown,
          message: 'Erro ao cadastrar disciplina',
        ),
      );
    }
  }

  void dispose() {
    submitState.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
  }
}
