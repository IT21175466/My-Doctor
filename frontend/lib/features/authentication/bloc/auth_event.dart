part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginButtonClickedEvent extends AuthEvent {
  final String email;
  final String password;
  LoginButtonClickedEvent({required this.email, required this.password});
}
