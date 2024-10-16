import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_doctor/repositories/auth_repository.dart';
import 'package:my_doctor/services/auth_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();
  final AuthServices _authServices = AuthServices();

  AuthBloc() : super(AuthInitial()) {
    on<SignUpButtonClickedEvent>(signUpButtonClickedEvent);
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
    on<ValidatingSessionEvent>(validatingSessionEvent);
    on<LoginWithGoogleButtonClickedEvent>(loginWithGoogleButtonClickedEvent);
    on<LoginWithFacebookButtonClickedEvent>(
        loginWithFacebookButtonClickedEvent);
  }

  FutureOr<void> signUpButtonClickedEvent(
      SignUpButtonClickedEvent event, Emitter<AuthState> emit) async {
    try {
      emit(SignUpProgressState());
      await _authRepository.manualSignUp(event.email, event.password);
      emit(SignUpSucessState());
    } catch (e) {
      emit(SignUpErrorState(error: e.toString()));
    }
  }

  FutureOr<void> loginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoginProgressState());
      await _authRepository.manualLogin(event.email, event.password);
      emit(LoginSucessState());
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }

  FutureOr<void> validatingSessionEvent(
      ValidatingSessionEvent event, Emitter<AuthState> emit) async {
    try {
      emit(ValidatingSessionState());
      await _authRepository.validateSession(event.token);
      emit(ValidatingSessionSucessState(
          isValiedSession: _authRepository.isValiedSession));
    } catch (e) {
      emit(ValidatingSessionErrorState(error: e.toString()));
    }
  }

  FutureOr<void> loginWithGoogleButtonClickedEvent(
      LoginWithGoogleButtonClickedEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoginingWithGoogleState());
      await _authServices.signInWithGoogle();
      emit(LoginingWithGoogleSucessState());
    } catch (e) {
      emit(LoginingWithGoogleErrorState(error: e.toString()));
    }
  }

  FutureOr<void> loginWithFacebookButtonClickedEvent(
      LoginWithFacebookButtonClickedEvent event,
      Emitter<AuthState> emit) async {
    try {
      emit(LoginingWithFacebookState());
      await _authServices.signInWithFacebook();
      emit(LoginingWithFacebookSucessState());
    } catch (e) {
      emit(LoginingWithFacebookErrorState(error: e.toString()));
    }
  }
}
