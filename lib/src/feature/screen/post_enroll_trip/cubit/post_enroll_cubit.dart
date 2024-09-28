import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trippy/src/feature/screen/post_enroll_trip/cubit/post_enroll_state.dart';
import 'package:trippy/src/feature/screen/post_enroll_trip/repo/post_enroll_repo.dart';

class TripEnrollCubit extends Cubit<TripEnrollState> {
  final TripRepository _repository;

  TripEnrollCubit(this._repository) : super(TripEnrollInitial());

  Future<void> enrollTrip(int tripId) async {
    emit(TripEnrollLoading());
    try {
      final result = await _repository.enrollTrip(tripId);
      emit(TripEnrollSuccess(result));
    } catch (e) {
      emit(TripEnrollError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    // Perform any cleanup here
    return super.close();
  }
}
