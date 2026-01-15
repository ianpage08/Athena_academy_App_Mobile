import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/services/snackbar/enum_snack_type.dart';

class SnackBarConfig {
  final Color color;
  SnackBarConfig(this.color);

  factory SnackBarConfig.fromType(SnackType type){
    switch(type){
      case SnackType.success:
        return SnackBarConfig(Colors.green);
      case SnackType.error:
        return SnackBarConfig(Colors.red);
      case SnackType.warning:
        return SnackBarConfig(Colors.amber);
      case SnackType.info:
        return SnackBarConfig(Colors.blue);
      
    }
  }

}