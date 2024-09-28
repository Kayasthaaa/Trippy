import 'package:equatable/equatable.dart';
import 'package:trippy/src/feature/screen/get_trips_details/get_trips_details_models/created_trips_model.dart';

abstract class GetCreatedTripDetailsState extends Equatable {
  const GetCreatedTripDetailsState();

  @override
  List<Object> get props => [];
}

class GetTripDetailsInitial extends GetCreatedTripDetailsState {}

class GetTripDetailsLoading extends GetCreatedTripDetailsState {}

class GetTripDetailsLoaded extends GetCreatedTripDetailsState {
  final CreatedTripDetailsModels tripDetails;

  const GetTripDetailsLoaded(this.tripDetails);

  @override
  List<Object> get props => [tripDetails];
}

class GetTripDetailsError extends GetCreatedTripDetailsState {
  final String message;

  const GetTripDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
