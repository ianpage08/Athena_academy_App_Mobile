import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/data/repositories/resgistration_class_repository.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';

class CadastroTurmaController {
  final submitState = ValueNotifier<SubmitState>(Initial());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ResgistrationClassRepository _resgistrationClassRepository =
      ResgistrationClassRepository();
  final TextEditingController serieController = TextEditingController();
  final TextEditingController turnoController = TextEditingController();
  final TextEditingController qtdAlunosController = TextEditingController();
  final TextEditingController professorTitularController =
      TextEditingController();

  

  Future<void> submit() async {
    if (!FormHelper.isFormValid(
      formKey: formKey,
      listControllers: [
        serieController,
        turnoController,
        qtdAlunosController,
        professorTitularController,
      ],
    )) {
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
      await _resgistrationClassRepository.cadastrarClasse(
        amountStudents: qtdAlunosController.text,
        nameTeacher: professorTitularController.text,
        serie: serieController.text,
        shift: turnoController.text,
      );
      clear();
      submitState.value = SubmitSuccess('Turma cadastrada com sucesso! ');
    } on FirebaseException {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.network,
          message: 'Internet indisponivel, tente novamente mais tarde.',
        ),
      );
    } catch (e) {
      submitState.value = SubmitError(
        AppError(
          type: AppErrorType.unknown,
          message: 'Erro ao cadastrar turma',
        ),
      );
    }
  }
  void clear() {
    serieController.clear();
    turnoController.clear();
    qtdAlunosController.clear();
    professorTitularController.clear();
  }

  void dispose() {
    submitState.dispose();
    serieController.dispose();
    turnoController.dispose();
    qtdAlunosController.dispose();
    professorTitularController.dispose();
  }
}
