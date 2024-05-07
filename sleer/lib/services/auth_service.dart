import 'dart:convert';

import 'package:sleer/config/app_api_routes.dart';
import 'package:sleer/models/auth.dart';
import 'package:http/http.dart' as http;

bool isValid(String phone, String password) {
  if ((phone.length >= 10 && phone.startsWith('0')) && password.length >= 8) {
    return true;
  } else {
    return false;
  }
}

class AuthService {
  static Future<Auth?> authLogin(
    String phone,
    String password,
  ) async {
    if (isValid(phone, password)) {
      try {
        final response = await http.post(
          Uri.parse(AppApiRoutes.loginAuth),
          //
          body: {
            'phone': phone,
            'password': password,
          },
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          return Auth.fromJson(jsonDecode(responseData['data']));
        } else {
          print(response.statusCode);
          return null;
        }
      } catch (e) {
        print(e);
      }
    }
    return null;
  }
}
