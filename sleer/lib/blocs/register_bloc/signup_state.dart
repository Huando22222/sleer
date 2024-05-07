abstract class SignUpState {}

class SignUpInitial extends SignUpState {} //1

class SignUpVerifyingState extends SignUpState {}

class SignUpVerifyingOTP extends SignUpState {} //1

class SignUpVerifiedUserState extends SignUpState {} //2

class SignUpVerifiedPasswordState extends SignUpState {} //3

class SignUpedState extends SignUpState {} //3

