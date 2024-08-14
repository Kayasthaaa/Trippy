import 'package:trippy/src/feature/screen/home_screen/models/home_screen_models.dart';

class HomeState {
  final bool isLoading;
  final HomeModel? userList;
  final String? error;

  HomeState({
    this.isLoading = false,
    this.userList,
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    HomeModel? userList,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      userList: userList ?? this.userList,
      error: error ?? this.error,
    );
  }

  static HomeState initial() {
    return HomeState();
  }
}
