import 'package:dio/dio.dart';
import 'package:trippy/src/feature/screen/register_screen/models/error.dart';
import 'package:trippy/src/feature/screen/register_screen/models/register_models.dart';
import 'package:trippy/src/feature/screen/register_screen/register_api/register_api.dart';

class RegisterRepository {
  final RegisterApiService _apiService;

  RegisterRepository(this._apiService);

  Future<dynamic> registerUser(
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
        throw ErrorResponse.fromJson(response.data);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          throw ErrorResponse.fromJson(errorData);
        } else {
          throw ErrorResponse(
            message: 'Unexpected error format',
            errors: {},
          );
        }
      }
      throw ErrorResponse(
        message: e.toString(),
        errors: {},
      );
    }
  }
}
