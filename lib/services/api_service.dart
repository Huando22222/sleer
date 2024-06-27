import 'package:flutter/material.dart';
import 'package:sleer/config/config_api_routes.dart';
import 'package:dio/dio.dart';
import 'package:sleer/services/toast_service.dart';

class ApiService {
  final String _baseUrl = ConfigApiRoutes.baseURL;
  final Dio _dio = Dio();
  String? _token;

  ApiService({String? token}) {
    // Cấu hình cho Dio
    _token = token;
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 5);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          // if (response.requestOptions.path.startsWith('/users')) {
          // } else if (response.requestOptions.path.startsWith('/products')) {}

          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          // if (error.requestOptions.path.startsWith('/users')) {
          // } else if (error.requestOptions.path.startsWith('/products')) {}
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response<T>> request<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      showToast(
        msg: "error while trying to send request - server not responding",
        backgroundColor: Colors.orange,
      );
      throw Exception('API error: $e');
    }
  }

  void handleResponse(
    Response response,
    // BuildContext context,
    Map<int, Function(Response /*, BuildContext */)> statusHandlers,
  ) {
    if (statusHandlers.containsKey(response.statusCode)) {
      statusHandlers[response.statusCode]?.call(response /*, context*/);
    } else {
      // Default handling for unspecified status codes
      if (response.statusCode == 500) {
        showToast(
          msg: "Internal server error!",
          backgroundColor: Colors.red,
        );
      } else {
        showToast(
          msg: "Unknown status code",
          backgroundColor: Colors.red,
        );
      }
    }
  }

  void updateToken(String token) {
    _token = token;
  }
}
