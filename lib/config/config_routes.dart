import 'package:sleer/screens/auth/login/login_page.dart';
import 'package:sleer/screens/auth/profile/profile_page.dart';
import 'package:sleer/screens/auth/signup/signup_page.dart';
import 'package:sleer/screens/page_view_screen.dart';

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
    home: (context) => const PageViewScreen(),
    login: (context) => LoginPage(),
    signup: (context) => const SignUpPage(),
  };
}
