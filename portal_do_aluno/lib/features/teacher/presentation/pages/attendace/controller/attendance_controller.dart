import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/core/errors/app_error_type.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/teacher/data/repository/attendance_repository.dart';

class AttendanceRegistrationController {
  final AttendanceRepository _repository = AttendanceRepository();
  final state = ValueNotifier<SubmitState>(Initial());

  String? turmaId;
  DateTime? dataSelecionada;

  Future<SubmitState> salvar(BuildContext context) async {
    if (turmaId == null || dataSelecionada == null) {
      return state.value = SubmitError(
        AppError(
          type: AppErrorType.validation,
          message: 'Preencha todos os campos',
        ),
      );
    }
    state.value = SubmitLoading();

    try {
      _repository.salvarFrequenciaPorTurma(
        classId: turmaId!,
        dataSelecionada: dataSelecionada!,
        context: context,
      );

      state.value = SubmitSuccess('Presença salva com sucesso');
      return state.value;
    } catch (_) {
      state.value = SubmitError(
        AppError(
          type: AppErrorType.unknown,
          message: 'Erro ao salvar presença',
        ),
      );
      return state.value;
    }
  }
}
