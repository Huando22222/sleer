import 'package:sleer/UI/auth/login/login_page.dart';
import 'package:sleer/UI/auth/profile/profile_page.dart';
import 'package:sleer/UI/auth/signup/signup_page.dart';
import 'package:sleer/UI/home/home_page.dart';

// import '../UI/auth/signup/test.dart';

class ConfigRoutes {
  static const test = '/test';
  static const welcome = '/welcome';
  static const home = '/home';
  static const login = '/login';
  static const signup = '/signup';
  // static const signupPhoneNumber = '/signup_phone_number';
  // static const signupVerifyOTP = '/signup_otp';
  static const signupPhoneNumber = '/signup/phone_number';
  static const signupVerifyOTP = '/signup/otp';

  static final pages = {
    test: (context) => const ProfilePage(),
    home: (context) => const HomePage(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignUpPage(),
  };
}
