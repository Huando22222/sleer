import 'package:sleer/UI/auth/login/login_page.dart';
import 'package:sleer/UI/auth/signup/signup_input_otp.dart';
import 'package:sleer/UI/auth/signup/signup_input_phone_number.dart';
import 'package:sleer/UI/auth/signup/signup_page.dart';
import 'package:sleer/UI/home/home_page.dart';
import 'package:sleer/UI/welcome/welcome_page.dart';

// import '../UI/auth/signup/test.dart';

class AppRoutes {
  static const welcome = '/welcome';
  static const home = '/home';
  static const login = '/login';
  static const signup = '/signup';
  // static const signupPhoneNumber = '/signup_phone_number';
  // static const signupVerifyOTP = '/signup_otp';
  static const signupPhoneNumber = '/signup/phone_number';
  static const signupVerifyOTP = '/signup/otp';

  static final pages = {
    welcome: (context) => const WelComePage(),
    home: (context) => const HomePage(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignUpPage(),
    signupPhoneNumber: (context) => const SignUpInputPhoneNumber(),
    signupVerifyOTP: (context) => const SignUpInputOTP(),
  };
}
