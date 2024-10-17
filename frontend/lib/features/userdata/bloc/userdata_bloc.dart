import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_doctor/repositories/user_data_repository.dart';
import 'package:my_doctor/services/auth_services.dart';
import 'package:my_doctor/services/secure_storage.dart';

part 'userdata_event.dart';
part 'userdata_state.dart';

class UserdataBloc extends Bloc<UserdataEvent, UserdataState> {
  final UserDataRepository _userDataRepository = UserDataRepository();
  final AuthServices _authServices = AuthServices();

  UserdataBloc() : super(UserdataInitial()) {
    on<GettingUserDataRequestEvent>(gettingUserDataRequestEvent);
    on<LoginingOutEvent>(loginingOutEvent);
  }

  FutureOr<void> gettingUserDataRequestEvent(
      GettingUserDataRequestEvent event, Emitter<UserdataState> emit) async {
    String? token = '';
    try {
      emit(GettingLoggedUserDataState());
      token = await SecureStorage().getSessionToken();
      await _userDataRepository.getUserEmail(token!);
      emit(GettingLoggedUserDataSucessState(
          email: _userDataRepository.userEmail));
    } catch (e) {
      emit(GettingLoggedUserDataErrorState(error: e.toString()));
    }
  }

  FutureOr<void> loginingOutEvent(
      LoginingOutEvent event, Emitter<UserdataState> emit) async {
    try {
      emit(LoggingOutState());
      await SecureStorage().deleteSessionToken();
      await _authServices.signOutFromGoogle();
      await _authServices.signOutFromFacebook();
      emit(LoggingOutSucessState());
    } catch (e) {
      emit(LoggingOutErrorState(error: e.toString()));
    }
  }
}
