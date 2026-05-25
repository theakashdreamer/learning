
import 'package:flutter/material.dart';

import '../../../data/newtwork/base_api_services.dart';
import '../../../data/newtwork/network_api_services.dart';
import '../model/get_all_rides_for_driver_and_passenger.dart';
import '../model/ride_model.dart';

abstract class RideRepository {
  Future<List<GetAllRidesForDriverAndPassenger>> getRides(String traineeID);
/*  Future<List<Ride>> getFilteredRides({
    RideStatus? status,
    RideType? type,
    DateTimeRange? dateRange,
  });*/
}

class MockRideRepository implements RideRepository {

  @override
  Future<List<GetAllRidesForDriverAndPassenger>> getRides(String traineeID) async {
    await Future.delayed(const Duration(seconds: 1));
    List<GetAllRidesForDriverAndPassenger> _listAllRidesForDriver = [];
    try {
      final BaseApiService baseApiService = NetworkApiService();
      final Map<String, dynamic> queryParams = {
        'mode': "GetAllRidesForDriverAndPassenger",
        'SA10_UserType':'4',
        'Person_ID':traineeID
      };
      dynamic response =
      await baseApiService.getGetApiResponseObject('AmbulanceTracking', queryParams);
      if (response != null && response is List) {
        _listAllRidesForDriver = response.map((item) => GetAllRidesForDriverAndPassenger.fromMap(item)).toList();
      }
      return _listAllRidesForDriver;
    } catch (e) {
      return _listAllRidesForDriver;
    }
  }
/*  @override
  Future<List<Ride>> getFilteredRides({
    RideStatus? status,
    RideType? type,
    DateTimeRange? dateRange,
  }) async {
    final allRides = await getRides();

    return allRides.where((ride) {
      if (status != null && ride.status != status) return false;
      if (type != null && ride.rideType != type) return false;
      if (dateRange != null) {
        if (ride.dateTime.isBefore(dateRange.start) ||
            ride.dateTime.isAfter(dateRange.end)) {
          return false;
        }
      }
      return true;
    }).toList();
  }*/
}

