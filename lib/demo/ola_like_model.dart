import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Location model
class GoogleLocation {
  String? address;
  double? lat;
  double? lng;

  GoogleLocation({this.address, this.lat, this.lng});

  factory GoogleLocation.fromJson(Map<String, dynamic> json) => GoogleLocation(
    address: json['address'],
    lat: (json['lat'] as num?)?.toDouble(),
    lng: (json['lng'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'address': address,
    'lat': lat,
    'lng': lng,
  };
}

/// Passenger model
class Passenger {
  String? id;
  String? name;
  String? phone;
  String? email;
  String? profilePic;

  Passenger({this.id, this.name, this.phone, this.email, this.profilePic});

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    profilePic: json['profilePic'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'profilePic': profilePic,
  };
}

/// Driver model
class Driver {
  String? id;
  String? name;
  String? phone;
  String? email;
  String? profilePic;
  String? licenseNumber;
  double? rating; // Average rating
  String? vehicleId;
  bool? isOnline;

  Driver({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.profilePic,
    this.licenseNumber,
    this.rating,
    this.vehicleId,
    this.isOnline,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    profilePic: json['profilePic'],
    licenseNumber: json['licenseNumber'],
    rating: (json['rating'] as num?)?.toDouble(),
    vehicleId: json['vehicleId'],
    isOnline: json['isOnline'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'profilePic': profilePic,
    'licenseNumber': licenseNumber,
    'rating': rating,
    'vehicleId': vehicleId,
    'isOnline': isOnline,
  };
}

/// Vehicle model
class Vehicle {
  String? id;
  String? type; // Ambulance or vehicle type
  String? numberPlate;
  String? model;
  String? color;
  String? imageUrl;

  Vehicle({this.id, this.type, this.numberPlate, this.model, this.color, this.imageUrl});

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json['id'],
    type: json['type'],
    numberPlate: json['numberPlate'],
    model: json['model'],
    color: json['color'],
    imageUrl: json['imageUrl'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'numberPlate': numberPlate,
    'model': model,
    'color': color,
    'imageUrl': imageUrl,
  };
}

/// Payment method enum
enum PaymentMethod { cash, card, wallet, online }

/// Payment details
class PaymentDetails {
  PaymentMethod? method;
  double? amount;
  bool? isPaid;
  String? transactionId;
  String? promoApplied;

  PaymentDetails({this.method, this.amount, this.isPaid, this.transactionId, this.promoApplied});

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
    method: json['method'] != null ? PaymentMethod.values[json['method']] : null,
    amount: (json['amount'] as num?)?.toDouble(),
    isPaid: json['isPaid'],
    transactionId: json['transactionId'],
    promoApplied: json['promoApplied'],
  );

  Map<String, dynamic> toJson() => {
    'method': method != null ? method!.index : null,
    'amount': amount,
    'isPaid': isPaid,
    'transactionId': transactionId,
    'promoApplied': promoApplied,
  };
}

/// Ride state enum
enum RideState {
  requested,
  accepted,
  enRoute,
  arrived,
  inProgress,
  completed,
  cancelled,
  rejected
}

/// Acknowledgement state
class AckState {
  bool passengerAck;
  bool driverAck;

  AckState({this.passengerAck = false, this.driverAck = false});

  factory AckState.fromJson(Map<String, dynamic> json) => AckState(
    passengerAck: json['passengerAck'] ?? false,
    driverAck: json['driverAck'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'passengerAck': passengerAck,
    'driverAck': driverAck,
  };
}

/// Rating model
class RideRating {
  double? driverRating;
  String? driverReview;
  double? passengerRating;
  String? passengerReview;
  DateTime? ratedAt;

  RideRating({this.driverRating, this.driverReview, this.passengerRating, this.passengerReview, this.ratedAt});

  factory RideRating.fromJson(Map<String, dynamic> json) => RideRating(
    driverRating: (json['driverRating'] as num?)?.toDouble(),
    driverReview: json['driverReview'],
    passengerRating: (json['passengerRating'] as num?)?.toDouble(),
    passengerReview: json['passengerReview'],
    ratedAt: json['ratedAt'] != null ? DateTime.parse(json['ratedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    'driverRating': driverRating,
    'driverReview': driverReview,
    'passengerRating': passengerRating,
    'passengerReview': passengerReview,
    'ratedAt': ratedAt?.toIso8601String(),
  };
}

/// Ride cancellation/rejection
class RideCancelReject {
  String? canceledBy; // "passenger" or "driver"
  String? reason;
  DateTime? timestamp;

  RideCancelReject({this.canceledBy, this.reason, this.timestamp});

  factory RideCancelReject.fromJson(Map<String, dynamic> json) => RideCancelReject(
    canceledBy: json['canceledBy'],
    reason: json['reason'],
    timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
  );

  Map<String, dynamic> toJson() => {
    'canceledBy': canceledBy,
    'reason': reason,
    'timestamp': timestamp?.toIso8601String(),
  };
}

/// Main Booking model
class Booking {
  String? id;
  String? rideId;

  GoogleLocation? source;
  GoogleLocation? destination;

  Passenger? passenger;
  Driver? driver;
  Vehicle? vehicle;

  int? noOfPersons;
  DateTime? bookingTime;
  double? estimatedPrice;

  PaymentDetails? payment;

  String? distance;       // e.g., "12.3 km"
  String? expectedTime;   // e.g., "25 mins"
  List<LatLng>? polyline;

  RideState? state;
  AckState? ack;
  RideRating? rating;
  RideCancelReject? cancelReject;

  Booking({
    this.id,
    this.rideId,
    this.source,
    this.destination,
    this.passenger,
    this.driver,
    this.vehicle,
    this.noOfPersons,
    this.bookingTime,
    this.estimatedPrice,
    this.payment,
    this.distance,
    this.expectedTime,
    this.polyline,
    this.state,
    this.ack,
    this.rating,
    this.cancelReject,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'],
    rideId: json['rideId'],
    source: json['source'] != null ? GoogleLocation.fromJson(json['source']) : null,
    destination: json['destination'] != null ? GoogleLocation.fromJson(json['destination']) : null,
    passenger: json['passenger'] != null ? Passenger.fromJson(json['passenger']) : null,
    driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
    vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
    noOfPersons: json['noOfPersons'],
    bookingTime: json['bookingTime'] != null ? DateTime.parse(json['bookingTime']) : null,
    estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble(),
    payment: json['payment'] != null ? PaymentDetails.fromJson(json['payment']) : null,
    distance: json['distance'],
    expectedTime: json['expectedTime'],
    state: json['state'] != null ? RideState.values[json['state']] : null,
    ack: json['ack'] != null ? AckState.fromJson(json['ack']) : null,
    rating: json['rating'] != null ? RideRating.fromJson(json['rating']) : null,
    cancelReject: json['cancelReject'] != null ? RideCancelReject.fromJson(json['cancelReject']) : null,
    polyline: json['polyline'] != null
        ? (json['polyline'] as List)
        .map((e) => LatLng((e['lat'] as num).toDouble(), (e['lng'] as num).toDouble()))
        .toList()
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'rideId': rideId,
    'source': source?.toJson(),
    'destination': destination?.toJson(),
    'passenger': passenger?.toJson(),
    'driver': driver?.toJson(),
    'vehicle': vehicle?.toJson(),
    'noOfPersons': noOfPersons,
    'bookingTime': bookingTime?.toIso8601String(),
    'estimatedPrice': estimatedPrice,
    'payment': payment?.toJson(),
    'distance': distance,
    'expectedTime': expectedTime,
    'state': state != null ? state!.index : null,
    'ack': ack?.toJson(),
    'rating': rating?.toJson(),
    'cancelReject': cancelReject?.toJson(),
    'polyline': polyline
        ?.map((e) => {'lat': e.latitude, 'lng': e.longitude})
        .toList(),
  };
}
