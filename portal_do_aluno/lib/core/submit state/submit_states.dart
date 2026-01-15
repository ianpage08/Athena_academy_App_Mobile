abstract class SubmitState {}


class Initial extends SubmitState {}

class Loading extends SubmitState {}

class Success extends SubmitState {}


class Error extends SubmitState {
  final String message;

  Error(this.message);
}




