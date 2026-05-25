import 'dart:convert';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/newtwork/base_api_services.dart';
import '../data/newtwork/network_api_services.dart';
import '../loginModules/globalClass/globalClass.dart';
import '../models/google_location.dart';
import '../models/ride_cancellation_reason.dart';
import '../models/taxi.dart';
import '../models/taxi_booking.dart';
import '../models/taxi_type.dart';
import '../storage/taxi_storage.dart';
import 'location_controller.dart';

class TaxiBookingController {



  static Future<double> getPrice(TaxiBooking taxiBooking) async {
    return 150;
  }

  static GoogleLocation generateRandomLocation(
      LatLng center, double radiusInMeters) {
    final random = Random();
    final radiusInDegrees = radiusInMeters / 111000.0; // Convert meters to degrees
    final u = random.nextDouble();
    final v = random.nextDouble();
    final w = radiusInDegrees * sqrt(u);
    final t = 2 * pi * v;
    final x = w * cos(t);
    final y = w * sin(t);

    final newLongitude = center.longitude + x;
    final newLatitude = center.latitude + y;

    return GoogleLocation(
        position: LatLng(newLatitude, newLongitude),
        placeId: '1',
        areaDetails: 'Lucknow Demos');
  }

  static Future<List<Taxi>> getTaxisAvailableOld() async {
    GoogleLocation location = await LocationController.getCurrentLocationNew();
    const double maxRadius = 200 / 111300;
    Random random = Random();
    List<Taxi> taxis = List<Taxi>.generate(10, (index) {
      double u = random.nextDouble();
      double v = random.nextDouble();
      double w = maxRadius + sqrt(u);
      double t = 2 * pi * v;
      double x1 = w * cos(t);
      double y1 = w * sin(t);
      x1 = x1 / cos(y1);
      LatLng oldPos = location.position;

      return Taxi.named(
          id: "$index",
          plateNo: "DL${index}XYZ${index}123",
          isAvailable: true,
          taxiType: TaxiType.Standard1,
          position: LatLng(x1 + oldPos.latitude, y1 + oldPos.longitude),
          title: "Taxi $index");
    });
    return taxis;
  }

  static Future<List<Taxi>> getTaxisAvailable1(double lat, double lng) async {
    final BaseApiService networkApiService = NetworkApiService();
    List<Taxi> taxis = [];
    try {
      final Map<String, dynamic> queryParams = {
        'mode': 'GetNearestVehicleByRange',
      };
      var response = await networkApiService.postApiResponse(
        "AmbulanceTracking",
        queryParams,
        jsonEncode({"PassengerLat": lat, "PassengerLong": lng}),
      );

      if (response != null) {
        if (response is List) {
          taxis = response
              .where((item) => item is Map<String, dynamic>)
              .map((item) => Taxi.fromMap(item as Map<String, dynamic>))
              .toList();
        }
        // Agar response single object hai
        else if (response is Map<String, dynamic>) {
          taxis = [Taxi.fromMap(response)];
        } else {
          GlobalClass.fetchToastPosition("Unexpected response format");
        }
      } else {
        GlobalClass.fetchToastPosition("No response from server");
      }
    } catch (e, stackTrace) {
      print("Error fetching taxis: $e");
      print(stackTrace);
      GlobalClass.fetchToastPosition("Something went wrong");
    }

    return taxis;
  }

  static Future<List<Taxi>> getTaxisAvailable(double lat, double lng) async {
    final BaseApiService networkApiService = NetworkApiService();
    List<Taxi> taxis = [];
    try {
      final Map<String, dynamic> queryParams = {
        'mode': 'GetNearestVehicleByRange',
      };
      var response = await networkApiService.postApiResponse(
        "AmbulanceTracking",
        queryParams,
        jsonEncode({"PassengerLat": lat, "PassengerLong": lng}),
      );

      if (response != null) {
        if (response is List) {
          taxis = response.where((item) => item is Map<String, dynamic>).map((item) => Taxi.fromMap(item as Map<String, dynamic>)).toList();
          Taxistorage.clear();
          if (taxis.length > 0)
            Taxistorage.addDetails(taxis);
        }
        // Agar response single object hai
        else if (response is Map<String, dynamic>) {
          taxis = [Taxi.fromMap(response)];
        }
        else {
          GlobalClass.fetchToastPosition("Unexpected response format");
        }
      } else {
        GlobalClass.fetchToastPosition("No response from server");
      }
    } catch (e, stackTrace) {
      print("Error fetching taxis: $e");
      print(stackTrace);
      GlobalClass.fetchToastPosition("Something went wrong");
    }

    return taxis;
  }

  static Future<List<RideCancellationReason>>
  getRideCancellationReason() async {
    final BaseApiService networkApiService = NetworkApiService();
    List<RideCancellationReason> rideCancellationReason = [];
    try {
      final Map<String, dynamic> queryParams = {
        'mode': 'GetRideCancellationReason',
        'SA10_UserType': '4',
      };
      var response = await networkApiService.getGetApiResponseObject(
        "Masters",
        queryParams,
      );
      if (response != null) {
        if (response is List) {
          rideCancellationReason = response
              .where((item) => item is Map<String, dynamic>)
              .map((item) =>
              RideCancellationReason.fromMap(item as Map<String, dynamic>))
              .toList();
        } else if (response is Map<String, dynamic>) {
          rideCancellationReason = [RideCancellationReason.fromMap(response)];
        } else {
          GlobalClass.fetchToastPosition("Unexpected response format");
        }
      } else {
        GlobalClass.fetchToastPosition("No response from server");
      }
    } catch (e, stackTrace) {
      print("Error fetching taxis: $e");
      print(stackTrace);
      GlobalClass.fetchToastPosition("Something went wrong");
    }
    return rideCancellationReason;
  }
}
