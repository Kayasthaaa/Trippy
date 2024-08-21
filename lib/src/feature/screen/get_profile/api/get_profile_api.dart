import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trippy/src/constant/app_url.dart';

class GetProfileApiService {
  late Dio _dio;

  GetProfileApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 13),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('user_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      _checkStatusCode(response);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path,
      {required Map<String, dynamic> data}) async {
    try {
      final response = await _dio.post(path, data: data);
      _checkStatusCode(response);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  void _checkStatusCode(Response response) {
    if (response.statusCode! < 200 || response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'HTTP status error: ${response.statusCode}',
      );
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Connection timed out');
        case DioExceptionType.badResponse:
          return Exception(
              'Server responded with error ${error.response?.statusCode}: ${error.response?.statusMessage}');
        case DioExceptionType.cancel:
          return Exception('Request cancelled');
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return Exception('No internet connection');
          }
          return Exception('Unexpected error occurred');
        default:
          return Exception('Network error occurred');
      }
    }
    return Exception('An unexpected error occurred');
  }
}
