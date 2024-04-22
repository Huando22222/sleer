import 'package:sleer/UI/home/home_page.dart';
import 'package:sleer/UI/welcome/welcome_page.dart';

class AppRoutes {
  static const welcome = '/welcome';
  static const home = '/home';

  static final pages = {
    welcome: (context) => WelComePage(),
    home: (context) => HomePage(),
  };
}
