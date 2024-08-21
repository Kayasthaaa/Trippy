import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trippy/src/feature/screen/get_profile/cubit/get_profile_state.dart';
import 'package:trippy/src/feature/screen/get_profile/repo/get_profile_repo.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  final GetProfileRepository _apiService;

  GetProfileCubit(this._apiService) : super(GetProfileState.initial());

  void fetchUserList() {
    if (state.userList != null) return;

    emit(state.copyWith(isLoading: true, error: null));

    _apiService
        .getUserList()
        .then((userList) =>
            emit(state.copyWith(isLoading: false, userList: userList)))
        .catchError((error) =>
            emit(state.copyWith(isLoading: false, error: error.toString())));
  }
}
