import 'package:location/location.dart';
import '../models/user_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocationController {
  // Returns the current location as LatLng
  static Future<LatLng?> getCurrentLocation() async {
    Location location = Location();

    // Check permission status
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      // If permission is denied, request permission
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        // If permission is still denied, return null or handle accordingly
        return null;
      }
    }

    // Check if location service is enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // If location service is not enabled, return null or handle accordingly
        return null;
      }
    }

    // Fetch the current location
    LocationData position = await location.getLocation();

    return LatLng(position.latitude ?? 0.0, position.longitude ?? 0.0);
  }

  // Fetch saved locations, could be from a local database or API in a real app
  static Future<List<UserLocation>> getSavedLocations() async {
    // Return a mock list of saved locations
    return [
      UserLocation(
          name: "Home",
          locationType: UserLocationType.Home,
          position: LatLng(26.6864, 80.9863),
          minutesFar: 52),
      UserLocation(
          name: "Innov8",
          locationType: UserLocationType.Office,
          position: LatLng(26.68646, 80.98633),
          minutesFar: 36),
    ];
  }
}
