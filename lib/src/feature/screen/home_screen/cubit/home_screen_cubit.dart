import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trippy/src/feature/screen/home_screen/cubit/home_screen_state.dart';
import 'package:trippy/src/feature/screen/home_screen/repo/home_screen_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeState.initial());

  void fetchUserList() {
    if (state.userList != null) return;

    emit(state.copyWith(isLoading: true, error: null));

    _homeRepository
        .getUserList(2)
        .then((userList) =>
            emit(state.copyWith(isLoading: false, userList: userList)))
        .catchError((error) =>
            emit(state.copyWith(isLoading: false, error: error.toString())));
  }
}
