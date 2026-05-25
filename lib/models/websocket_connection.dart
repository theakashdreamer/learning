import 'dart:convert';

class WebSocketConnection {
  String? _connectionId;
  String? _timestamp;
  String? _message;

  WebSocketConnection(
    this._connectionId,
    this._timestamp,
    this._message,
  );

  // Convert Dart object to Map
  Map<String, dynamic> toMap() {
    return {
      'connectionId': _connectionId,
      'timestamp': _timestamp,
      'message': _message,
    };
  }

  // Create Dart object from Map
  factory WebSocketConnection.fromMap(Map<String, dynamic> map) {
    return WebSocketConnection(
      map['connectionId'] ?? '',
      map['timestamp'] ?? "${DateTime.now()}",
      map['message'] ?? "Failures",
    );
  }

  String get connectionId => _connectionId ?? "";

  set connectionId(String? value) {
    _connectionId = value;
  } // Optional: JSON string helper

  String toJson() => jsonEncode(toMap());

  factory WebSocketConnection.fromJson(String source) =>
      WebSocketConnection.fromMap(jsonDecode(source));

  String get timestamp => _timestamp ?? "${DateTime.now()}";

  set timestamp(String value) {
    _timestamp = value;
  }

  String get message => _message ?? "Failure";

  set message(String value) {
    _message = value;
  }
}
