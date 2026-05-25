import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../model/ride_model.dart';
abstract class RideHistoryEvent extends Equatable {
  const RideHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadRideHistory extends RideHistoryEvent {}

class FilterRides extends RideHistoryEvent {
  final RideStatus? status;
  final RideType? type;
  final DateTimeRange? dateRange;

  const FilterRides({
    this.status,
    this.type,
    this.dateRange,
  });

  @override
  List<Object> get props => [status ?? '', type ?? '', dateRange ?? ''];
}

class ClearFilters extends RideHistoryEvent {}
