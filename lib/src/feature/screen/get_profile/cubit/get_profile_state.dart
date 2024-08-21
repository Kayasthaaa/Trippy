import 'package:trippy/src/feature/screen/get_profile/models/get_profile_models.dart';

class GetProfileState {
  final bool isLoading;
  final GetProfileModels? userList;
  final String? error;

  GetProfileState({
    this.isLoading = false,
    this.userList,
    this.error,
  });

  GetProfileState copyWith({
    bool? isLoading,
    GetProfileModels? userList,
    String? error,
  }) {
    return GetProfileState(
      isLoading: isLoading ?? this.isLoading,
      userList: userList ?? this.userList,
      error: error ?? this.error,
    );
  }

  static GetProfileState initial() {
    return GetProfileState();
  }
}
