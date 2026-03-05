import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/data/repositories/cadastro_disciplina_repository.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';

class CadastroDisciplinaController {
  final submitState = ValueNotifier<SubmitState>(Initial());
  final CadastroDisciplinaRepository _repository =
      CadastroDisciplinaRepository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nomeDisciplinaController =
      TextEditingController();
  final TextEditingController nomeProfessorController = TextEditingController();
  final TextEditingController aulasPrevistasController =
      TextEditingController();
  final TextEditingController cargaHorariaController = TextEditingController();

  List<TextEditingController> get _controllers => [
    nomeDisciplinaController,
    nomeProfessorController,
    aulasPrevistasController,
    cargaHorariaController,
  ];

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
      await _repository.cadastrarNovaDisciplina(
        nameTeacher: nomeProfessorController.text.trim(),
        discipline: nomeDisciplinaController.text.trim(),
        numberClasses: aulasPrevistasController.text.trim(),
        hours: cargaHorariaController.text.trim(),
      );
      clear();
      submitState.value = SubmitSuccess('Disciplina cadastrada com sucesso!');
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
