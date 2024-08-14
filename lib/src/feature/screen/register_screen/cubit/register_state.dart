import 'package:trippy/src/feature/screen/register_screen/models/register_models.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterResponse user;
  RegisterSuccess(this.user);
}

class RegisterError extends RegisterState {
  final String error;
  RegisterError(this.error);
}