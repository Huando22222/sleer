import 'package:sleer/models/auth.dart';
import 'package:sleer/models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthErrorState extends AuthState {
  String message;
  AuthErrorState({
    required this.message,
  });
}

class AuthLoginState extends AuthState {
  User auth;
  AuthLoginState({
    required this.auth,
  });
}

class AuthLogoutState extends AuthState {}
