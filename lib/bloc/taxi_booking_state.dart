import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../loginModules/entity/TypeOfAmbulance.dart';
import '../models/payment_details.dart';
import '../models/payment_method.dart';
import '../models/taxi.dart';
import '../models/taxi_booking.dart';
import '../models/taxi_driver.dart';

// Initial state
abstract class TaxiBookingState extends Equatable {
  final bool showBottomSheet;

  const TaxiBookingState({this.showBottomSheet = true});
}

class TaxiBookingNotInitializedState extends TaxiBookingState {
  const TaxiBookingNotInitializedState();

  @override
  List<Object> get props => [];
}

// When taxis are loaded but none selected yet
class TaxiBookingNotSelectedState extends TaxiBookingState {
  final List<Taxi> taxisAvailable;
  final bool showBottomSheet; // new flag for scroll visibility

  const TaxiBookingNotSelectedState({
    required this.taxisAvailable,
    this.showBottomSheet = true, // default show
  });

  // Helper method to copy with updated bottom sheet visibility
  TaxiBookingNotSelectedState copyWith({bool? showBottomSheet}) {
    return TaxiBookingNotSelectedState(
      taxisAvailable: taxisAvailable,
      showBottomSheet: showBottomSheet ?? this.showBottomSheet,
    );
  }

  @override
  List<Object> get props => [taxisAvailable, showBottomSheet];
}

// When booking details not filled
class DetailsNotFilledState extends TaxiBookingState {
  final TaxiBooking? booking;
  final bool showBottomSheet; // new flag for scroll visibility

  const DetailsNotFilledState(
      {required this.booking, this.showBottomSheet = true});

  @override
  List<Object> get props => [booking ?? TaxiBooking.named(), showBottomSheet];

  // Helper method to copy with updated bottom sheet visibility
  DetailsNotFilledState copyWith({bool? showBottomSheet}) {
    return DetailsNotFilledState(
      booking: booking,
      showBottomSheet: showBottomSheet ?? this.showBottomSheet,
    );
  }
}

// When taxi not selected yet
class TaxiNotSelectedState extends TaxiBookingState {
  final TaxiBooking? booking;
  final List<TypeOfAmbulance> typeOfAmbulanceList;
  final bool showBottomSheet; // Flag for scroll visibility

  const TaxiNotSelectedState({
    required this.booking,
    this.typeOfAmbulanceList = const [],
    this.showBottomSheet = true,
  });

  @override
  List<Object?> get props => [booking, typeOfAmbulanceList, showBottomSheet];

  // Helper method to copy with updated bottom sheet visibility or other values
  TaxiNotSelectedState copyWith({
    TaxiBooking? booking,
    List<TypeOfAmbulance>? typeOfAmbulanceList,
    bool? showBottomSheet,
  }) {
    return TaxiNotSelectedState(
      booking: booking ?? this.booking,
      typeOfAmbulanceList: typeOfAmbulanceList ?? this.typeOfAmbulanceList,
      showBottomSheet: showBottomSheet ?? this.showBottomSheet,
    );
  }
}

// When payment methods loaded but not made
class PaymentNotInitializedState extends TaxiBookingState {
  final TaxiBooking? booking; // nullable
  final List<PaymentMethod> methodsAvaiable;
  final List<TypeOfAmbulance> typeOfAmbulanceList;

  const PaymentNotInitializedState(
      {this.booking,
      required this.methodsAvaiable,
      this.typeOfAmbulanceList = const []});

  @override
  List<Object?> get props => [booking, methodsAvaiable, typeOfAmbulanceList];
}

// When taxi assigned but not confirmed
class TaxiNotConfirmedState extends TaxiBookingState {
  final TaxiDriver driver;
  final TaxiBooking booking;

  const TaxiNotConfirmedState({required this.driver, required this.booking});

  @override
  List<Object> get props => [driver, booking];
}

class TaxiBookingConfirmedState extends TaxiBookingState {
  final TaxiDriver driver;
  final TaxiBooking booking;
  final bool showBottomSheet;
  final LatLng? driverLocation;
  final List<LatLng>? polyline;

