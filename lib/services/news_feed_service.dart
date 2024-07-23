import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sleer/models/post.dart';
import 'package:sleer/services/api_service.dart';
import 'package:sleer/services/shared_pref_service.dart';
import 'package:sleer/services/util_service.dart';

class NewsFeedService {
  static Future<void> newPost() async {}
  static Future<List<Post>> getPost() async {
    try {
      final apiService = GetIt.instance<ApiService>();
      final sharedPrefService = SharedPrefService();
      final response = await apiService.request(
        '/post/',
        options: Options(method: 'GET'),
      );
      final statusHandlers = {
        200: (Response response) async {
          final responseData = response.data['data'] as List<dynamic>;
          List<Post> listPosts =
              responseData.map((post) => Post.fromJson(post)).toList();
          sharedPrefService.setListPosts(listPosts);
          return listPosts;
        },
        401: (Response response) {
          final responseData = response.data;
          UtilService.showToast(
            msg: "$responseData",
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.orange,
          );
        },
      };
      return await apiService.handleResponse(response, statusHandlers);
      // return [];
    } catch (e) {
      debugPrint("newfeedservice: $e");
      return [];
    }
  }
}
