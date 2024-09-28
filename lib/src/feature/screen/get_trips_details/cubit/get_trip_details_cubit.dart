import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trippy/src/feature/screen/get_trips_details/repo/get_trips_details_repo.dart';
import 'get_trip_details_state.dart';

class GetCreatedTripDetailsCubit extends Cubit<GetCreatedTripDetailsState> {
  final GetCreatedTripDetailsRepository repository;

  GetCreatedTripDetailsCubit(this.repository) : super(GetTripDetailsInitial());

  Future<void> fetchTripDetails(int tripId) async {
    emit(GetTripDetailsLoading());
    try {
      final tripDetails = await repository.fetchTripDetails(tripId);
      emit(GetTripDetailsLoaded(tripDetails));
    } catch (e) {
      emit(GetTripDetailsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    // Perform any cleanup here
    return super.close();
  }
}
