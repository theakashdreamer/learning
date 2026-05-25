import 'package:schoolmanagementsystem/controllers/web_socket_handler.dart';

class PassengerWebSocketService {
  final webSocketService = PassengerWebSocket();

  void sendRideRequest(double pickupLat, double pickupLng, double dropoffLat,
      double dropoffLng) {
    Map<String, dynamic> request = {
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropoffLat': dropoffLat,
      'dropoffLng': dropoffLng,
      'passengerId': 'passenger_123', // Replace with actual passenger ID
    };
    // webSocketService.sendMessage('ride_request', request);
  }
}
