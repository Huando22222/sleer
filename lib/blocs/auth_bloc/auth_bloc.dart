import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleer/blocs/auth_bloc/auth_event.dart';
import 'package:sleer/blocs/auth_bloc/auth_state.dart';
import 'package:sleer/models/user.dart';
import 'package:sleer/services/auth_service.dart';
import 'package:sleer/services/shared_pref_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _pref = SharedPrefService();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>(authLogin);

    on<AuthKeepLoginEvent>((event, emit) {
      emit(AuthLoginState(auth: event.auth));
    });

    on<AuthLogoutEvent>((event, emit) {
      try {
        _pref.clearCache();
        emit(AuthInitial());
      } catch (e) {
        debugPrint("logout");
      }
    });
  }

  FutureOr<void> authLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    // emit(AuthLoadingState());
    try {
      User? auth = await AuthService.authLogin(event.phone, event.password);
      if (auth != null) {
        await _pref.setUser(auth);

        emit(AuthLoginState(auth: auth));
      } else {
        emit(AuthErrorState(message: 'Login failed '));
      }
    } catch (e) {
      emit(AuthErrorState(message: 'An error occurred'));
    }
  }
}
