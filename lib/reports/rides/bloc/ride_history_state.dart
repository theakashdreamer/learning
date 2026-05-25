import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../models/taxi_booking.dart';
import 'package:equatable/equatable.dart';

import '../model/get_all_rides_for_driver_and_passenger.dart';
import '../model/ride_model.dart';


abstract class RideHistoryState extends Equatable {
  const RideHistoryState();

  @override
  List<Object> get props => [];
}

class RideHistoryInitial extends RideHistoryState {}

class RideHistoryLoading extends RideHistoryState {}

class RideHistoryLoaded extends RideHistoryState {
  final List<GetAllRidesForDriverAndPassenger> rides;
  final List<GetAllRidesForDriverAndPassenger> filteredRides;
  final RideStatus? activeStatusFilter;
  final RideType? activeTypeFilter;
  final DateTimeRange? activeDateRange;

  const RideHistoryLoaded({
    required this.rides,
    required this.filteredRides,
    this.activeStatusFilter,
    this.activeTypeFilter,
    this.activeDateRange,
  });

  @override
  List<Object> get props => [
    rides,
    filteredRides,
    activeStatusFilter ?? '',
    activeTypeFilter ?? '',
    activeDateRange ?? '',
  ];

  bool get hasActiveFilters {
    return activeStatusFilter != null ||
        activeTypeFilter != null ||
        activeDateRange != null;
  }
}

class RideHistoryError extends RideHistoryState {
  final String message;

  const RideHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
