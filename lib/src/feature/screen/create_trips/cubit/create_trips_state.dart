import 'package:equatable/equatable.dart';
import 'package:trippy/src/feature/screen/create_trips/models/create_trips_models.dart';

abstract class TripPlannerState extends Equatable {
  const TripPlannerState();

  @override
  List<Object> get props => [];
}

class TripPlannerInitial extends TripPlannerState {}

class TripPlannerLoading extends TripPlannerState {}

class TripPlannerSuccess extends TripPlannerState {
  final Trip trip;

  const TripPlannerSuccess(this.trip);

  @override
  List<Object> get props => [trip];
}

class TripPlannerFailure extends TripPlannerState {
  final String error;

  const TripPlannerFailure(this.error);

  @override
  List<Object> get props => [error];
}
