import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleer/models/user.dart';

class SharedPrefService {
  Future writeCache({required String key, required String value}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    bool isSaved = await pref.setString(key, value);
    debugPrint("pref save $isSaved: $key-$value");
  }

  Future<String?> readCache({required String key}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    String? value = pref.getString(key);

    if (value != null) {
      return value;
    }
    return null;
  }

  Future<void> setUser(User user) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String userJson = jsonEncode(user.toJson());
    await pref.setString('user', userJson);
  }

  Future<User?> getUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String? userJson = pref.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }
    return null;
  }

  Future<bool> removeCache({required String key}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    bool isRemoved = await pref.remove(key);
    return isRemoved;
  }

  Future<bool> clearCache() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    bool isCleared = await pref.clear();
    return isCleared;
  }
}
