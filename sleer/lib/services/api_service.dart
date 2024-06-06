import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sleer/config/config_api_routes.dart';

class ApiService {
  final Dio _dio = Dio();
  static const String _baseUrl = ConfigApiRoutes.baseURL;

  // Khởi tạo các header và option mặc định
  ApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    };
    // Thêm interceptor nếu cần
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Xử lý trước khi gửi yêu cầu
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Xử lý phản hồi
        return handler.next(response);
      },
      onError: (error, handler) {
        // Xử lý lỗi
        return handler.next(error);
      },
    ));
  }

  // Hàm gọi API GET
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      // Xử lý lỗi ở đây
      throw Exception('Lỗi khi gọi API: $e');
    }
  }

  // Hàm gọi API POST
  Future<Response> post(String path, dynamic data,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.post(path, data: data, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      // Xử lý lỗi ở đây
      throw Exception('Lỗi khi gọi API: $e');
    }
  }

  // Hàm gọi API PUT
  Future<Response> put(String path, dynamic data,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.put(path, data: data, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      // Xử lý lỗi ở đây
      throw Exception('Lỗi khi gọi API: $e');
    }
  }

  // Hàm gọi API DELETE
  Future<Response> delete(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.delete(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      // Xử lý lỗi ở đây
      throw Exception('Lỗi khi gọi API: $e');
    }
  }
}
