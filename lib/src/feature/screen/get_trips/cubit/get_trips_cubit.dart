import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trippy/src/feature/screen/get_trips/cubit/get_trips_state.dart';
import 'package:trippy/src/feature/screen/get_trips/repo/get_trips_repo.dart';

class TripCubit extends Cubit<TripState> {
  final GetTripRepository _repository;

  TripCubit(this._repository) : super(TripInitial());

  Future<void> getTrips() async {
    emit(TripLoading());
    try {
      final tripResponse = await _repository.getTrips();
      if (tripResponse.data != null) {
        emit(TripLoaded(tripResponse.data!));
      } else {
        emit(TripError('No trips found'));
      }
    } catch (e) {
      emit(TripError(e.toString()));
    }
  }

  void resetState() {
    emit(TripInitial());
  }
}
