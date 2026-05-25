import 'dart:convert';

import 'package:schoolmanagementsystem/models/driver_location.dart';
import 'package:schoolmanagementsystem/models/taxi_booking.dart';
import 'package:schoolmanagementsystem/models/taxi_driver.dart';

class WebSocketMessage<T> {
  final String connectionID;
  final String driverID;
  final String passengerID;
  final String O12_AddedBy;
  final int SA10_UserType_Id;
  final String type; // e.g., "location_update"
  final T data;
  final int statusCode;

  WebSocketMessage(
      {required this.connectionID,
      required this.type,
      required this.data,
      this.statusCode = 0,
      required this.SA10_UserType_Id,
      this.driverID = "0",
      this.passengerID = "0",
      this.O12_AddedBy = '0'});

  // Convert WebSocketMessage to Map
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'statusCode': statusCode,
      'connectionID': connectionID,
      'driverID': driverID,
      'passengerID': passengerID,
      'SA10_UserType_Id': SA10_UserType_Id,
      'O12_AddedBy': O12_AddedBy,
      'data': _convertValueOfData(data),
    };
  }

  dynamic _convertValueOfData(T data) {
    if (data is TaxiBooking) return data.toMap();
    if (data is DriverLocation) return data.toMap();
    if (data is TaxiDriver) return data.toMap();
    return data.toString();
  }

  factory WebSocketMessage.fromMap(
      Map<String, dynamic> map, T Function(Map<String, dynamic>) fromMap) {
    if (!map.containsKey('type') || !map.containsKey('statusCode')) {
      throw Exception("Invalid WebSocketMessage Map");
    }

    if (!map.containsKey('type') || !map.containsKey('data')) {
      throw Exception("Invalid WebSocketMessage Map");
    }

    final dataMap = map['data'] as Map<String, dynamic>;
    final dataObj = fromMap(dataMap);

    return WebSocketMessage<T>(
        connectionID: map['connectionID'] ?? "",
        type: map['type'] ?? "",
        statusCode: map['statusCode'] ?? 0,
        driverID: map['driverID'] ?? "0",
        passengerID: map['passengerID'] ?? "0",
        SA10_UserType_Id: map['SA10_UserType_Id'] ?? "",
        O12_AddedBy: map['O12_AddedBy'] ?? "0",
        data: dataObj);
  }

  // Convert to JSON string
  String toJson() => jsonEncode(toMap());
}
