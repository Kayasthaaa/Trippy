import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trippy/src/feature/screen/get_trips_details/get_trips_details_models/created_trips_model.dart';

class GetCreatedTripDetailsApi {
  final Dio _dio = Dio();

  GetCreatedTripDetailsApi() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('user_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<CreatedTripDetailsModels> fetchTripDetails(int tripId) async {
    try {
      final response =
          await _dio.get('http://127.0.0.1:8000/api/trip/details/$tripId');
      return CreatedTripDetailsModels.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch trip details: ${e.toString()}');
    }
  }
}
