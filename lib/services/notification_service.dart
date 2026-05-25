import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:schoolmanagementsystem/loginModules/data/dataSources/dataBaseHelper.dart';
import 'package:schoolmanagementsystem/loginModules/entity/UserDetails.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  StreamController<Map<String, dynamic>> _notificationStream =
  StreamController<Map<String, dynamic>>.broadcast();
  String _baseUrl = "http://atmsapi.technosysservicesdemos.com/api/";
  String _registerPath = "FireBasePushNotification?mode=FireBaseDeviceTokenSave";

  Stream<Map<String, dynamic>> get notificationStream => _notificationStream.stream;

  Future<void> initialize() async {
    await Firebase.initializeApp();

    // Request permissions
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get token
    String? token = await _fcm.getToken();
    if (token != null) {
      await registerToken(token);
    }

    // Listen for token refresh
    _fcm.onTokenRefresh.listen(registerToken);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background/terminated messages
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);

    // Get initial message if app was terminated
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  Future<void> registerToken(String token) async {
    try {
      // Get current user ID (you'll need to implement this)
      String? userId = await _getCurrentUserId();

      final response = await http.post(
        Uri.parse("$_baseUrl$_registerPath"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'fcmToken': token,
          'deviceType': 'android', // or 'ios'
          'appVersion': '1.0.0',
        }),
      );

      if (response.statusCode == 200) {
        print('Token registered successfully');
      } else {
        print('Failed to register token');
      }
    } catch (e) {
      print('Error registering token: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _handleMessage(message);

    // Show local notification if needed
    _showLocalNotification(message);
  }

  void _handleMessage(RemoteMessage message) {
    final data = message.data;
    final notification = message.notification;

    Map<String, dynamic> notificationData = {
      'rideId': data['rideId'],
      'status': data['status'],
      'driverName': data['driverName'],
      'driverPhone': data['driverPhone'],
      'title': notification?.title,
      'body': notification?.body,
      'timestamp': DateTime.now(),
    };

    // Add to stream for UI to listen
    _notificationStream.add(notificationData);

    // You can also trigger specific callbacks based on status
    _handleRideStatusUpdate(data['status'], notificationData);
  }

  void _handleMessageOpened(RemoteMessage message) {
    // Handle when user taps on notification
    _handleMessage(message);

    // Navigate to specific screen
    _navigateToRideScreen(message.data['rideId']);
  }

  void _handleRideStatusUpdate(String status, Map<String, dynamic> data) {
    switch (status) {
      case 'accepted':
        _onRideAccepted(data);
        break;
      case 'arrived':
        _onDriverArrived(data);
        break;
      case 'completed':
        _onRideCompleted(data);
        break;
      case 'cancelled':
        _onRideCancelled(data);
        break;
    }
  }

  void _onRideAccepted(Map<String, dynamic> data) {
    // Handle ride accepted logic
    print('Ride accepted by ${data['driverName']}');
    // Update UI, show dialog, etc.
  }

  void _onDriverArrived(Map<String, dynamic> data) {
    print('Driver has arrived at pickup location');
    // Notify user driver has arrived
  }

  void _onRideCompleted(Map<String, dynamic> data) {
    print('Ride completed successfully');
    // Show completion screen, request rating, etc.
  }

  void _onRideCancelled(Map<String, dynamic> data) {
    print('Ride was cancelled');
    // Handle cancellation logic
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    // You can use flutter_local_notifications package for this
  }

  Future<void> _navigateToRideScreen(String rideId) async {
    // Use your navigation method (GetX, Navigator, etc.)
  }

  Future<String?> _getCurrentUserId() async {
   UserDetails? userDetails = await DataBaseHelper.getUserDetailsDetails();
    // Implement based on your auth system
    return userDetails?.TraineeID;
  }

  Future<void> unregisterToken() async {
    try {
      String? userId = await _getCurrentUserId();
      String? token = await _fcm.getToken();

      if (token != null) {
        await http.post(
          Uri.parse("$_baseUrl$_registerPath"),
          body: json.encode({'userId': userId, 'fcmToken': token}),
        );
      }

      await _fcm.deleteToken();
    } catch (e) {
      print('Error unregistering token: $e');
    }
  }
}