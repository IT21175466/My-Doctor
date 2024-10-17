import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_doctor/repositories/user_data_repository.dart';
import 'package:my_doctor/services/secure_storage.dart';

part 'userdata_event.dart';
part 'userdata_state.dart';

class UserdataBloc extends Bloc<UserdataEvent, UserdataState> {
  final UserDataRepository _userDataRepository = UserDataRepository();

  UserdataBloc() : super(UserdataInitial()) {
    on<GettingUserDataRequestEvent>(gettingUserDataRequestEvent);
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
}
