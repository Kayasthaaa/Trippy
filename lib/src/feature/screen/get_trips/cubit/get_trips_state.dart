import 'package:trippy/src/feature/screen/get_trips/models/get_trips_model_class.dart';

abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<Data> trips;

  TripLoaded(this.trips);
}

class TripError extends TripState {
  final String message;

  TripError(this.message);
}
