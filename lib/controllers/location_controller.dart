import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/google_location.dart';

class LocationController {
  /// Returns the current location of the user
  static Future<GoogleLocation> getCurrentLocationOld() async {
    // Simulate a network or GPS delay
    await Future.delayed(Duration(milliseconds: 500));

    return GoogleLocation.named(
      placeId: "ChIJN1t_tDeuEmsRUsoyG83frY4",
      position: LatLng(26.6864, 80.9863),
      areaDetails: "Central Park, New York, NY, USA",
    );
  }

  /// Returns a GoogleLocation based on a LatLng position
  static Future<GoogleLocation> getLocationfromId(LatLng? position) async {
    await Future.delayed(Duration(milliseconds: 500));
  var abc=  GoogleLocation.named(
      placeId: "ChIJN1t_tDeuEmsRUsoyG83frY4", // mock placeId
      position: position ?? LatLng(26.6864, 80.9863),
      areaDetails:
      "Address near (${26.6864}, ${80.9863})",
    );
    return abc;
  }

  /// Returns a list of LatLng points representing a polyline route
  static Future<List<LatLng>> getPolylines(LatLng start, LatLng end) async {
    await Future.delayed(Duration(milliseconds: 300)); // simulate network

    // Sample polyline points (mock data)
    List<Map<String, double>> points = [
      {"lat": 40.7835246, "lng": -73.9651392},
      {"lat": 40.7470087, "lng": -73.9870749},
      {"lat": 40.7836479, "lng": -73.9649581},
      {"lat": 40.7814891, "lng": -73.9627453},
      {"lat": 40.7802148, "lng": -73.9613768},
      {"lat": 40.7465393, "lng": -73.9859729},
      {"lat": 40.7470087, "lng": -73.9870749},
    ];

    return points.map((p) => LatLng(p["lat"]!, p["lng"]!)).toList();
  }

  static Future<GoogleLocation> getCurrentLocationNew() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permission denied, using fallback location.");
          return _fallbackLocation();
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print("Location permission permanently denied, using fallback location.");
        return _fallbackLocation();
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      String address = "Unknown location";
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          address = "${place.name ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
        }
      } catch (e) {
        print("Error getting address: $e");
      }
      return GoogleLocation.named(
        placeId: "Current_Location",
        position: LatLng(position.latitude, position.longitude),
        areaDetails: address,
      );
    } catch (e) {
      print("Error getting current location: $e");
      return _fallbackLocation();
    }
  }

// Fallback location (example: city center coordinates)
  static GoogleLocation _fallbackLocation() {
    return GoogleLocation.named(
      placeId: "fallback_location",
      position: LatLng(28.6139, 77.2090), // Delhi center example
      areaDetails: "Delhi, India (fallback location)",
    );
  }


  /// Returns a GoogleLocation based on a LatLng position
  static Future<GoogleLocation> getLocationFromLatLng(LatLng position) async {
    String address = "Unknown location";
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        address = "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      print("Error getting address: $e");
    }

    return GoogleLocation.named(
      placeId: "custom_location",
      position: position,
      areaDetails: address,
    );
  }
}
