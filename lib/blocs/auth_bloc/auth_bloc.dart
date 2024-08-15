import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleer/blocs/auth_bloc/auth_event.dart';
import 'package:sleer/blocs/auth_bloc/auth_state.dart';
import 'package:sleer/models/user.dart';
import 'package:sleer/services/auth_service.dart';
import 'package:sleer/services/shared_pref_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _pref = SharedPrefService();
  final service = FlutterBackgroundService();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>(authLogin);

    // on<AuthInitialEvent>((event, emit) {
    //   emit(AuthLoginState());
    // });

    on<AuthKeepLoginEvent>((event, emit) {
      emit(AuthLoggedinState(auth: event.auth));
    });

    on<AuthLogoutEvent>((event, emit) async {
      try {
        await _pref.clearCache();
        //call api to log out
        final service = FlutterBackgroundService();
        service.invoke('stopService');
        service.startService();
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
        final service = FlutterBackgroundService();
        service.invoke('stopService');
        service.startService();
        debugPrint("logged in: ${auth.phone}");
        emit(AuthLoggedinState(auth: auth));
      } else {
        emit(AuthErrorState(message: 'Login failed '));
      }
    } catch (e) {
      emit(AuthErrorState(message: 'An error occurred in bloc'));
    }
  }
}
