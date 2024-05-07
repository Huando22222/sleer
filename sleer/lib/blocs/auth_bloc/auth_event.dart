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

class AuthLogoutEvent extends AuthEvent {}
