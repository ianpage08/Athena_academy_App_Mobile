import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/submit%20state/submit_states.dart';
import 'package:portal_do_aluno/shared/services/snackbar/app_snackbar.dart';
import 'package:portal_do_aluno/shared/services/snackbar/enum_snack_type.dart';

class SubmitStateListener {
  static VoidCallback attach({
    required BuildContext context,
    required ValueNotifier<SubmitState> state,
    String successMessage = 'Sucesso!',
  }) {
    void listener() {
      final currentState = state.value;
      if (!context.mounted) {
        return;
      }
      if (currentState is Success) {
        AppSnackbar.show(
          context: context,
          message: successMessage,
          type: SnackType.success,
        );
      }
      if (currentState is Error) {
        AppSnackbar.show(
          context: context,
          message: currentState.message,
          type: SnackType.error,
        );
      }
    }
    state.addListener(listener);
    return listener;
  }

  
}
