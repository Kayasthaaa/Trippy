import 'package:trippy/src/feature/screen/login_screen/models/login_models.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final UserModel user;
  UserSuccess(this.user);
}

class UserError extends UserState {
  final String error;
  UserError(this.error);
}
