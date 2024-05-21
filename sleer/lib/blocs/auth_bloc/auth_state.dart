import 'package:sleer/models/auth.dart';

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
  Auth auth;
  AuthLoginState({
    required this.auth,
  });
}

class AuthLogoutState extends AuthState {}

/////////////////////////////////////

class AuthSignUp extends AuthState {} //1

class AuthSignUpVerifyingState extends AuthState {}

class AuthSignUpVerifyingOTP extends AuthState {} //1

class AuthSignUpVerifiedUserState extends AuthState {} //2

class AuthSignUpVerifiedPasswordState extends AuthState {} //3

class AuthSignUpedState extends AuthState {} //3

