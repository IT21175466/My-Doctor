part of 'userdata_bloc.dart';

@immutable
sealed class UserdataEvent {}

class GettingUserDataRequestEvent extends UserdataEvent {}
