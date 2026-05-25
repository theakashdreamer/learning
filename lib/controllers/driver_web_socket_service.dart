import 'package:schoolmanagementsystem/controllers/web_socket_handler.dart';

class DriverWebSocketServiceOld {
  final webSocketService = PassengerWebSocket();

  // Driver-specific event listeners
  void sendDriverLocation(double latitude, double longitude) {
    Map<String, dynamic> locationData = {
      'latitude': latitude,
      'longitude': longitude,
      'driverId': 'driver_123', // Replace with actual driver ID
    };
 //   webSocketService.sendMessage('driver_location_update', locationData);
  }

  void acceptRide(String rideId) {
    Map<String, dynamic> acceptanceData = {
      'rideId': rideId,
      'driverId': 'driver_123',
    };
   // webSocketService.sendMessage('ride_accepted', acceptanceData);
  }

  void startRide(String rideId) {
    Map<String, dynamic> startData = {
      'rideId': rideId,
      'driverId': 'driver_123',
    };
   // webSocketService.sendMessage('ride_start', startData);
  }

  void endRide(String rideId) {
    Map<String, dynamic> endData = {
      'rideId': rideId,
      'driverId': 'driver_123',
    };
   // webSocketService.sendMessage('ride_end', endData);
  }
}
