import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleer/blocs/auth_bloc/auth_event.dart';
import 'package:sleer/blocs/auth_bloc/auth_state.dart';
import 'package:sleer/models/auth.dart';
import 'package:sleer/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>(authLogin);
  }

  FutureOr<void> authLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      Auth? auth = await AuthService.authLogin(event.phone, event.password);
      if (auth != null) {
        emit(AuthLoginState(auth: auth));
      } else {
        emit(AuthErrorState(message: 'Login failed'));
      }
    } catch (e) {
      emit(AuthErrorState(message: 'An error occurred'));
    }
  }
}
