part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final AuthResponseModel authResponseModel;

  LoginSuccess({required this.authResponseModel});
}

final class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}

final class ResetPasswordLoading extends LoginState {}

final class ResetPasswordSuccess extends LoginState {
  final AuthResponseModel authResponseModel;
  ResetPasswordSuccess({required this.authResponseModel});
}

final class ResetPasswordFailure extends LoginState {
  final String errorMessage;
  ResetPasswordFailure(this.errorMessage);
}

final class ForgotPasswordLoading extends LoginState {}
final class ForgotPasswordSuccess extends LoginState {
  final AuthResponseModel authResponseModel;
  ForgotPasswordSuccess({required this.authResponseModel});
}
final class ForgotPasswordFailure extends LoginState {
  final String errorMessage;
  ForgotPasswordFailure(this.errorMessage);
}


