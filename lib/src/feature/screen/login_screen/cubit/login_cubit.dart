import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trippy/src/feature/screen/login_screen/cubit/login_screen_state.dart';
import 'package:trippy/src/feature/screen/login_screen/login_repo/login_repo.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(this._userRepository) : super(UserInitial());

  Future<void> loginUser(String name, String password) async {
    emit(UserLoading()); // Emit loading state
    try {
      final user = await _userRepository.loginUser(name, password);
      await _saveUserCredentials(user.accessToken, user.userId);

      emit(UserSuccess(user)); // Emit success state
    } catch (e) {
      emit(UserError(e.toString())); // Emit error state
    }
  }

  Future<void> logout() async {
    await _clearUserCredentials();
    emit(UserInitial()); // Emit initial state on logout
  }

  Future<void> _saveUserCredentials(String token, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
    await prefs.setInt('user_id', userId);
  }

  Future<void> _clearUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_id');
  }
}
