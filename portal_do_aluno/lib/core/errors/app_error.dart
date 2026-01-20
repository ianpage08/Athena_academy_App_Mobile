import 'package:portal_do_aluno/core/errors/app_error_type.dart';

class AppError {
  final AppErrorType type;
  final String message;

  AppError({required this.type,required this.message});


}
