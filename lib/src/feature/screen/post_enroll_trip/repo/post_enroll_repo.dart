import 'package:shared_preferences/shared_preferences.dart';
import 'package:trippy/src/feature/screen/post_enroll_trip/api/post_enroll_api.dart';

class TripRepository {
  final EnrollApiService _apiService;

  TripRepository(this._apiService);

  Future<Map<String, dynamic>> enrollTrip(int tripId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      throw Exception('User ID not found');
    }

    final response = await _apiService.post(
      '/trip/$tripId/trip-enroll',
      data: {'user_id': userId},
    );
    return response.data;
  }
}
