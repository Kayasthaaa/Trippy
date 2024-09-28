import 'package:equatable/equatable.dart';

abstract class TripEnrollState extends Equatable {
  const TripEnrollState();

  @override
  List<Object> get props => [];
}

class TripEnrollInitial extends TripEnrollState {}

class TripEnrollLoading extends TripEnrollState {}

class TripEnrollSuccess extends TripEnrollState {
  final Map<String, dynamic> data;

  const TripEnrollSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class TripEnrollError extends TripEnrollState {
  final String error;

  const TripEnrollError(this.error);

  @override
  List<Object> get props => [error];
}
