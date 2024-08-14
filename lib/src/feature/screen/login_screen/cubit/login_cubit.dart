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
      await _saveUserToken(user.accessToken);
      emit(UserSuccess(user)); // Emit success state
    } catch (e) {
      emit(UserError(e.toString())); // Emit error state
    }
  }

  Future<void> logout() async {
    await _clearUserToken();
    emit(UserInitial()); // Emit initial state on logout
  }

  Future<void> _saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
  }

  Future<void> _clearUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.clear();
  }
}
