import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:portal_do_aluno/core/errors/app_error.dart';
import 'package:portal_do_aluno/shared/services/snackbar/enum_snack_type.dart';
import 'package:portal_do_aluno/shared/services/snackbar/snack_bar_config.dart';

class AppSnackbar {
  static Flushbar? _current;

  static void show({
    required BuildContext context,
    required String message,
    SnackType type = SnackType.info,
  }) {
    _current?.dismiss();

    final config = SnackBarConfig.fromType(type);

    _current = Flushbar(
      message: message ,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: config.color,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(12),
    )..show(context);
  }
}
