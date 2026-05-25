import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schoolmanagementsystem/bloc/services/location_service.dart';
import 'package:schoolmanagementsystem/bloc/taxi_booking_event.dart';
import 'package:schoolmanagementsystem/bloc/taxi_booking_state.dart';
import 'package:schoolmanagementsystem/data/newtwork/network_api_services.dart';
import 'package:schoolmanagementsystem/models/payment_method.dart';

import '../controllers/location_controller.dart';
import '../controllers/taxi_booking_controller.dart';
import '../controllers/web_socket_handler.dart';
import '../data/newtwork/base_api_services.dart';
import '../data/storage/hive_storage.dart';
import '../loginModules/data/dataSources/dataBaseHelper.dart';
import '../loginModules/data/sharePreferencesKeys.dart';
import '../loginModules/entity/MasterDataEntity.dart';
import '../loginModules/entity/TypeOfAmbulance.dart';
import '../loginModules/entity/UserDetails.dart';
import '../loginModules/globalClass/globalClass.dart';
import '../models/driver_location.dart';
import '../models/google_location.dart';
import '../models/payment_details.dart';
import '../models/ride_cancellation_reason.dart';
import '../models/taxi.dart';
import '../models/taxi_booking.dart';
import '../models/taxi_driver.dart';
import '../models/web_socket_message.dart';
import '../models/websocket_connection.dart';
import '../storage/ride_cancellation_reason_storage.dart';
import '../storage/taxi_booking_storage.dart';
import '../storage/taxi_driver_storage.dart';
import '../storage/taxi_storage.dart';

class TaxiBookingBloc extends Bloc<TaxiBookingEvent, TaxiBookingState> {
  PassengerWebSocket? _webSocketService;
  final int _reconnectDelaySeconds = 5;
  StreamSubscription? _wsSubscription;
  final NetworkApiService _apiService;
  Timer? _searchTimeoutTimer;

  TaxiBookingBloc({
    required PassengerWebSocket? webSocketService,
    required NetworkApiService apiService,
  })  : _webSocketService = webSocketService ?? PassengerWebSocket(),
        _apiService = apiService,
        super(TaxiBookingNotInitializedState()) {
    _webSocketService!.connect();
    _connectWebSocket();
// thsi only show appbar
    on<ShowBottomSheetEvent>((event, emit) {
      if (state is TaxiBookingNotSelectedState ||
          state is TaxiBookingConfirmedState ||
          state is DetailsNotFilledState) {
        emit(_copyWithShowBottomSheet(state, true));
      }
    });
    on<HideBottomSheetEvent>((event, emit) {
      if (state is TaxiBookingNotSelectedState ||
          state is TaxiBookingConfirmedState ||
          state is DetailsNotFilledState) {
        emit(_copyWithShowBottomSheet(state, false));
      }
    });

    // this is calling from ui
    on<TaxiBookingStartEvent>(_onTaxiBookingStart);
    on<DestinationSelectedEvent>(_onDestinationSelected);
    on<DetailsSubmittedEvent>(_onDetailsSubmitted);
    on<TaxiSelectedEvent>(_onTaxiSelected);
    on<PaymentMadeEvent>(_onPaymentMadeWithApi);
    on<SubmitRatingEvent>(_onSubmitRating);

    //this event is back ui
    on<BackPressedEvent>(_onBackPressed);

    //this event is fetch taxi details form api
    on<FetchTaxiEvent>(_onFetchTaxiEvent);

    // this is websocket coming event
    on<TaxiRideAcceptedEvent>(_onTaxiRideAcceptedEvent);
    on<TaxiRideArrivedEvent>(_onTaxiRideArrivedEvent);
    on<StartRideEvent>(_onStartRideEvent);
    on<CompleteRideEvent>(_onCompleteRideEvent);
    on<NoDriverAvailableEvent>(_onNoDriverAvailableEvent);
    on<UpdateDriverLocationEvent>(_onUpdateDriverLocationEvent);

    //this is related to connection event
    on<ConnectWebSocketEvent>(_onConnectWebSocketEvent);
    on<DisconnectWebSocketEvent>(_onDisconnectWebSocketEvent);

    // this is Cancellation event
    on<ShowRideCancelWidgetEvent>(_onShowRideCancelWidgetEvent);
    on<RideCancellationApiEvent>(_onRideCancellationApiEvent);
    on<RideCancelledByDriverEvent>(_onRideCancelledByDriverEvent);
    on<TaxiBookingCancelEvent>(_onBookingCancel);
  }

  void _connection(data) async {
    final wsMessage = WebSocketMessage.fromMap(
        data, (values) => WebSocketConnection.fromMap(values));
    print(wsMessage.data);
    if (wsMessage.data.connectionId.isNotEmpty) {
      await HiveStorage.init();
      await HiveStorage.saveString(
          HiveStorage.keyConnectionID, wsMessage.data.connectionId);
    }
  }

