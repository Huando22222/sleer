import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sleer/models/user.dart';
import 'package:sleer/services/api_service.dart';
import 'package:sleer/services/shared_pref_service.dart';
import 'package:sleer/services/toast_service.dart';

bool isValid(String phone, String password) {
  if ((phone.length >= 10 && phone.startsWith('0')) && password.length >= 8) {
    return true;
  } else {
    return false;
  }
}

class AuthService {
  static Future<User?> authLogin(
    String phone,
    String password,
  ) async {
    if (isValid(phone, password)) {
      final sharedPrefService = SharedPrefService();
      final apiService = ApiService();
      try {
        final data = {
          'phone': phone,
          'password': password,
          // 'phone': "0948025455",
          // 'password': "123456789",
        };
        final response = await apiService.request(
          '/user/login',
          data: jsonEncode(data),
          options: Options(method: 'POST'),
        );

        final statusHandlers = {
          200: (Response response /*, BuildContext context */) async {
            final responseMessage = response.data['message'];
            final responseUser = response.data['user'];
            // final responseToken = response.data['accessToken'];
            debugPrint("before ------ $responseUser");
            final User user = User.fromJson(responseUser);
            //
            await sharedPrefService.setUser(user);
            // final User? auth = await sharedPrefService.getUser();
            showToast(
              msg: "$responseMessage",
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          },
          401: (Response response /* , BuildContext context*/) {
            final responseData = response.data;
            showToast(
              msg: "$responseData",
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.orange,
            );
            debugPrint("Account already exists: ");
          },
        };
        apiService.handleResponse(response, statusHandlers);
      } catch (e) {
        // debugPrint(e.toString());
        // showToast(
        //   msg: "Something wrong!",
        //   gravity: ToastGravity.TOP,
        //   timeInSecForIosWeb: 2,
        //   backgroundColor: Colors.red,
        // );
      }
    }
    return null;
  }
}
// class AuthService {
//   static Future<Auth?> authLogin(
//     String phone,
//     String password,
//   ) async {
//     if (isValid(phone, password)) {
//       try {
//         final response = await http.post(
//           Uri.parse('${ConfigApiRoutes.baseURL}/login'),
//           //
//           body: {
//             'phone': phone,
//             'password': password,
//           },
//         );

//         if (response.statusCode == 200) {
//           final responseData = jsonDecode(response.body);
//           return Auth.fromJson(jsonDecode(responseData['data']));
//         } else {
//           print(response.statusCode);
//           return null;
//         }
//       } catch (e) {
//         print(e);
//       }
//     }
//     return null;
//   }
// }
