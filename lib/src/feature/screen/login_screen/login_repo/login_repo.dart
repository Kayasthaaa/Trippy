import 'package:trippy/src/feature/screen/login_screen/login_api/login_api.dart';
import 'package:trippy/src/feature/screen/login_screen/models/error_models.dart';
import 'package:trippy/src/feature/screen/login_screen/models/login_models.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<UserModel> loginUser(String name, String password) async {
    try {
      final response = await _apiService.post('/login', data: {
        'identifier': name,
        'password': password,
      });
      if (response.statusCode == 200 && response.data['success']) {
        return UserModel.fromJson(response.data);
      } else {
        // Throw only the error message, not the entire Exception
        throw ErrorModel.fromJson(response.data).message;
      }
    } catch (e) {
      // Ensure the error message is passed up cleanly
      throw e.toString().replaceAll('Exception:', '').trim();
    }
  }
}
