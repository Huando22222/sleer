import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleer/models/post.dart';
import 'package:sleer/models/user.dart';

class SharedPrefService {
  Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setCache({required String key, required String value}) async {
    final SharedPreferences pref = await _getPreferences();
    bool isSaved = await pref.setString(key, value);
    debugPrint("pref save $isSaved: $key-$value");
  }

  Future<String?> getCache({required String key}) async {
    final SharedPreferences pref = await _getPreferences();
    return pref.getString(key);
  }

  Future<void> setToken(String token) async {
    await setCache(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await getCache(key: 'token');
  }

  Future<void> setUser(User user) async {
    final SharedPreferences pref = await _getPreferences();
    final String userJson = jsonEncode(user.toJson());
    await pref.setString('user', userJson);
  }

  Future<User?> getUser() async {
    final SharedPreferences pref = await _getPreferences();
    final String? userJson = pref.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }
    return null;
  }

  Future<void> setListPosts(List<Post> posts) async {
    final SharedPreferences pref = await _getPreferences();
    final List<String> postJsonList =
        posts.map((post) => jsonEncode(post.toJson())).toList();
    await pref.setStringList('posts', postJsonList);
  }

  Future<List<Post>> getListPosts() async {
    final SharedPreferences pref = await _getPreferences();
    final List<String>? postJsonList = pref.getStringList('posts');
    if (postJsonList != null) {
      return postJsonList.map((postJson) {
        final Map<String, dynamic> postMap = jsonDecode(postJson);
        return Post.fromJson(postMap);
      }).toList();
    }
    return [];
  }

  Future<bool> removeCache({required String key}) async {
    final SharedPreferences pref = await _getPreferences();
    return await pref.remove(key);
  }

  Future<bool> clearCache() async {
    final SharedPreferences pref = await _getPreferences();
    return await pref.clear();
  }
}
