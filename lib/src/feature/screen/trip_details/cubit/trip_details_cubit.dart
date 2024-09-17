import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trippy/src/feature/screen/trip_details/cubit/trip_details_state.dart';
import 'package:trippy/src/feature/screen/trip_details/repo/trip_details_repo.dart';

class GetTripDetailsCubit extends Cubit<GetTripDetailsState> {
  final GetTripDetailsRepository _apiService;

  GetTripDetailsCubit(this._apiService) : super(GetTripDetailsState.initial());

  void fetchTripDetails(String tripId) {
    if (state.trips != null) return;

    emit(state.copyWith(isLoading: true, error: null));

    _apiService
        .getTripDetails(tripId)
        .then((trips) => emit(state.copyWith(isLoading: false, trips: trips)))
        .catchError((error) =>
            emit(state.copyWith(isLoading: false, error: error.toString())));
  }
}