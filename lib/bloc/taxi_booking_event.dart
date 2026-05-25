import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schoolmanagementsystem/models/rating/rating_entity.dart';

import '../loginModules/entity/TypeOfAmbulance.dart';
import '../models/google_location.dart';
import '../models/payment_details.dart';
import '../models/ride_cancellation_reason.dart';
import '../models/taxi_booking.dart';
import '../models/taxi_driver.dart';

abstract class TaxiBookingEvent extends Equatable {
  const TaxiBookingEvent();

  @override
  List<Object?> get props => [];
}
class LoadTaxisEvent extends TaxiBookingEvent {
  final LatLng position;

  LoadTaxisEvent({required this.position});
}
class TaxiBookingStartEvent extends TaxiBookingEvent {
  final LatLng position;

  TaxiBookingStartEvent({required this.position});

  @override
  List<Object?> get props => [position];
}

class DestinationSelectedEvent extends TaxiBookingEvent {
  final LatLng? destination;

  const DestinationSelectedEvent({required this.destination});

  @override
  List<Object?> get props => [destination];
}

class DetailsSubmittedEvent extends TaxiBookingEvent {
  final GoogleLocation source;
  final GoogleLocation destination;
  final String noOfPersons;
  final DateTime bookingTime;
  final String Driver_Id;
  final String Passenger_Id;
  final String O12_AddedBy;

  const DetailsSubmittedEvent({
    required this.source,
    required this.destination,
    required this.noOfPersons,
    required this.bookingTime,
    required this.Driver_Id,
    required this.Passenger_Id,
    required this.O12_AddedBy,
  });

  @override
  List<Object?> get props => [
        source,
        destination,
        noOfPersons,
        bookingTime,
        Driver_Id,
        Passenger_Id,
        O12_AddedBy
      ];
}

class TaxiSelectedEvent extends TaxiBookingEvent {
  final TypeOfAmbulance? selectedAmbulanceType;
  final List<TypeOfAmbulance> typeOfAmbulanceList;
  final double? price;
  final String? espectedTime;
  final String? distance;

  const TaxiSelectedEvent({
    required this.selectedAmbulanceType,
    this.typeOfAmbulanceList = const [],
    this.price,
    this.espectedTime,
    this.distance,
  });

  @override
  List<Object?> get props =>
      [selectedAmbulanceType, typeOfAmbulanceList, price];
}

class PaymentMadeEvent extends TaxiBookingEvent {
  final TaxiBooking booking;

  const PaymentMadeEvent({required this.booking});

  @override
  List<Object?> get props => [booking];
}

class BackPressedEvent extends TaxiBookingEvent {
  @override
  List<Object?> get props => [];
}

class TaxiBookingCancelEvent extends TaxiBookingEvent {
  @override
  List<Object?> get props => [];
}

class ConfirmBookingEvent extends TaxiBookingEvent {
  final TaxiBooking booking;
  final TaxiDriver driver;

  ConfirmBookingEvent({required this.booking, required this.driver});
}

class ShowBottomSheetEvent extends TaxiBookingEvent {} // scroll up

class HideBottomSheetEvent extends TaxiBookingEvent {} // scroll down

class DriverAcceptedEvent extends TaxiBookingEvent {
  final TaxiDriver driver;
  final TaxiBooking booking;

  DriverAcceptedEvent({required this.driver, required this.booking});

  @override
  List<Object?> get props => [driver, booking];
}

class StartRideEvent extends TaxiBookingEvent {
  final TaxiDriver driver;
  final TaxiBooking booking;

  StartRideEvent({required this.driver, required this.booking});

  @override
  List<Object?> get props => [driver, booking];
}

class UpdateDriverLocationEvent extends TaxiBookingEvent {
  final GoogleLocation location;

  UpdateDriverLocationEvent({required this.location});

  @override
  List<Object?> get props => [location];
}

class CompleteRideEvent extends TaxiBookingEvent {
  final TaxiBooking booking;
  final PaymentDetails paymentDetails;

  CompleteRideEvent({required this.booking, required this.paymentDetails});

  @override
  List<Object?> get props => [booking, paymentDetails];
}

// Event for accepting the ride and showing the pickup route
class TaxiRideAcceptedEvent extends TaxiBookingEvent {
  final TaxiDriver driver;
  final TaxiBooking booking;

  TaxiRideAcceptedEvent({required this.driver, required this.booking});

  @override
  List<Object?> get props => [driver, booking];
}

// Event for accepting the ride and showing the pickup route
class TaxiRideArrivedEvent extends TaxiBookingEvent {
  final TaxiDriver driver;
  final TaxiBooking booking;

  TaxiRideArrivedEvent({required this.driver, required this.booking});

  @override
  List<Object?> get props => [driver, booking];
}

// Event for starting the ride after the passenger is picked up
class TaxiRideStartedEvent extends TaxiBookingEvent {
  final TaxiDriver driver;
  final TaxiBooking booking;

  TaxiRideStartedEvent({required this.driver, required this.booking});

  @override
  List<Object?> get props => [driver, booking];
}

class FetchTaxiEvent extends TaxiBookingEvent {
  @override
  List<Object?> get props => [];
}


class ConnectWebSocketEvent extends TaxiBookingEvent {}

class DisconnectWebSocketEvent extends TaxiBookingEvent {}

class NoDriverAvailableEvent extends TaxiBookingEvent {
  final String noDriverAvailable;

  NoDriverAvailableEvent({required this.noDriverAvailable});

  @override
  List<Object?> get props => [noDriverAvailable];
}

class RideCancellationApiEvent extends TaxiBookingEvent {
  final RideCancellationReason cancellationReason;
  final TaxiBooking taxiBooking;

  RideCancellationApiEvent({
    required this.cancellationReason,
    required this.taxiBooking,
  });
}

class RideCancelledByDriverEvent extends TaxiBookingEvent {}

class ShowRideCancelWidgetEvent extends TaxiBookingEvent {
  final TaxiDriver driver;
  final TaxiBooking booking;

  ShowRideCancelWidgetEvent({required this.driver, required this.booking});

  @override
  List<Object?> get props => [driver, booking];
}

class SubmitRatingEvent extends TaxiBookingEvent {
  final RatingEntity rating;

  SubmitRatingEvent(this.rating);
}
