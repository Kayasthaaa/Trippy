import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trippy/src/feature/screen/register_screen/cubit/register_state.dart';
import 'package:trippy/src/feature/screen/register_screen/register_repo/register_repo.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository _userRepository;

  RegisterCubit(this._userRepository) : super(RegisterInitial());

  Future<void> registerUser(
    String fname,
    String password,
    String uname,
    String cpassword,
    String address,
    String num,
    String email,
    String bio,
  ) async {
    emit(RegisterLoading()); // Emit loading state
    try {
      final user = await _userRepository.registerUser(
          fname, password, uname, cpassword, address, num, email, bio);

      emit(RegisterSuccess(user)); // Emit success state
    } catch (e) {
      emit(RegisterError(e.toString())); // Emit error state
    }
  }
}
