part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class LogininProgressState extends AuthState {}

class LoginSucessState extends AuthState {}

class LoginErrorState extends AuthState {
  final String error;
  LoginErrorState({required this.error});
}
