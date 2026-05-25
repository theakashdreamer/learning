import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../data/storage/hive_storage.dart';
import '../loginModules/data/dataSources/dataBaseHelper.dart';
import '../loginModules/data/localStorage.dart';
import '../loginModules/entity/UserDetails.dart';
import '../models/web_socket_message.dart';

class PassengerWebSocket with WidgetsBindingObserver {
  static final PassengerWebSocket _instance = PassengerWebSocket._internal();
  WebSocketChannel? _channel;
  StreamSubscription? _channelSub;

  // broadcast controller so multiple listeners (or single listener) can continue across reconnects
  final StreamController<dynamic> _messageController =
      StreamController<dynamic>.broadcast();

  bool isConnected = false;
  bool _receivedPong = true;
  bool _isReconnecting = false;
  bool _hasPendingWork = false;
  Timer? _heartbeatTimer;

  static const String _url = "ws://atmsapi.technosysservicesdemos.com/WebSocket.ashx";
 // static const String _url = "ws://www.aatms.com//WebSocket.ashx";
  // Optional callback so other parts (like bloc) can be notified when connected
  VoidCallback? onConnected;

  PassengerWebSocket._internal();

  factory PassengerWebSocket() => _instance;

  // Expose broadcast stream
  Stream<dynamic> get messages => _messageController.stream;

  // ----------------- CONNECT -----------------
  Future<void> connect() async {
    // if already connected and channel open -> nothing
    if (_channel != null && _channel?.closeCode == null) {
      if (kDebugMode) print("Already connected to WebSocket");
      return;
    }

    try {
      UserDetails? userDetails = await DataBaseHelper.getUserDetailsDetails();
      String baseUrl =
          "$_url?User_Id=${userDetails?.UserID}&SA10_UserType_Id=4&Designation_Id=${userDetails?.Designation_ID}&Person_Id=${userDetails?.TraineeID}";

      if (kDebugMode) print("🔗 Connecting to: $baseUrl");

      // create new channel
      _channel = WebSocketChannel.connect(Uri.parse(baseUrl));

      // cancel previous subscription if any (important)
      await _channelSub?.cancel();

      // pipe channel stream events into our broadcast controller
      _channelSub = _channel!.stream.listen(
        (event) {
          if (kDebugMode) print("WebSocket 📩 Received raw event: $event");
          // forward raw event to controller
          _messageController.add(event);

          // also handle Pong here (optional)
          try {
            final data = jsonDecode(event);
            if (data is Map && data['type'] == 'Pong') {
              _receivedPong = true;
              if (kDebugMode) print("WebSocket ✅ Pong received (internal)");
            }
          } catch (_) {}
        },
        onError: (err) {
          if (kDebugMode) print("WebSocket ⚠️ Channel stream error: $err");
          _tryReconnect(_url);
        },
        onDone: () {
          if (kDebugMode) print("WebSocket ❌ Channel stream done");
          _tryReconnect(_url);
        },
        cancelOnError: true,
      );

      isConnected = true;
      _receivedPong = true;
      startHeartbeat();

      // add lifecycle observer once
      try {
        WidgetsBinding.instance.addObserver(this);
      } catch (_) {}

      // notify listeners that connection is ready
      if (onConnected != null) onConnected!();

      if (kDebugMode) print("✅ WebSocket connected and piping to controller");
    } catch (e) {
      if (kDebugMode) print("⚠️ WebSocket connect error: $e");
      // try alternative host or schedule reconnect
      _tryReconnect(_url);
    }
  }

  // ----------------- HEARTBEAT -----------------
  void startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 3), (timer) async {
      if (_channel == null) return;

      if (!_receivedPong) {
        if (kDebugMode) print("💀 No pong — reconnecting...");
        _tryReconnect(_url);
      } else {
        await HiveStorage.init();
        String connectionID =
            await HiveStorage.fetchString(HiveStorage.keyConnectionID) ?? "";
        final WebSocketMessage webSocketMessage = WebSocketMessage(
          SA10_UserType_Id: 3,
          type: "Ping",
          connectionID: connectionID,
          data: {},
        );
        _sendPing(webSocketMessage.toMap());
        if (kDebugMode) print("📤 Ping sent");
      }
    });
  }

  Future<void> _sendPing(Map<String, dynamic> data) async {
    if (_channel == null) return;
    try {
      _channel!.sink.add(jsonEncode(data));
      Future.delayed(
          const Duration(milliseconds: 300), () => _receivedPong = false);
    } catch (e) {
      if (kDebugMode) print("⚠️ _sendPing failed: $e");
    }
  }

  // ----------------- SEND DATA -----------------
  Future<void> sendMessage(Map<String, dynamic> data) async {
    if (_channel == null || !isConnected) {
      if (kDebugMode) print("⚠️ Cannot send, not connected");
      return;
    }

    _hasPendingWork = true;
    try {
      _channel!.sink.add(jsonEncode(data));
      if (kDebugMode) print("➡️ Sent: ${jsonEncode(data)}");
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      if (kDebugMode) print("⚠️ sendLocationData error: $e");
      _tryReconnect(_url);
    } finally {
      _hasPendingWork = false;
    }
  }

  // ----------------- CLOSE -----------------
  Future<void> closeConnection() async {
    _heartbeatTimer?.cancel();
    try {
      await _channelSub?.cancel();
    } catch (_) {}
    try {
      await _channel?.sink.close();
    } catch (_) {}
    _channelSub = null;
    _channel = null;
    isConnected = false;
    if (kDebugMode) print("🔒 WebSocket connection closed (Passenger service)");
  }

  // ----------------- RECONNECT -----------------
  void _tryReconnect(String baseUrl) {
    if (_isReconnecting) return;
    _isReconnecting = true;

    if (_hasPendingWork) {
      if (kDebugMode) print("⏳ Delaying reconnect — pending work");
      Future.delayed(const Duration(seconds: 5), () {
        _isReconnecting = false;
        _tryReconnect(baseUrl);
      });
      return;
    }

    if (kDebugMode) print("🔁 Scheduling reconnect in 5s...");
    Future.delayed(const Duration(seconds: 5), () async {
      try {
        // ensure closure of old
        await closeConnection();
      } catch (_) {}
      try {
        await connect();
      } finally {
        _isReconnecting = false;
      }
    });
  }

  // ----------------- LIFECYCLE -----------------
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) print("📱 App resumed — ensuring websocket");
      if (!isConnected || _channel == null || _channel?.closeCode != null) {
        _tryReconnect(_url);
      }
    } else if (state == AppLifecycleState.paused) {
      if (kDebugMode) print("⏸️ App paused — closing socket");
      closeConnection();
    }
  }

  void setPingPong() => _receivedPong = true;

  // cleanup when app terminates (optional)
  Future<void> dispose() async {
    await _messageController.close();
    await closeConnection();
    try {
      WidgetsBinding.instance.removeObserver(this);
    } catch (_) {}
  }
}
