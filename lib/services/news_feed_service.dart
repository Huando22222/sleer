import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sleer/models/post.dart';
import 'package:sleer/services/api_service.dart';
import 'package:sleer/services/shared_pref_service.dart';
import 'package:sleer/services/util_service.dart';

class NewsFeedService {
  final apiService = GetIt.instance<ApiService>();

  Future<bool> newPost(XFile? picture, String content) async {
    try {
      final sharedPrefService = SharedPrefService();
      final user = await sharedPrefService.getUser();
      FormData formData = FormData.fromMap({
        'id': user!.id,
        'content': content,
        // 'content': 'lock wat i got ♥',
        'image': await MultipartFile.fromFile(picture!.path),
      });

      final response = await apiService.request(
        '/post/new',
        data: formData,
        options: Options(method: 'POST', contentType: 'multipart/form-data'),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error new post: $e');
      return false;
    }
  }

  Future<List<Post>> getPost() async {
    try {
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