  const TaxiBookingConfirmedState({
    required this.driver,
    required this.booking,
    this.showBottomSheet = true,
    this.driverLocation,
    this.polyline,
  });

  @override
  List<Object?> get props => [
        driver,
        booking,
        showBottomSheet,
        driverLocation,
        polyline,
      ];

  TaxiBookingConfirmedState copyWith({
    TaxiDriver? driver,
    TaxiBooking? booking,
    bool? showBottomSheet,
    LatLng? driverLocation,
    List<LatLng>? polyline,
  }) {
    return TaxiBookingConfirmedState(
      driver: driver ?? this.driver,
      booking: booking ?? this.booking,
      showBottomSheet: showBottomSheet ?? this.showBottomSheet,
      driverLocation: driverLocation ?? this.driverLocation,
      polyline: polyline ?? this.polyline,
    );
  }
}

// Loading wrapper state
class TaxiBookingLoadingState extends TaxiBookingState {
  final TaxiBookingState state;

  @override
  List<Object> get props => [state];

  const TaxiBookingLoadingState({required this.state});
}

// Cancelled
class TaxiBookingCancelledState extends TaxiBookingState {
  const TaxiBookingCancelledState();

  @override
  List<Object> get props => [];
}

class TaxiBookingRequestedState extends TaxiBookingState {
  final TaxiBooking booking;

  TaxiBookingRequestedState({required this.booking});

  @override
  List<Object> get props => [booking];
}

class TaxiRideStartedState extends TaxiBookingState {
  final TaxiBooking booking;
  final TaxiDriver driver;

  TaxiRideStartedState({required this.booking, required this.driver});

  @override
  List<Object> get props => [booking, driver];
}

// Loading wrapper state
class FetchTaxiTypeState extends TaxiBookingState {
  final List<TypeOfAmbulance> typeOfAmbulanceList;
  final bool showBottomSheet;

  const FetchTaxiTypeState({
    required this.typeOfAmbulanceList,
    this.showBottomSheet = true,
  });

  @override
  List<Object> get props => [typeOfAmbulanceList];

  // Helper method to copy with updated bottom sheet visibility
  FetchTaxiTypeState copyWith({bool? showBottomSheet}) {
    return FetchTaxiTypeState(
      typeOfAmbulanceList: typeOfAmbulanceList,
      showBottomSheet: showBottomSheet ?? this.showBottomSheet,
    );
  }
}

class CompleteRideState extends TaxiBookingState {
  final TaxiBooking booking;
  final PaymentDetails paymentDetails;

  CompleteRideState({required this.booking, required this.paymentDetails});

  @override
  List<Object> get props => [booking, paymentDetails];
}

class NoDriverAvailableState extends TaxiBookingState {
  final String noDriverAvailable;

  NoDriverAvailableState({required this.noDriverAvailable});

  @override
  List<Object> get props => [noDriverAvailable];
}

class TaxiSelectedState extends TaxiBookingState {
  final TypeOfAmbulance? selectedAmbulanceType;
  final int selectedPrice;

  const TaxiSelectedState({
    required this.selectedAmbulanceType,
    required this.selectedPrice,
  });

  @override
  List<Object?> get props => [selectedAmbulanceType, selectedPrice];
}

class ShowRideCancelWidgetState extends TaxiBookingState {
  final TaxiDriver driver;
  final TaxiBooking booking;

  ShowRideCancelWidgetState({required this.driver, required this.booking});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RatingInitial extends TaxiBookingState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class RatingSubmitting extends TaxiBookingState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class RatingSuccess extends TaxiBookingState {
  final String message;

  RatingSuccess(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class RatingFailure extends TaxiBookingState {
  final String error;

  RatingFailure(this.error);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class TaxiSearchingState extends TaxiBookingState {
  final TaxiBooking booking;

  const TaxiSearchingState({required this.booking});

  @override
  List<Object> get props => [booking];
}

class TaxiBookingCancellingState extends TaxiBookingState {
  @override
  List<Object?> get props => throw UnimplementedError();
}
