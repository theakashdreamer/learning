import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../loginModules/data/dataSources/dataBaseHelper.dart';
import '../../../loginModules/entity/UserDetails.dart';
import '../model/ride_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/ride_repository.dart';
import 'ride_history_event.dart';
import 'ride_history_state.dart';

class RideHistoryBloc extends Bloc<RideHistoryEvent, RideHistoryState> {
  final RideRepository rideRepository;

  RideHistoryBloc({required this.rideRepository})
      : super(RideHistoryInitial()) {
    on<LoadRideHistory>(_onLoadRideHistory);
    on<FilterRides>(_onFilterRides);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadRideHistory(
      LoadRideHistory event,
      Emitter<RideHistoryState> emit,
      ) async {
    UserDetails? userDetails = await DataBaseHelper.getUserDetailsDetails();
    emit(RideHistoryLoading());
    try {
      final rides = await rideRepository.getRides(userDetails!.TraineeID);
      emit(
        RideHistoryLoaded(
          rides: rides,
          filteredRides: rides,
        ),
      );
    } catch (e) {
      emit(RideHistoryError('Failed to load ride history'));
    }
  }

  Future<void> _onFilterRides(
      FilterRides event,
      Emitter<RideHistoryState> emit,
      ) async {
    if (state is RideHistoryLoaded) {
      final currentState = state as RideHistoryLoaded;
      emit(RideHistoryLoading());

      try {
     /*   final filteredRides = await rideRepository.getFilteredRides(
          status: event.status,
          type: event.type,
          dateRange: event.dateRange,
        );

        emit(
          RideHistoryLoaded(
            rides: currentState.rides,
            filteredRides: filteredRides,
            activeStatusFilter: event.status,
            activeTypeFilter: event.type,
            activeDateRange: event.dateRange,
          ),
        );*/
      } catch (e) {
        emit(RideHistoryError('Failed to filter rides'));
      }
    }
  }

  Future<void> _onClearFilters(
      ClearFilters event,
      Emitter<RideHistoryState> emit,
      ) async {
    if (state is RideHistoryLoaded) {
      final currentState = state as RideHistoryLoaded;
      emit(
        RideHistoryLoaded(
          rides: currentState.rides,
          filteredRides: currentState.rides,
        ),
      );
    }
  }
}
