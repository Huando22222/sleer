import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sleer/models/user.dart';
import 'package:sleer/services/api_service.dart';
import 'package:sleer/services/shared_pref_service.dart';
import 'package:sleer/services/util_service.dart';

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
    if (/*isValid(phone, password) */ true) {
      // final apiService = ApiService();
      final apiService = GetIt.instance<ApiService>();
      try {
        final data = {
          // 'phone': phone,
          // 'password': password,
          'phone': "0948025455",
          'password': "123456789",
        };
        final response = await apiService.request(
          '/user/login',
          data: jsonEncode(data),
          options: Options(method: 'POST'),
        );

        final statusHandlers = {
          200: (Response response /*, BuildContext context */) async {
            final responseUser = response.data['user'];
            final responseToken = response.data['accessToken'];
            debugPrint("auth_service1: ${responseUser.toString()}");
            final User user = User.fromJson(responseUser);

            final sharedPrefService = SharedPrefService();
            debugPrint("auth_service: ${await sharedPrefService.getToken()}");
            sharedPrefService.setToken(responseToken);
            apiService.updateToken(responseToken);

            return user;
          },
          401: (Response response /* , BuildContext context*/) {
            final responseData = response.data;
            UtilService.showToast(
              msg: "$responseData",
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.orange,
            );
          },
        };
        // apiService.handleResponse(response, statusHandlers);
        return await apiService.handleResponse(response, statusHandlers);
      } catch (e) {
        debugPrint("auth service error: ${e.toString()}");
        UtilService.showToast(
          msg: "Something wrong!",
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
        );
        return null;
      }
    }
    return null;
  }
}
