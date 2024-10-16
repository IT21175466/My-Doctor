part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignUpButtonClickedEvent extends AuthEvent {
  final String email;
  final String password;
  SignUpButtonClickedEvent({required this.email, required this.password});
}

class LoginButtonClickedEvent extends AuthEvent {
  final String email;
  final String password;
  LoginButtonClickedEvent({required this.email, required this.password});
}
