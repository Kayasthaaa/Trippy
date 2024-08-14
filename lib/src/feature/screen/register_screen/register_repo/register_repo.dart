import 'package:trippy/src/feature/screen/login_screen/models/error_models.dart';
import 'package:trippy/src/feature/screen/register_screen/models/register_models.dart';
import 'package:trippy/src/feature/screen/register_screen/register_api/register_api.dart';

class RegisterRepository {
  final RegisterApiService _apiService;

  RegisterRepository(this._apiService);

  Future<RegisterResponse> registerUser(
    String fname,
    String password,
    String uname,
    String cpassword,
    String address,
    String num,
    String email,
    String bio,
  ) async {
    try {
      final response = await _apiService.post('/register', data: {
        'name': fname,
        'username': uname,
        'email': email,
        'password': password,
        'password_confirmation': cpassword,
        'contact': num,
        'address': address,
        'bio': bio
      });
      if (response.statusCode == 201) {
        return RegisterResponse.fromJson(response.data);
      } else {
        throw ErrorModel.fromJson(response.data).message;
      }
    } catch (e) {
      // Ensure the error message is passed up cleanly
      throw e.toString().replaceAll('Exception:', '').trim();
    }
  }
}
