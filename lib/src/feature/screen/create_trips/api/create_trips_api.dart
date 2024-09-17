import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trippy/src/constant/app_url.dart';

class PostTripApiService {
  late Dio _dio;

  PostTripApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiUrl.baseUrl, // Update with the correct base URL
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

  Future<Response> postTrip(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiUrl.kCreateTrips, data: data);
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
