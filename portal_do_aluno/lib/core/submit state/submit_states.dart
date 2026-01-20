import 'package:portal_do_aluno/core/errors/app_error.dart';

abstract class SubmitState {}


class Initial extends SubmitState {}

class SubmitLoading extends SubmitState {}

class SubmitSuccess extends SubmitState {
  final String message;

  SubmitSuccess(this.message);
}


class SubmitError extends SubmitState {
  final AppError message;

  SubmitError(this.message);
}




