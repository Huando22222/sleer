import 'package:sleer/UI/auth/signup/signup_page.dart';
import 'package:sleer/UI/home/home_page.dart';
import 'package:sleer/UI/welcome/welcome_page.dart';

class AppRoutes {
  static const welcome = '/welcome';
  static const home = '/home';
  static const signup = '/signup';

  static final pages = {
    welcome: (context) => const WelComePage(),
    home: (context) => const HomePage(),
    signup: (context) => const SignUpPage(),
  };
}
