import 'package:sleer/config/config_api_routes.dart';
import 'package:dio/dio.dart';

class ApiService {
  final String _baseUrl = ConfigApiRoutes.baseURL;
  final Dio _dio = Dio();

  ApiService() {
    // Cấu hình cho Dio
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 5);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          // if (response.requestOptions.path.startsWith('/users')) {
          // } else if (response.requestOptions.path.startsWith('/products')) {}
          // return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          // if (error.requestOptions.path.startsWith('/users')) {
          // } else if (error.requestOptions.path.startsWith('/products')) {}
          // return handler.next(error);
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
      // Xử lý lỗi ở đây
      throw Exception('API error: $e');
    }
  }
}
