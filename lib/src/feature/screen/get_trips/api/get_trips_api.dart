import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetTripApiService {
  late Dio _dio;

  GetTripApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
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

  Future<Response> getTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      throw Exception('User ID not found');
    }

    return await _dio.get('/trip/$userId');
  }
}
