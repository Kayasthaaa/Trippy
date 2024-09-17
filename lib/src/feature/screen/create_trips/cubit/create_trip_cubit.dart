import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trippy/src/feature/screen/create_trips/api/create_trips_api.dart';
import 'package:trippy/src/feature/screen/create_trips/cubit/create_trips_state.dart';
import 'package:trippy/src/feature/screen/create_trips/models/create_trips_models.dart';

class TripPlannerCubit extends Cubit<TripPlannerState> {
  final PostTripApiService _apiService;

  TripPlannerCubit(this._apiService) : super(TripPlannerInitial());

  Future<void> planTrip(Trip trip) async {
    emit(TripPlannerLoading());

    try {
      final response = await _apiService.postTrip(trip.toJson());
      if (response.statusCode == 200) {
        emit(TripPlannerSuccess(trip));
      } else {
        emit(TripPlannerFailure(
            'Failed to plan trip. Status: ${response.statusCode}'));
      }
    } catch (e) {
      emit(TripPlannerFailure('An error occurred: ${e.toString()}'));
    }
  }
}