  Future<void> _onRideAccepted(dynamic data) async {
    try {
      _searchTimeoutTimer?.cancel();
      // Parse WS message
      final wsMessage = WebSocketMessage.fromMap(
        data,
        (values) => TaxiDriver.fromMap(values),
      );
      final TaxiDriver incomingDriver = wsMessage.data;
      final String incomingRideId = incomingDriver.ride_Id ?? "";
      if (incomingRideId.isEmpty) return;
      // Init storage
      await HiveStorage.init();
      await HiveStorage.saveString(HiveStorage.keyRideId, incomingRideId);
      await HiveStorage.saveString(
          HiveStorage.keyDriverId, incomingDriver.driver_Id);
      await HiveStorage.saveString(
          HiveStorage.keyRideOtp, incomingDriver.Ride_OTP.toString());

      final String? connectionID =
          await HiveStorage.fetchString(HiveStorage.keyConnectionID);

      if (connectionID != null && connectionID.isNotEmpty) {
        final ackMessage = WebSocketMessage(
          connectionID: connectionID,
          type: 'Acknowledgement',
          SA10_UserType_Id: 4,
          data: null,
        );

        final ackMap = ackMessage.toMap();

        if (_webSocketService != null) {
          _webSocketService!.sendMessage(ackMap);
        } else {
          PassengerWebSocket().sendMessage(ackMap);
        }
      }

      // Load booking
      TaxiBooking? booking = await TaxiBookingStorage.getTaxiBooking();

      if (booking == null) {
        final str = await HiveStorage.fetchString(HiveStorage.keyTaxiBooking);
        if (str != null) {
          booking = TaxiBooking.fromJson(jsonDecode(str));
        }
      }

      if (booking == null) return;

      // ✅ FIX: copyWith must be assigned
      final TaxiDriver updatedDriver =
          incomingDriver.copyWith(driverAccepted: true);

      final TaxiBooking bookingData = await booking.copyWith(
        Status_ID: updatedDriver.RideStatus_Id,
        taxiDriver: updatedDriver,
      );

      // Persist booking
      await HiveStorage.saveString(
        HiveStorage.keyTaxiBooking,
        jsonEncode(bookingData.toMap()),
      );

      await TaxiBookingStorage.addDetails(bookingData);

      // UI state
      emit(TaxiNotConfirmedState(
        booking: bookingData,
        driver: updatedDriver,
      ));

      // Guarded delayed transition
      Future.delayed(const Duration(seconds: 2), () {
        if (state is TaxiNotConfirmedState) {
          add(TaxiRideAcceptedEvent(
            booking: bookingData,
            driver: updatedDriver,
          ));
        }
      });
    } catch (e, stackTrace) {
      debugPrint("RideAccepted error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _onRideLocationUpdate(dynamic data) async {
    try {
      final wsMessage = WebSocketMessage.fromMap(
        data,
        (values) => DriverLocation.fromMap(values),
      );

      final DriverLocation driver = wsMessage.data;

      // ❌ Ignore invalid GPS
      if (driver.Lattitude == 0 ||
          driver.Longitude == 0 ||
          driver.Lattitude.isNaN ||
          driver.Longitude.isNaN) {
        return;
      }

      // ✅ Update only after ride is active
      if (state is! TaxiNotConfirmedState &&
          state is! TaxiBookingConfirmedState &&
          state is! TaxiRideStartedState) {
        return;
      }

      final googleLocation = GoogleLocation(
        placeId: "",
        position: LatLng(driver.Lattitude, driver.Longitude),
        areaDetails: "",
      );

      add(UpdateDriverLocationEvent(location: googleLocation));
    } catch (e, stackTrace) {
      debugPrint("Ride location update error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _onRideArrived(data) async {
    try {
      _searchTimeoutTimer?.cancel();
      final wsMessage = WebSocketMessage.fromMap(
        data,
        (values) => TaxiDriver.fromMap(values),
      );
      final String incomingRideId = wsMessage.data.ride_Id ?? "";
      if (incomingRideId.isEmpty) return;
      await HiveStorage.init();
      final String? storedRideId =
          await HiveStorage.fetchString(HiveStorage.keyRideId);
      // ❌ NOT SAME RIDE → IGNORE
      if (storedRideId != null &&
          storedRideId.isNotEmpty &&
          storedRideId != incomingRideId) {
        debugPrint(
          "Ignored WS message. Stored=$storedRideId Incoming=$incomingRideId",
        );
        return;
      }

      // Load booking
      TaxiBooking? booking = await TaxiBookingStorage.getTaxiBooking();
      if (booking == null) {
        final str = await HiveStorage.fetchString(HiveStorage.keyTaxiBooking);
        if (str != null) {
          booking = TaxiBooking.fromJson(jsonDecode(str));
        }
      }

      if (booking == null) return;

      // Prefer existing driver, fallback to WS driver
      final TaxiDriver driver = booking.taxiDriver != null
          ? booking.taxiDriver!.copyWith(
              driverAccepted: true,
              isRideStarted: false,
            )
          : wsMessage.data.copyWith(
              driverAccepted: true,
              isRideStarted: false,
            );

      final TaxiBooking updatedBooking =
          await booking.copyWith(taxiDriver: driver);

      // Persist
      await TaxiBookingStorage.addDetails(updatedBooking);
      await HiveStorage.saveString(
        HiveStorage.keyTaxiBooking,
        jsonEncode(updatedBooking.toMap()),
      );

      // Emit event
      add(TaxiRideArrivedEvent(
        booking: updatedBooking,
        driver: driver,
      ));
    } catch (e, stackTrace) {
      debugPrint("Ride arrived handling error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _onRideStart(data) async {
    try {
      // ✅ Stop search timeout (important)
      _searchTimeoutTimer?.cancel();

      final wsMessage = WebSocketMessage.fromMap(
        data,
        (values) => TaxiDriver.fromMap(values),
      );

      final String incomingRideId = wsMessage.data.ride_Id ?? "";
      if (incomingRideId.isEmpty) return;
      await HiveStorage.init();
      final String? storedRideId =
          await HiveStorage.fetchString(HiveStorage.keyRideId);
      // ❌ NOT SAME RIDE → IGNORE
      if (storedRideId != null &&
          storedRideId.isNotEmpty &&
          storedRideId != incomingRideId) {
        debugPrint(
          "Ignored WS message. Stored=$storedRideId Incoming=$incomingRideId",
        );
        return;
      }

      TaxiBooking? booking = await TaxiBookingStorage.getTaxiBooking();
      if (booking == null) {
        final str = await HiveStorage.fetchString(HiveStorage.keyTaxiBooking);
        if (str != null) {
          booking = TaxiBooking.fromJson(jsonDecode(str));
        }
      }
      if (booking == null) return;
      final TaxiDriver driver = booking.taxiDriver != null
          ? booking.taxiDriver!.copyWith(
              isRideStarted: true,
              RideStatus_Id: '4', // ride started
            )
          : wsMessage.data.copyWith(
              isRideStarted: true,
              RideStatus_Id: '4',
            );

      final TaxiBooking updatedBooking =
          await booking.copyWith(taxiDriver: driver);

      // Persist
      await TaxiBookingStorage.addDetails(updatedBooking);
      await HiveStorage.saveString(
        HiveStorage.keyTaxiBooking,
        jsonEncode(updatedBooking.toMap()),
      );

      // Notify bloc state machine
      add(StartRideEvent(
        booking: updatedBooking,
        driver: driver,
      ));
    } catch (e, stackTrace) {
      debugPrint("Ride start handling error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _onRideEnd(data) async {
    try {
      final wsMessage = WebSocketMessage.fromMap(
        data,
        (values) => PaymentDetails.fromMap(values),
      );
      final PaymentDetails paymentDetails = wsMessage.data;

      final String incomingRideId = "${wsMessage.data.Ride_Id}";
      if (incomingRideId.isEmpty) return;
      await HiveStorage.init();
      final String? storedRideId =
          await HiveStorage.fetchString(HiveStorage.keyRideId);
      // ❌ NOT SAME RIDE → IGNORE
      if (storedRideId != null &&
          storedRideId.isNotEmpty &&
          storedRideId != incomingRideId) {
        debugPrint(
          "Ignored WS message. Stored=$storedRideId Incoming=$incomingRideId",
        );
        return;
      }
      // Load booking
      TaxiBooking? booking = await TaxiBookingStorage.getTaxiBooking();
      await HiveStorage.init();

      if (booking == null) {
        final str = await HiveStorage.fetchString(HiveStorage.keyTaxiBooking);
        if (str != null) {
          booking = TaxiBooking.fromJson(jsonDecode(str));
        }
      }

      if (booking == null) return;

      // ✅ Guard: already completed
      if (booking.paymentDetails != null) {
        return;
      }

      // Attach payment details
      final TaxiBooking updatedBooking =
          await booking.copyWith(paymentDetails: paymentDetails);

      // Persist
      await TaxiBookingStorage.addDetails(updatedBooking);
      await HiveStorage.saveString(
        HiveStorage.keyTaxiBooking,
        jsonEncode(updatedBooking.toMap()),
      );

      // Emit completion
      add(CompleteRideEvent(
        booking: updatedBooking,
        paymentDetails: paymentDetails,
      ));
    } catch (e, stackTrace) {
      debugPrint("Ride end handling error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _onRideCancelledByDriver(dynamic data) async {
    try {
      final wsMessage = WebSocketMessage.fromMap(
        data,
        (values) => PaymentDetails.fromMap(values),
      );

      final String incomingRideId = wsMessage.data.Ride_Id.toString() ?? "";
      if (incomingRideId.isEmpty) return;
      await HiveStorage.init();
      final String? storedRideId =
          await HiveStorage.fetchString(HiveStorage.keyRideId);
      // ❌ Different ride → ignore completely
      if (storedRideId != null &&
          storedRideId.isNotEmpty &&
          storedRideId != incomingRideId) {
        debugPrint(
          "RideCancelledByDriver ignored. Stored=$storedRideId Incoming=$incomingRideId",
        );
        return;
      }
      await clearRideSessionData();
      add(RideCancelledByDriverEvent());
    } catch (e, stackTrace) {
      debugPrint("RideCancelledByDriver error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> clearRideSessionData() async {
    await HiveStorage.init();
    await HiveStorage.deleteRideData();
    await TaxiBookingStorage.clear();
  }

  void _onRidePayment(data) async {
    try {
      final wsMessage = WebSocketMessage.fromMap(
        data,
        (values) => PaymentDetails.fromMap(values),
      );

      final PaymentDetails paymentDetails = wsMessage.data;

      // Load booking
      TaxiBooking? booking = await TaxiBookingStorage.getTaxiBooking();
      await HiveStorage.init();

      if (booking == null) {
        final str = await HiveStorage.fetchString(HiveStorage.keyTaxiBooking);
        if (str != null) {
          booking = TaxiBooking.fromJson(jsonDecode(str));
        }
      }

      if (booking == null) return;

      // ✅ Guard: payment already processed
      if (booking.paymentDetails != null) {
        return;
      }

      // Attach payment
      final TaxiBooking updatedBooking =
          await booking.copyWith(paymentDetails: paymentDetails);

      // Persist
      await TaxiBookingStorage.addDetails(updatedBooking);
      await HiveStorage.saveString(
        HiveStorage.keyTaxiBooking,
        jsonEncode(updatedBooking.toMap()),
      );

      // Emit completion ONCE
      add(CompleteRideEvent(
        booking: updatedBooking,
        paymentDetails: paymentDetails,
      ));
    } catch (e, stackTrace) {
      debugPrint("Ride payment handling error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _handleIncomingMessage(String message) {
    try {
      final data = json.decode(message);
      String type = data['type'];
      if (kDebugMode) {
        print("WebSocket $data");
      }
      switch (type) {
        case 'connection':
          _connection(data);
          break;
        case 'Ride_Accept':
          _onRideAccepted(data);
          break;
        case 'Ride_Location_Update':
          if (kDebugMode) {
            print("Location received from driver: $data");
          }
          if (data['statusCode'] != 200) return;
          _onRideLocationUpdate(data);
          break;

          break;
        case 'Ride_Arrived':
          _onRideArrived(data);
          break;
        case 'Ride_Started':
          _onRideStart(data);
          break;
        case 'Ride_End':
          _onRideEnd(data);
          break;
        case 'ride_cancelled':
        // onRideCancelled!(data);
        case 'Ride_Payment':
          _onRidePayment(data);
          break;
        case 'Driver_Not_Available':
          _onDriverNotAvailable(data);
          break;

        case 'Ride_CancelledByDriver':
          if (data.containsKey('statusCode') && data['statusCode'] == 200) {
            _onRideCancelledByDriver(data);
          }
          break;
        default:
          print('Unknown event: $type');
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  void _connectWebSocket() {
    _wsSubscription = _webSocketService?.messages.listen(
      (message) => _handleIncomingMessage(message),
      onError: (err) {
        if (kDebugMode) print("Bloc websocket stream error: $err");
        // Optionally schedule a reconnect attempt
        Future.delayed(Duration(seconds: _reconnectDelaySeconds), () {
          _webSocketService!.connect();
        });
      },
      onDone: () {
        if (kDebugMode) print("Bloc websocket stream done - attempt reconnect");
        Future.delayed(Duration(seconds: _reconnectDelaySeconds), () {
          _webSocketService!.connect();
        });
      },
    );
  }

  void _rideCancellationEvent(RideCancellationReason cancellationReason) async {
    final position = await LocationController.getCurrentLocationNew();
    UserDetails? userDetails = await DataBaseHelper.getUserDetailsDetails();
    if (userDetails == null || (userDetails.TraineeID ?? "").isEmpty) return;
    await HiveStorage.init();
    String connectionID =
        await HiveStorage.fetchString(HiveStorage.keyConnectionID) ?? "";
    String rideID = await HiveStorage.fetchString(HiveStorage.keyRideId) ?? "";
    String driverID =
        await HiveStorage.fetchString(HiveStorage.keyDriverId) ?? "";
    var driverLocation = TaxiDriver.named(
        driverLocation: position,
        ride_Id: rideID,
        driverAccepted: true,
        isRideStarted: true,
        rideCancellationReason: RideCancellationReason(
            RideCancellationReason_Id:
                cancellationReason.RideCancellationReason_Id,
            RideCancellationReason_Title:
                cancellationReason.RideCancellationReason_Title,
            RideCancellationReason_Description:
                cancellationReason.RideCancellationReason_Description),
        RideStatus_Id: "6");

    final WebSocketMessage webSocketMessage = WebSocketMessage(
        type: "Ride_CancelledByPassenger",
        data: driverLocation,
        driverID: driverID,
        SA10_UserType_Id: 4,
        passengerID: userDetails.TraineeID,
        connectionID: connectionID);
    final data = webSocketMessage.toMap();
    // _webSocketService?.sendMessage(data);
    try {
      final Map<String, dynamic> queryParams = {
        'mode': 'Ride_CancelledByPassenger',
      };
      var response = await _apiService.postApiResponse(
        "AmbulanceTracking",
        queryParams,
        jsonEncode(data),
      );
      if (response != null) {
        add(BackPressedEvent());
      } else {
        GlobalClass.fetchToastPosition("No response from server");
      }
    } catch (e, stackTrace) {
      print("Error Cancelled By Passenger : $e");
      print(stackTrace);
      GlobalClass.fetchToastPosition("Something went wrong");
    }
  }

  TaxiBookingState _copyWithShowBottomSheet(
      TaxiBookingState currentState, bool show) {
    if (currentState is TaxiBookingNotSelectedState) {
      return TaxiBookingNotSelectedState(
        taxisAvailable: currentState.taxisAvailable,
        showBottomSheet: show,
      );
    } else if (currentState is TaxiBookingConfirmedState) {
      return TaxiBookingConfirmedState(
        driver: currentState.driver,
        booking: currentState.booking,
        showBottomSheet: show,
      );
    }
    return currentState;
  }

  Future<void> _onTaxiBookingStart(
      TaxiBookingStartEvent event, Emitter<TaxiBookingState> emit) async {
    final taxis = await TaxiBookingController.getTaxisAvailable(
        event.position.latitude, event.position.longitude);
    final currentState = state;
    //   emit(TaxiBookingNotSelectedState(taxisAvailable: taxis));
    if (state is TaxiBookingNotInitializedState) {
      emit(TaxiBookingNotSelectedState(taxisAvailable: taxis));
    }
    var rideCancellationReason =
        await RideCancellationReasonStorage.getRideCancellationReason();
    if (rideCancellationReason == null) {
      final rideCancellationReasonList =
          await TaxiBookingController.getRideCancellationReason();
      if (kDebugMode)
        print(
            'Ride_Cancellation_Reason ${jsonEncode(rideCancellationReasonList.map((item) => item.toMap()).toList())}');
      if (rideCancellationReasonList.length > 0)
        RideCancellationReasonStorage.addDetails(rideCancellationReasonList);
    }
  }

  bool _isDriverOffRoute1(
    LatLng current,
    List<LatLng> routePoints, {
    double toleranceInMeters = 70,
  }) {
    if (routePoints.length < 2) return true;

    for (int i = 0; i < routePoints.length - 1; i++) {
      final start = routePoints[i];
      final end = routePoints[i + 1];

      final distance = _distanceToSegment(current, start, end);

      if (distance <= toleranceInMeters) {
        return false; // driver is on route
      }
    }
    return true; // driver deviated
  }

  bool _isDriverOffRoute(LatLng current, List<LatLng> routePoints) {
    const double toleranceInMeters = 70; // Adjust for your app
    for (final point in routePoints) {
      final distance = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        point.latitude,
        point.longitude,
      );
      if (distance <= toleranceInMeters) {
        return false; // still on route
      }
    }
    return true; // deviated from route
  }

  double _distanceToSegment(
    LatLng p,
    LatLng v,
    LatLng w,
  ) {
    final double l2 = _squareDistance(v, w);
    if (l2 == 0.0) {
      return Geolocator.distanceBetween(
        p.latitude,
        p.longitude,
        v.latitude,
        v.longitude,
      );
    }

    double t = ((p.latitude - v.latitude) * (w.latitude - v.latitude) +
            (p.longitude - v.longitude) * (w.longitude - v.longitude)) /
        l2;

    t = t.clamp(0.0, 1.0);

    final projection = LatLng(
      v.latitude + t * (w.latitude - v.latitude),
      v.longitude + t * (w.longitude - v.longitude),
    );

    return Geolocator.distanceBetween(
      p.latitude,
      p.longitude,
      projection.latitude,
      projection.longitude,
    );
  }

  double _squareDistance(LatLng a, LatLng b) {
    final dx = a.latitude - b.latitude;
    final dy = a.longitude - b.longitude;
    return dx * dx + dy * dy;
  }

  Future<void> _onDestinationSelected(
      DestinationSelectedEvent event, Emitter<TaxiBookingState> emit) async {
    TaxiBookingStorage.open();
    emit(TaxiBookingLoadingState(state: DetailsNotFilledState(booking: null)));
    final source = await LocationController.getCurrentLocationNew();
    final destination =
        await LocationController.getLocationfromId(event.destination);

    await TaxiBookingStorage.addDetails(
      TaxiBooking.named(
          source: source, destination: destination, noOfPersons: "1"),
    );

    final booking = await TaxiBookingStorage.getTaxiBooking();
    emit(DetailsNotFilledState(booking: booking));
  }

  Future<void> _onDetailsSubmitted(
      DetailsSubmittedEvent event, Emitter<TaxiBookingState> emit) async {
    emit(TaxiBookingLoadingState(state: TaxiNotSelectedState(booking: null)));
    final List<TypeOfAmbulance> typeOfAmbulanceList =
        await getAvailableAmbulanceTypes();
    final locationService = LocationService();
    Map<String, dynamic> directions;
    await TaxiBookingStorage.addDetails(TaxiBooking.named(
      source: event.source,
      destination: event.destination,
      noOfPersons: event.noOfPersons,
      bookingTime: event.bookingTime,
      O12_AddedBy: event.O12_AddedBy,
    ));
    final booking = await TaxiBookingStorage.getTaxiBooking();
    if (booking == null) {
      return;
    }
    directions = await locationService.getDirections(
      booking.source,
      booking.destination,
    );
    final updatedBooking = await booking.copyWith(
        distance: directions['distance'],
        expectedTime: directions['duration'],
        polyline: directions['polylinePoints']);
    emit(TaxiNotSelectedState(
        booking: updatedBooking, typeOfAmbulanceList: typeOfAmbulanceList));
  }

  /*TODO ON TAXI SELECTED */
  Future<void> _onTaxiSelected(
      TaxiSelectedEvent event, Emitter<TaxiBookingState> emit) async {
    emit(TaxiBookingLoadingState(
      state: PaymentNotInitializedState(booking: null, methodsAvaiable: []),
    ));
    final prevBooking = await TaxiBookingStorage.getTaxiBooking();
    if (prevBooking == null) {
      emit(TaxiBookingNotInitializedState());
      return;
    }
    final price = await TaxiBookingController.getPrice(prevBooking);
    await TaxiBookingStorage.addDetails(
      TaxiBooking.named(
          taxiType: event.selectedAmbulanceType,
          source: prevBooking.source,
          destination: prevBooking.destination,
          distance: event.distance,
          estimatedPrice: event.price), //todo neeraj
    );
    final booking = await TaxiBookingStorage.getTaxiBooking();
    final methods = await _fetchPaymentMethod();
    emit(PaymentNotInitializedState(
      booking: booking,
      methodsAvaiable: methods,
      typeOfAmbulanceList: event.typeOfAmbulanceList,
    ));
  }

  Future<void> _onPaymentMadeWithApi(
    PaymentMadeEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    final booking = event.booking;

    await TaxiBookingStorage.addDetails(
      TaxiBooking.named(
        taxiType: booking.typeOfAmbulance,
        source: booking.source,
        destination: booking.destination,
        estimatedPrice: booking.estimatedPrice,
        paymentMethod: booking.paymentMethod,
      ),
    );

    // 1️⃣ Emit searching state
    emit(TaxiSearchingState(booking: booking));

    // 2️⃣ Start 1-minute timeout
    _searchTimeoutTimer?.cancel();
    _searchTimeoutTimer = Timer(const Duration(minutes: 1), () {
      // Still searching → rollback
      if (state is TaxiSearchingState) {
        emit(
          PaymentNotInitializedState(
            booking: booking,
            methodsAvaiable: const [],
          ),
        );
      }
    });

    final UserDetails? userDetails =
        await DataBaseHelper.getUserDetailsDetails();
    if (userDetails == null) return;

    await HiveStorage.init();
    String connectionID =
        await HiveStorage.fetchString(HiveStorage.keyConnectionID) ?? "";

    final webSocketMessage = WebSocketMessage(
      type: "Booking_Request",
      connectionID: connectionID,
      SA10_UserType_Id: 4,
      passengerID: userDetails.TraineeID,
      O12_AddedBy: userDetails.Designation_ID,
      data: booking,
    );

    try {
      final Map<String, dynamic> queryParams = {
        'mode': 'Booking_Request',
      };

      await _apiService.postApiResponse(
        "AmbulanceTracking",
        queryParams,
        jsonEncode(webSocketMessage.toMap()),
      );
    } catch (e, stackTrace) {
      print("Error booking taxi: $e");
      print(stackTrace);
    }
  }

  Future<void> _onBookingCancel(
      TaxiBookingCancelEvent event, Emitter<TaxiBookingState> emit) async {
    emit(TaxiBookingCancelledState());
    await Future.delayed(const Duration(milliseconds: 500));
    GoogleLocation location = await LocationController.getCurrentLocationNew();
    final taxis = await TaxiBookingController.getTaxisAvailable(
        location.position.latitude, location.position.longitude);
    emit(TaxiBookingNotSelectedState(taxisAvailable: taxis));
  }

  Future<void> _onBackPressed(
      BackPressedEvent event, Emitter<TaxiBookingState> emit) async {
    final currentState = state;
    if (currentState is DetailsNotFilledState ||
        currentState is CompleteRideState) {
      GoogleLocation location =
          await LocationController.getCurrentLocationNew();
      final taxis = await TaxiBookingController.getTaxisAvailable(
          location.position.latitude, location.position.longitude);
      emit(TaxiBookingNotSelectedState(taxisAvailable: taxis));
      return;
    }

    if (currentState is PaymentNotInitializedState) {
      emit(TaxiNotSelectedState(
          booking: currentState.booking,
          typeOfAmbulanceList: currentState.typeOfAmbulanceList));
      return;
    }

    if (currentState is TaxiNotSelectedState) {
      emit(DetailsNotFilledState(booking: currentState.booking));
    }
    if (currentState is ShowRideCancelWidgetState) {
      emit(DetailsNotFilledState(booking: currentState.booking));
    }
  }

  Future<void> confirmBooking(TaxiBooking booking, TaxiDriver driver) async {
    try {
      final locationService = LocationService();
      Map<String, dynamic> directions;
      if (driver.isRideStarted && driver.RideStatus_Id != '4') {
        directions = await locationService.getDirections(
          booking.source,
          driver.driverLocation!,
        );
      } else {
        directions = await locationService.getDirections(
          booking.source,
          booking.destination,
        );
      }
      final updatedBooking = await booking.copyWith(
          distance: directions['distance'],
          expectedTime: directions['duration'],
          polyline: directions['polylinePoints']);
      emit(TaxiBookingConfirmedState(
        booking: updatedBooking,
        driver: driver,
      ));
    } catch (e) {
      e.toString();
    }
  }

  Future<void> confirmBookingRide(
      TaxiBooking booking, TaxiDriver driver) async {
    try {
      final locationService = LocationService();
      Map<String, dynamic> directions;
      if (driver.isRideStarted && driver.RideStatus_Id != '4') {
        directions = await locationService.getDirections(
          booking.source,
          driver.driverLocation!,
        );
      } else {
        directions = await locationService.getDirections(
          booking.source,
          booking.destination,
        );
      }
      final updatedBooking = await booking.copyWith(
          distance: directions['distance'],
          expectedTime: directions['duration'],
          polyline: directions['polylinePoints']);
      emit(TaxiRideStartedState(
        booking: updatedBooking,
        driver: driver,
      ));
    } catch (e) {
      e.toString();
// emit(TaxiBookingErrorState(message: e.toString()));
    }
  }

  Future<List<TypeOfAmbulance>> getAvailableAmbulanceTypes() async {
    List<TypeOfAmbulance> allTypes = await _fetchTaxi();
    List<Taxi> taxis = (await Taxistorage.getTaxis()) ?? [];
    if (taxis.isEmpty || allTypes.isEmpty) {
      return [];
    }
    final Set<String> availableTypeIds =
        taxis.map((e) => e.AmbulanceType_Id).toSet();
    final List<TypeOfAmbulance> availableTypes = allTypes
        .where((type) => availableTypeIds.contains(type.AM_TypeId))
        .toList();
    return availableTypes;
  }

  Future<List<TypeOfAmbulance>> _fetchTaxi() async {
    List<TypeOfAmbulance> lstTypeofAmbulance = [];
    try {
      final BaseApiService baseApiService = NetworkApiService();
      final Map<String, dynamic> queryParams = {
        'mode': "GetMasterData",
      };
      dynamic response =
          await baseApiService.getGetApiResponseObject('Masters', queryParams);
      if (response != null) {
        MasterDataEntity masterDataEntity = MasterDataEntity.fromMap(response);
        if (masterDataEntity.lstTypeofAmbulance.isNotEmpty) {
          lstTypeofAmbulance = masterDataEntity.lstTypeofAmbulance;
        }
      }
      return lstTypeofAmbulance;
    } catch (e) {
      return lstTypeofAmbulance;
    }
  }

  Future<List<PaymentMethod>> _fetchPaymentMethod() async {
    List<PaymentMethod> masterDataEntity = [];
    try {
      final BaseApiService baseApiService = NetworkApiService();
      final Map<String, dynamic> queryParams = {
        'mode': "GetPaymentMethodMaster",
      };
      dynamic response =
          await baseApiService.getGetApiResponseObject('Masters', queryParams);
      if (response != null && response is List) {
        masterDataEntity =
            response.map((item) => PaymentMethod.fromMap(item)).toList();
      }
      return masterDataEntity;
    } catch (e) {
      return masterDataEntity;
    }
  }

  void _onDriverNotAvailable(data) async {
    await HiveStorage.init();
    await HiveStorage.remove(SharePreferencesKeys.TAXI_BOOKING);
    add(NoDriverAvailableEvent(noDriverAvailable: data['data']));
  }

  void _onShowRideCancelWidgetEvent(
    ShowRideCancelWidgetEvent event,
    Emitter<TaxiBookingState> emit,
  ) {
    emit(ShowRideCancelWidgetState(
        driver: event.driver, booking: event.booking));
  }

  Future<void> _onUpdateDriverLocationEvent(
    UpdateDriverLocationEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    /// Allow only passenger active ride states
    if (state is! TaxiBookingConfirmedState && state is! TaxiRideStartedState) {
      return;
    }

    /// ===============================
    /// 📍 BOOKING CONFIRMED
    /// ===============================
    if (state is TaxiBookingConfirmedState) {
      final current = state as TaxiBookingConfirmedState;
      await _handlePassengerRouteUpdate(
        current: current,
        emit: emit,
        event: event,
      );
      return;
    }

    /// ===============================
    /// 🚖 RIDE STARTED
    /// ===============================
    if (state is TaxiRideStartedState) {
      final current = state as TaxiRideStartedState;
      await _handlePassengerRouteUpdate(
        current: current,
        emit: emit,
        event: event,
      );
      return;
    }
  }

  Future<void> _handlePassengerRouteUpdate({
    required TaxiBookingState current,
    required Emitter<TaxiBookingState> emit,
    required UpdateDriverLocationEvent event,
  }) async {
    final driverLocation = event.location.position;

    late TaxiBooking booking;
    late TaxiDriver driver;

    if (current is TaxiBookingConfirmedState) {
      booking = current.booking;
      driver = current.driver;
    } else if (current is TaxiRideStartedState) {
      booking = current.booking;
      driver = current.driver;
    } else {
      return;
    }

    final updatedDriver = driver.copyWith(driverLocation: event.location);

    final List<LatLng> currentPolyline =
        List<LatLng>.from(booking.polyline ?? []);

    final bool isOffRoute = _isDriverOffRoute(driverLocation, currentPolyline);

    /// ============================
    /// 🚗 DRIVER ON ROUTE
    /// ============================
    if (!isOffRoute) {
      if (current is TaxiBookingConfirmedState) {
        emit(
          TaxiBookingConfirmedState(
            booking: booking,
            driver: updatedDriver,
          ),
        );
      } else if (current is TaxiRideStartedState) {
        emit(
          TaxiRideStartedState(
            booking: booking,
            driver: updatedDriver,
          ),
        );
      }
      return;
    }

    /// ============================
    /// 🚨 DRIVER OFF ROUTE
    /// ============================
    try {
      final locationService = LocationService();

      final directions = await locationService.getDirections(
        event.location,
        booking.destination,
      );

      final updatedBooking = await booking.copyWith(
        distance: directions['distance'],
        expectedTime: directions['duration'],
        polyline: directions['polylinePoints'],
      );

      if (current is TaxiBookingConfirmedState) {
        emit(
          TaxiBookingConfirmedState(
            booking: updatedBooking,
            driver: updatedDriver,
          ),
        );
      } else if (current is TaxiRideStartedState) {
        emit(
          TaxiRideStartedState(
            booking: updatedBooking,
            driver: updatedDriver,
          ),
        );
      }
    } catch (e) {
      debugPrint("⚠️ Passenger route recalculation failed: $e");
    }
  }

  void _onFetchTaxiEvent(
    FetchTaxiEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    final List<TypeOfAmbulance> typeOfAmbulanceList =
        await getAvailableAmbulanceTypes();
    emit(FetchTaxiTypeState(typeOfAmbulanceList: typeOfAmbulanceList));
  }

  void _onTaxiRideAcceptedEvent(
    TaxiRideAcceptedEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    TaxiDriver updatedDriver = event.driver.copyWith(
      driverAccepted: true,
      isRideStarted: true,
    );
    await TaxiDriverStorage.saveDriver(updatedDriver);
    List<LatLng> updatedPolyline =
        List<LatLng>.from(event.booking.polyline ?? []);
    updatedPolyline.add(updatedDriver.driverLocation?.position ??
        event.booking.source.position);
    TaxiBooking updatedBooking = await event.booking.copyWith(
      polyline: updatedPolyline,
    );
    confirmBooking(updatedBooking, updatedDriver);
  }

  void _onTaxiRideArrivedEvent(
    TaxiRideArrivedEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    TaxiDriver currentDriver = event.driver;
    List<LatLng> updatedPolyline =
        List<LatLng>.from(event.booking.polyline ?? []);
    updatedPolyline.add(currentDriver.driverLocation?.position ??
        event.booking.source.position);
    TaxiBooking updatedBooking = await event.booking.copyWith(
      polyline: updatedPolyline,
    );
    confirmBooking(updatedBooking, currentDriver);
  }

  void _onStartRideEvent(
    StartRideEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    TaxiDriver? currentDriver = event.driver;
    List<LatLng> updatedPolyline =
        List<LatLng>.from(event.booking.polyline ?? []);
    updatedPolyline.add(currentDriver.driverLocation?.position ??
        event.booking.source.position);
    TaxiBooking updatedBooking = await event.booking.copyWith(
      polyline: updatedPolyline,
    );
    confirmBookingRide(updatedBooking, currentDriver);
    //todo after after demo
    emit(TaxiRideStartedState(booking: event.booking, driver: event.driver));
  }

  void _onCompleteRideEvent(
    CompleteRideEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    PaymentDetails? paymentDetails = event.paymentDetails;

    emit(CompleteRideState(
        booking: event.booking, paymentDetails: paymentDetails));
  }

/* TODO RATING */
  Future<void> _onSubmitRating(
    SubmitRatingEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    //  emit(RatingSubmitting());
    try {
      await Future.delayed(const Duration(seconds: 1));
      final Map<String, dynamic> queryParams = {
        'mode': 'SaveRatings',
        'SA10_UserType': '4',
      };

      final response = await _apiService.postApiResponse(
        "AmbulanceTracking",
        queryParams,
        jsonEncode(event.rating.toMap()),
      );

      if (response != null) {
        emit(RatingSuccess("Rating submitted successfully"));
      } else {
        emit(RatingFailure("No response from server"));
        GlobalClass.fetchToastPosition("No response from server");
      }
    } catch (e, stackTrace) {
      print("Error submitting rating: $e");
      print(stackTrace);
      emit(RatingFailure("Failed to submit rating"));
      GlobalClass.fetchToastPosition("Something went wrong");
    }
  }

  Future<void> _onConnectWebSocketEvent(
      ConnectWebSocketEvent event, Emitter<TaxiBookingState> emit) async {
    _webSocketService?.connect();
  }

  Future<void> _onDisconnectWebSocketEvent(
      DisconnectWebSocketEvent event, Emitter<TaxiBookingState> emit) async {
    _webSocketService?.closeConnection();
  }

  Future<void> _onRideCancellationApiEvent(
      RideCancellationApiEvent event, Emitter<TaxiBookingState> emit) async {
    final RideCancellationReason cancellationReason = event.cancellationReason;
    if (state is ShowRideCancelWidgetState) {
      _rideCancellationEvent(cancellationReason);
    }
  }

  Future<void> _onRideCancelledByDriverEvent(
      RideCancelledByDriverEvent event, Emitter<TaxiBookingState> emit) async {
    add(TaxiBookingCancelEvent());
  }

  Future<void> _onNoDriverAvailableEvent(
      NoDriverAvailableEvent event, Emitter<TaxiBookingState> emit) async {
    emit(NoDriverAvailableState(noDriverAvailable: event.noDriverAvailable));
  }
}
