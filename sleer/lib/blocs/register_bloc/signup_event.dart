abstract class SignUpEvent {}

class SignUpInitialEvent extends SignUpEvent {}

class SignUpSentOTPEvent extends SignUpEvent {}

class SignUpVerifyPhoneNumberEvent extends SignUpEvent {}

class SignUpVerifyPasswordEvent extends SignUpEvent {}

class SignUpedEvent extends SignUpEvent {}
