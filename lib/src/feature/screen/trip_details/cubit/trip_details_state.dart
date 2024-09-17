import 'package:trippy/src/feature/screen/trip_details/models/trip_details_models.dart';

class GetTripDetailsState {
  final bool isLoading;
  final TripDetailsModels? trips;
  final String? error;

  GetTripDetailsState({
    this.isLoading = false,
    this.trips,
    this.error,
  });

  GetTripDetailsState copyWith({
    bool? isLoading,
    TripDetailsModels? trips,
    String? error,
  }) {
    return GetTripDetailsState(
      isLoading: isLoading ?? this.isLoading,
      trips: trips ?? this.trips,
      error: error ?? this.error,
    );
  }

  static GetTripDetailsState initial() {
    return GetTripDetailsState();
  }
}
