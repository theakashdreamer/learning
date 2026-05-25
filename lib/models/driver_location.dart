import 'dart:convert';

import 'package:equatable/equatable.dart';

class DriverLocation extends Equatable {
  String Driver_Id;
  double Lattitude;
  double Longitude;
  String P02_AddedBy;
  String O12_AddedBy;
  String ResultString;
  String RideStatus_Id;
  String Ride_Id;

  DriverLocation(
      {required this.Driver_Id,
      required this.Lattitude,
      required this.Longitude,
      this.P02_AddedBy = '0',
      this.O12_AddedBy = '0',
      this.ResultString = '',
      this.RideStatus_Id = '0',
      this.Ride_Id = '0'});

  // Convert Dart object to Map
  Map<String, dynamic> toMap() {
    return {
      'Driver_Id': Driver_Id,
      'Lattitude': Lattitude,
      'Longitude': Longitude,
      'P02_AddedBy': P02_AddedBy,
      'O12_AddedBy': O12_AddedBy,
      'ResultString': ResultString,
      'RideStatus_Id': RideStatus_Id,
      'Ride_Id': RideStatus_Id,
    };
  }

  // Create Dart object from Map
  factory DriverLocation.fromMap(Map<String, dynamic> map) {
    return DriverLocation(
      Driver_Id: map['Driver_Id'] ?? '',
      Lattitude: (map['Lattitude'] ?? 0).toDouble(),
      Longitude: (map['Longitude'] ?? 0).toDouble(),
      P02_AddedBy: map['P02_AddedBy'] ?? '0',
      O12_AddedBy: map['O12_AddedBy'] ?? '0',
      ResultString: map['ResultString'] ?? '',
      RideStatus_Id: map['RideStatus_Id'] ?? '',
      Ride_Id: map['Ride_Id'] ?? '',
    );
  }

  // Optional: JSON string helper
  String toJson() => jsonEncode(toMap());

  factory DriverLocation.fromJson(String source) =>
      DriverLocation.fromMap(jsonDecode(source));

  DriverLocation copyWith({
    required String driverId,
    required double lattitude,
    required double longitude,
    String? p02AddedBy,
    String? o12_AddedBy,
    String? resultString,
    String? RideStatus_Id,
    String? Ride_Id,
  }) {
    return DriverLocation(
      Driver_Id: driverId,
      Lattitude: lattitude,
      Longitude: longitude,
      P02_AddedBy: p02AddedBy ?? "0",
      O12_AddedBy: o12_AddedBy ?? '0',
      ResultString: resultString ?? '0',
      RideStatus_Id: RideStatus_Id ?? '0',
      Ride_Id: Ride_Id ?? '0',
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        Driver_Id,
        Lattitude,
        Longitude,
        P02_AddedBy,
        O12_AddedBy,
        ResultString,
        RideStatus_Id,
        Ride_Id
      ];
}
