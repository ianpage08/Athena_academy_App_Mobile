import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/submit%20state/submit_states.dart';

class SubmitStateBuilder extends StatelessWidget {
  final ValueListenable<SubmitState> listenable;
  final Widget initial;
  final Widget loading;
  final Widget Function(String message)? error;

  const SubmitStateBuilder({
    super.key,
    required this.listenable,
    required this.initial,
    required this.loading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SubmitState>(
      valueListenable: listenable,
      builder: (_, state, __) {
        if (state is SubmitLoading) {
          return loading;
        }

        if (state is SubmitError) {
          if (error != null) {
            return error!(state.message.message);
          }
          return const SizedBox.shrink();
        }

        return initial;
      },
    );
  }
}
