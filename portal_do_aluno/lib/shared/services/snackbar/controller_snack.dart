import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:portal_do_aluno/core/submit%20state/submit_states.dart';
import 'package:portal_do_aluno/shared/services/snackbar/app_snackbar.dart';
import 'package:portal_do_aluno/shared/services/snackbar/enum_snack_type.dart';

class SubmitStateListener {
  static VoidCallback attach({
    required BuildContext context,
    required ValueNotifier<SubmitState> state,
    final String? message,
    
  }) {
    SubmitState? lastState;
    void listener() {
      final currentState = state.value;

      if (!context.mounted) {
        return;
      }
      // evita a reexecução do listener
      if (currentState == lastState) {
        return;
      }
      
      lastState = currentState;

      switch (currentState) {
        case (SubmitSuccess()):
          AppSnackbar.show(
            context: context,
            message: currentState.message,
            type: SnackType.success,
          );
          break;
        case (SubmitError()):
          AppSnackbar.show(
            context: context,
            message: currentState.message ,
            type: SnackType.error,
          );
          break;
          case (SubmitLoading()):
          // loading não dispara snackbar por design
          break;

        default:
          break;
      }
    }

    state.addListener(listener);
    return () => state.removeListener(listener);
  }
}
