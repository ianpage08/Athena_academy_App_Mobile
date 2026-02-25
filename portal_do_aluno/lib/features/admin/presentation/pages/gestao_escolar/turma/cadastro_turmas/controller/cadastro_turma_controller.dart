import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_turma_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/turma.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';

class CadastroTurmaController {
  final submitState = ValueNotifier<SubmitState>(Initial());
  final CadastroTurmaService _cadastroTurmaService = CadastroTurmaService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController serieController = TextEditingController();
  final TextEditingController turnoController = TextEditingController();
  final TextEditingController qtdAlunosController = TextEditingController();
  final TextEditingController professorTitularController =
      TextEditingController();

  void clear() {
    serieController.clear();
    turnoController.clear();
    qtdAlunosController.clear();
    professorTitularController.clear();
  }

  ClasseDeAula buildTurma() {
    return ClasseDeAula(
      id: '',
      serie: serieController.text.trim(),
      turno: turnoController.text.trim(),
      qtdAlunos: int.tryParse(qtdAlunosController.text) ?? 0,
      professorTitular: professorTitularController.text.trim(),
    );
  }

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
      final turma = buildTurma();
      await _cadastroTurmaService.cadatrarNovaTurma(turma);
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

  void dispose() {
    submitState.dispose();
    serieController.dispose();
    turnoController.dispose();
    qtdAlunosController.dispose();
    professorTitularController.dispose();
  }
}
