abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String? userName;
  final String? email;

  LoginSuccess({this.userName, this.email});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}
