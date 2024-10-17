part of 'userdata_bloc.dart';

@immutable
sealed class UserdataState {}

final class UserdataInitial extends UserdataState {}

class GettingLoggedUserDataState extends UserdataState {}

class GettingLoggedUserDataSucessState extends UserdataState {
  final String email;
  GettingLoggedUserDataSucessState({required this.email});
}

class GettingLoggedUserDataErrorState extends UserdataState {
  final String error;
  GettingLoggedUserDataErrorState({required this.error});
}
