import 'package:equatable/equatable.dart';

enum RideStatus {
  completed,
  cancelled,
  upcoming,
}

enum RideType {
  bike,
  auto,
  car,
}

class Ride extends Equatable {
  final String id;
  final String rideId;
  final DateTime dateTime;
  final String pickupLocation;
  final String dropLocation;
  final double distance;
  final double amount;
  final RideStatus status;
  final RideType rideType;
  final String? driverName;
  final String? driverImage;
  final String? vehicleNumber;
  final String? paymentMethod;
  final double? rating;

  const Ride({
    required this.id,
    required this.rideId,
    required this.dateTime,
    required this.pickupLocation,
    required this.dropLocation,
    required this.distance,
    required this.amount,
    required this.status,
    required this.rideType,
    this.driverName,
    this.driverImage,
    this.vehicleNumber,
    this.paymentMethod,
    this.rating,
  });

  @override
  List<Object?> get props => [
    id,
    rideId,
    dateTime,
    pickupLocation,
    dropLocation,
    distance,
    amount,
    status,
    rideType,
    driverName,
    driverImage,
    vehicleNumber,
    paymentMethod,
    rating,
  ];

  Ride copyWith({
    String? id,
    String? rideId,
    DateTime? dateTime,
    String? pickupLocation,
    String? dropLocation,
    double? distance,
    double? amount,
    RideStatus? status,
    RideType? rideType,
    String? driverName,
    String? driverImage,
    String? vehicleNumber,
    String? paymentMethod,
    double? rating,
  }) {
    return Ride(
      id: id ?? this.id,
      rideId: rideId ?? this.rideId,
      dateTime: dateTime ?? this.dateTime,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropLocation: dropLocation ?? this.dropLocation,
      distance: distance ?? this.distance,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      rideType: rideType ?? this.rideType,
      driverName: driverName ?? this.driverName,
      driverImage: driverImage ?? this.driverImage,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      rating: rating ?? this.rating,
    );
  }
}