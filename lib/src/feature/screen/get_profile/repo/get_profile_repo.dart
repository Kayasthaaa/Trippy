import 'package:shared_preferences/shared_preferences.dart';
import 'package:trippy/src/feature/screen/get_profile/api/get_profile_api.dart';
import 'package:trippy/src/feature/screen/get_profile/models/get_profile_models.dart';

class GetProfileRepository {
  final GetProfileApiService _apiService;

  GetProfileRepository(this._apiService);

  Future<GetProfileModels> getUserList() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    // Make sure userId is not null
    if (userId == null) {
      throw Exception('User ID not found');
    }

    final response = await _apiService.get('/profile/$userId');

    return GetProfileModels.fromJson(response.data);
  }
}
