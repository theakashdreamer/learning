import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schoolmanagementsystem/models/payment_details.dart';
import 'package:schoolmanagementsystem/models/payment_method.dart';
import 'package:schoolmanagementsystem/models/taxi.dart';
import 'package:schoolmanagementsystem/models/taxi_driver.dart';

import '../loginModules/entity/TypeOfAmbulance.dart';
import 'google_location.dart';

class TaxiBooking {
  String? _id;
  String? _Ride_Id;
  GoogleLocation? _source;
  GoogleLocation? _destination;
  String? _noOfPersons;
  DateTime? _bookingTime;
  TypeOfAmbulance? _typeOfAmbulance;
  double? _estimatedPrice;
  PaymentMethod? _paymentMethod;
  String? _promoApplied;
  String? distance; // "12.3 km"
  String? expectedTime; // "25 mins"
  List<LatLng>? polyline; // decoded polyline points
  TaxiDriver? taxiDriver;
  String? Status_ID;
  PaymentDetails? paymentDetails;

  TaxiBooking();

  TaxiBooking.named(
      {String id = '',
      GoogleLocation? source,
      GoogleLocation? destination,
      String noOfPersons = "1",
      DateTime? bookingTime,
        TypeOfAmbulance? taxiType,
      double? estimatedPrice = 0.0,
      PaymentMethod? paymentMethod,
      String promoApplied = '',
      String? distance,
      String? expectedTime,
      String? Driver_Id,
      String? Passenger_Id,
      String? O12_AddedBy,
      String? Ride_Id,
      String? Status_ID,
      TaxiDriver? taxiDriver,
      List<LatLng>? polyline,
      PaymentDetails? paymentDetails})
      : _id = id,
        _source = source,
        _destination = destination,
        _noOfPersons = noOfPersons,
        _bookingTime = bookingTime ?? DateTime.now(),
        _typeOfAmbulance = taxiType,
        _estimatedPrice = estimatedPrice,
        _paymentMethod = paymentMethod,
        _promoApplied = promoApplied,
        distance = distance,
        expectedTime = expectedTime,
        _Ride_Id = Ride_Id,
        polyline = polyline,
        taxiDriver = taxiDriver,
        Status_ID = Status_ID,
        paymentDetails = paymentDetails;

  // Getters and setters
  String get id => _id ?? '';

  set id(String value) => _id = value;

  GoogleLocation get source => _source ?? GoogleLocation.named();

  set source(GoogleLocation value) => _source = value;

  GoogleLocation get destination => _destination ?? GoogleLocation.named();

  set destination(GoogleLocation value) => _destination = value;

  String get noOfPersons => _noOfPersons ?? "1";

  set noOfPersons(String value) => _noOfPersons = value;

  DateTime get bookingTime => _bookingTime ?? DateTime.now();

  set bookingTime(DateTime value) => _bookingTime = value;

  TypeOfAmbulance get typeOfAmbulance => _typeOfAmbulance ?? TypeOfAmbulance();

  set typeOfAmbulance(TypeOfAmbulance? value) => _typeOfAmbulance = value;

  double get estimatedPrice => _estimatedPrice ?? 0.0;

  set estimatedPrice(double value) => _estimatedPrice = value;

  PaymentMethod get paymentMethod => _paymentMethod ?? PaymentMethod();

  set paymentMethod(PaymentMethod value) => _paymentMethod = value;

  String get promoApplied => _promoApplied ?? '';

  set promoApplied(String value) => _promoApplied = value;

  Future<TaxiBooking> copyWith(
      {String? id,
      GoogleLocation? source,
      GoogleLocation? destination,
      String? noOfPersons,
      DateTime? bookingTime,
        TypeOfAmbulance? taxiType,
      double? estimatedPrice,
      PaymentMethod? paymentMethod,
      String? promoApplied,
      String? distance,
      String? expectedTime,
      String? Ride_Id,
      TaxiDriver? taxiDriver,
      List<LatLng>? polyline,
      String? Status_ID,
      PaymentDetails? paymentDetails}) async {
    return TaxiBooking.named(
      id: id ?? this.id,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      noOfPersons: noOfPersons ?? this.noOfPersons,
      bookingTime: bookingTime ?? this.bookingTime,
      taxiType: taxiType ?? this.typeOfAmbulance,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoApplied: promoApplied ?? this.promoApplied,
      distance: distance ?? this.distance,
      expectedTime: expectedTime ?? this.distance,
      Ride_Id: Ride_Id ?? this._Ride_Id,
      polyline: polyline ?? this.polyline,
      taxiDriver: taxiDriver ?? this.taxiDriver,
      Status_ID: Status_ID ?? this.Status_ID,
      paymentDetails: paymentDetails ?? this.paymentDetails,
    );
  }

  factory TaxiBooking.fromJson(Map<String, dynamic> json) {
    return TaxiBooking.named(
      id: json['id'] ?? "",
      source: json['source'] != null
          ? GoogleLocation.fromJson(json['source'] as Map<String, dynamic>)
          : null,
      destination: json['destination'] != null
          ? GoogleLocation.fromJson(json['destination'] as Map<String, dynamic>)
          : null,
      noOfPersons: json['noOfPersons'] ?? 1,
      bookingTime: json['bookingTime'] != null
          ? DateTime.parse(json['bookingTime'] as String)
          : null,
      taxiType: json['taxiType'] != null
          ? TypeOfAmbulance.fromMap(json['taxiType'] as Map<String, dynamic>)
          : null,
      estimatedPrice: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      promoApplied: json['promoApplied'] ?? "",
      distance: json['distance'] ?? "",
      Ride_Id: json['Ride_Id'] ?? "",
      taxiDriver: json['taxiDriver'] != null
          ? TaxiDriver.fromMap(json['taxiDriver'] as Map<String, dynamic>)
          : null,
      Status_ID: json['Status_ID'] ?? "",
      paymentDetails: json['paymentDetails'] != null
          ? PaymentDetails.fromMap(
              json['paymentDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'source': this._source?.toMap(),
      'destination': this._destination?.toMap(),
      'noOfPersons': this._noOfPersons,
      'bookingTime': this._bookingTime?.toIso8601String(),
      'taxiType': this._typeOfAmbulance?.toMap(),
      'estimatedPrice': this._estimatedPrice,
      'paymentMethod': this._paymentMethod?.toMap(),
      'promoApplied': this._promoApplied,
      'distance': this.distance,
      'expectedTime': this.expectedTime,
      'polyline': this.polyline,
      'Ride_Id': this.Ride_Id,
      'taxiDriver': this.taxiDriver?.toMap(),
      'Status_ID': this.Status_ID,
    };
  }

  String get Ride_Id => _Ride_Id ?? '0';

  set Ride_Id(String value) {
    _Ride_Id = value;
  }

}
