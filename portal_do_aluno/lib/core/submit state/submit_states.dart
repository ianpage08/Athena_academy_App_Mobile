abstract class SubmitState {}


class Initial extends SubmitState {}

class SubmitLoading extends SubmitState {}

class SubmitSuccess extends SubmitState {
  final String message;

  SubmitSuccess(this.message);
}


class SubmitError extends SubmitState {
  final String message;

  SubmitError(this.message);
}




