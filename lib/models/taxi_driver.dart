import 'package:equatable/equatable.dart';
import 'package:schoolmanagementsystem/models/ride_cancellation_reason.dart';
import 'package:schoolmanagementsystem/models/taxi_details.dart';

import 'google_location.dart';

class TaxiDriver extends Equatable {
  String? _ride_Id;
  String? _driver_Id;
  String? _driverName;
  double? _driverRating;
  TaxiDetails? _taxiDetails;
  String? _driverPic;
  bool isRideStarted;
  GoogleLocation? driverLocation;
  bool driverAccepted;
  String? _ResultString;
  String? _RideStatus_Id;
  String? _Mobile_No;
  int? _Ride_OTP;
  RideCancellationReason? _rideCancellationReason;

  TaxiDriver({
    this.isRideStarted = false,
    this.driverLocation,
    this.driverAccepted = false,
    ride_Id = '',
    driver_Id = '',
  })  : _ride_Id = ride_Id,
        _driver_Id = driver_Id;

  TaxiDriver.named(
      {String? ride_Id = '',
      String? driver_Id = '',
      String? driverName = '',
      double? driverRating = 0.0,
      TaxiDetails? taxiDetails,
      String? driverPic = '',
      this.isRideStarted = false,
      this.driverLocation,
      this.driverAccepted = false,
      String? ResultString,
      String? RideStatus_Id,
      String? Mobile_No,
        int? Ride_OTP,
      required RideCancellationReason? rideCancellationReason})
      : _driverName = driverName,
        _driverRating = driverRating,
        _taxiDetails = taxiDetails,
        _driverPic = driverPic,
        _ride_Id = ride_Id,
        _driver_Id = driver_Id,
        _ResultString = ResultString,
        _RideStatus_Id = RideStatus_Id,
        _Mobile_No = Mobile_No,
        _Ride_OTP = Ride_OTP,
        _rideCancellationReason = rideCancellationReason;

  // CopyWith method to return updated TaxiDriver object
  TaxiDriver copyWith(
      {String? ride_Id,
      String? driverName,
      double? driverRating,
      TaxiDetails? taxiDetails,
      String? driverPic,
      bool? isRideStarted,
      GoogleLocation? driverLocation,
      bool? driverAccepted,
      String? ResultString,
      String? RideStatus_Id,
      String? Mobile_No, int? Ride_OTP,
      RideCancellationReason? rideCancellationReason}) {
    return TaxiDriver.named(
      ride_Id: ride_Id ?? this._ride_Id ?? "",
      driverName: driverName ?? this._driverName ?? "",
      driverRating: driverRating ?? this._driverRating!,
      taxiDetails: taxiDetails ?? this._taxiDetails,
      driverPic: driverPic ?? this._driverPic!,
      isRideStarted: isRideStarted ?? this.isRideStarted,
      driverLocation: driverLocation ?? this.driverLocation,
      driverAccepted: driverAccepted ?? this.driverAccepted,
      ResultString: ResultString ?? this._ResultString,
      RideStatus_Id: RideStatus_Id ?? this._RideStatus_Id,
      Mobile_No: Mobile_No ?? this._Mobile_No,
      Ride_OTP: Ride_OTP ?? this._Ride_OTP,
      rideCancellationReason:
          rideCancellationReason ?? this._rideCancellationReason,
    );
  }

  String get driver_Id => _driver_Id ?? "";

  set driver_Id(String value) => _driver_Id = value;

  String get driverName => _driverName ?? "";

  set driverName(String value) => _driverName = value;

  double get driverRating => _driverRating ?? 0.0;

  set driverRating(double value) => _driverRating = value;

  TaxiDetails? get taxiDetails => _taxiDetails;

  set taxiDetails(TaxiDetails? value) => _taxiDetails = value;

  String get driverPic => _driverPic ?? "";

  set driverPic(String value) => _driverPic = value;

  String get ride_Id => _ride_Id ?? "";

  set ride_Id(String value) {
    _ride_Id = value;
  }

  String get ResultString => _ResultString ?? "";

  set ResultString(String value) {
    _ResultString = value ?? "";
  }
  int get Ride_OTP => _Ride_OTP ?? 0;

  set Ride_OTP(int value) {
    _Ride_OTP = value ?? 0;
  }
  RideCancellationReason? get rideCancellationReason => _rideCancellationReason;

  set rideCancellationReason(RideCancellationReason? value) {
    _rideCancellationReason = value;
  }

  @override
  List<Object?> get props => [
        _ride_Id,
        _driver_Id,
        _driverName,
        _driverRating,
        _taxiDetails,
        _driverPic,
        isRideStarted,
        driverLocation,
        driverAccepted,
        _ResultString,
        _RideStatus_Id,
        _Mobile_No,
        _rideCancellationReason
      ];

  Map<String, dynamic> toMap() {
    return {
      'ride_Id': _ride_Id,
      'driver_Id': _driver_Id,
      'driverName': _driverName,
      'driverRating': _driverRating,
      'taxiDetails': _taxiDetails?.toMap(),
      'driverPic': _driverPic,
      'isRideStarted': isRideStarted,
      'driverLocation': driverLocation,
      'driverAccepted': driverAccepted,
      'ResultString': ResultString,
      'RideStatus_Id': RideStatus_Id,
      'Mobile_No': Mobile_No,
      'Ride_OTP': Ride_OTP,
      'rideCancellationReason': rideCancellationReason?.toMap(),
    };
  }

  // Create Dart object from Map
  factory TaxiDriver.fromMap(Map<String, dynamic> map) {
    return TaxiDriver.named(
      ride_Id: map['ride_Id'] ?? '',
      driver_Id: map['driver_Id'] ?? "",
      driverName: map['driverName'] ?? '0',
      driverRating: map['driverRating'] ?? 0.0,
      taxiDetails: map['taxiDetails'] != null
          ? TaxiDetails.fromMap(map['taxiDetails'] as Map<String, dynamic>)
          : null,
      driverPic: map['driverPic'] ?? "",
      isRideStarted: map['isRideStarted'] ?? false,
      driverLocation: map['driverLocation'] != null
          ? GoogleLocation.fromJson(
              map['driverLocation'] as Map<String, dynamic>)
          : null,
      driverAccepted: map['driverAccepted'] ?? false,
      ResultString: map['ResultString'] ?? "",
      RideStatus_Id: map['RideStatus_Id'] ?? "",
      Mobile_No: map['Mobile_No'] ?? "",
      Ride_OTP: map['Ride_OTP']?? 0,
      rideCancellationReason: map['rideCancellationReason'] != null
          ? RideCancellationReason.fromMap(
              map['rideCancellationReason'] as Map<String, dynamic>)
          : null,
    );
  }

  String get RideStatus_Id => _RideStatus_Id ?? "0";

  set RideStatus_Id(String? value) {
    _RideStatus_Id = value ?? "";
  }

  String get Mobile_No => _Mobile_No ?? "0";

  set Mobile_No(String? value) {
    _Mobile_No = value ?? "";
  }
}
