import 'package:sleer/models/user.dart';

abstract class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String phone;
  final String password;

  AuthLoginEvent({
    required this.phone,
    required this.password,
  });
}

class AuthKeepLoginEvent extends AuthEvent {
  final User auth;

  AuthKeepLoginEvent({required this.auth});
}

class AuthLogoutEvent extends AuthEvent {}
