part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class SignUpProgressState extends AuthState {}

class SignUpSucessState extends AuthState {}

class SignUpErrorState extends AuthState {
  final String error;
  SignUpErrorState({required this.error});
}

class LoginProgressState extends AuthState {}

class LoginSucessState extends AuthState {}

class LoginErrorState extends AuthState {
  final String error;
  LoginErrorState({required this.error});
}

class ValidatingSessionState extends AuthState {}

class ValidatingSessionSucessState extends AuthState {
  final bool isValiedSession;
  ValidatingSessionSucessState({required this.isValiedSession});
}

class ValidatingSessionErrorState extends AuthState {
  final String error;
  ValidatingSessionErrorState({required this.error});
}

class LoginingWithGoogleState extends AuthState {}

class LoginingWithGoogleSucessState extends AuthState {}

class LoginingWithGoogleErrorState extends AuthState {
  final String error;
  LoginingWithGoogleErrorState({required this.error});
}
