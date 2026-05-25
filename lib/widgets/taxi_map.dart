import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../bloc/taxi_booking_bloc.dart';
import '../bloc/taxi_booking_event.dart';
import '../bloc/taxi_booking_state.dart';
import '../controllers/location_controller.dart';
import '../models/google_location.dart';
import '../models/taxi.dart';
import '../models/taxi_booking.dart';
import '../models/taxi_driver.dart';

class TaxiMap extends StatefulWidget {
  @override
  _TaxiMapState createState() => _TaxiMapState();
}

class _TaxiMapState extends State<TaxiMap> {
  GoogleMapController? controller;
  Set<Marker> markers = Set<Marker>();
  Set<Polyline> polylines = Set<Polyline>();
  Set<Circle> circles = Set<Circle>();
  GoogleLocation? currentLocation;
  Timer? _taxiRefreshTimer;
  TaxiDriver? driver;
  BitmapDescriptor? _ambulanceIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    _startTaxiRefresh();
  }

  void _startTaxiRefresh() {
    _taxiRefreshTimer?.cancel();
    _taxiRefreshTimer = Timer.periodic(
      const Duration(seconds: 10), // change to seconds for testing
      (_) async {
        if (!mounted) return;
        if (currentLocation != null) {
          context.read<TaxiBookingBloc>().add(
                TaxiBookingStartEvent(
                  position: currentLocation!.position,
                ),
              );
        }
      },
    );
  }

  Future<void> _loadCustomMarker() async {
    _ambulanceIcon =
        await _getCustomMarker('assets/images/embulance_icon.png', 48);
    setState(() {}); // Refresh the map with marker
  }

  Future<BitmapDescriptor> _getCustomMarker(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? byteData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List resizedData = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedData);
  }

  Circle createCircle(Color color, LatLng position) {
    return Circle(
      circleId: CircleId(position.toString()),
      fillColor: color,
      strokeColor: color.withOpacity(0.4),
      center: position,
      strokeWidth: 75,
      radius: 32.0,
      visible: true,
    );
  }

  Future<void> clearData() async {
    markers.clear();
    polylines.clear();
    circles.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TaxiBookingBloc, TaxiBookingState>(
        listener: (context, state) async {
          if (state is TaxiBookingNotSelectedState) {
            List<Taxi> taxis = state.taxisAvailable;
            await clearData();
            await addTaxis(taxis);
          }
          if (state is TaxiNotSelectedState) {
            clearData();
            TaxiBooking? booking = state.booking;
            markers.clear();
            polylines.clear();
            addPickupMarker(booking!);
            addDropMarker(booking!);
            if (booking.polyline != null && booking.polyline!.isNotEmpty) {
              final polylinePoints = List<LatLng>.from(booking.polyline!);
              polylines.add(Polyline(
                polylineId: PolylineId("route"),
                points: polylinePoints,
                color: Colors.black,
                width: 3,
                geodesic: true,
              ));
              _fitCameraToBounds(polylinePoints);
            } else {
              controller?.animateCamera(
                  CameraUpdate.newLatLngZoom(booking.source.position, 14));
            }
            // Add markers for start and end locations
            markers.add(Marker(
              markerId: MarkerId("start"),
              position: booking.source.position,
              infoWindow: InfoWindow(title: 'Source Location'),
              icon: BitmapDescriptor.defaultMarker,
            ));
            markers.add(Marker(
              markerId: MarkerId("end"),
              position: booking.destination?.position ?? LatLng(0, 0),
              infoWindow: InfoWindow(title: 'Destination Location'),
              icon: _ambulanceIcon!,
            ));
            _updatePolylineNotBooked(booking);
            setState(() {});
          } else if (state is TaxiRideStartedState) {
            clearData();
            TaxiBooking booking = state.booking;
            TaxiDriver taxiDriver = state.driver;
            driver = taxiDriver;
            markers.clear();
            polylines.clear();

            // If the ride hasn't started, add markers
            if (taxiDriver.isRideStarted && taxiDriver.RideStatus_Id == '4') {
              addPickupMarker(booking);
              addDropMarker(booking);

              if (taxiDriver.driverLocation != null) {
                addDriverMarker(taxiDriver.driverLocation!);
              }
              if (booking.polyline != null && booking.polyline!.isNotEmpty) {
                final polylinePoints = List<LatLng>.from(booking.polyline!);
                polylines.add(Polyline(
                  polylineId: PolylineId("route"),
                  points: polylinePoints,
                  color: Colors.black,
                  width: 3,
                  geodesic: true,
                ));
                _fitCameraToBounds(polylinePoints);
              } else {
                controller?.animateCamera(
                    CameraUpdate.newLatLngZoom(booking.source.position, 14));
              }
            }

            // Add markers for the driver's location if the ride has started
            if (taxiDriver.isRideStarted &&
                taxiDriver.driverLocation != null &&
                taxiDriver.RideStatus_Id != '4') {
              markers.add(Marker(
                markerId: MarkerId("start"),
                position: booking.source.position,
                infoWindow: InfoWindow(title: 'Sources Location'),
                icon: BitmapDescriptor.defaultMarker,
              ));
              markers.add(Marker(
                markerId: MarkerId("end"),
                position: taxiDriver.driverLocation!.position,
                infoWindow: InfoWindow(title: 'Driver Location'),
                icon: _ambulanceIcon!,
              ));
              _updatePolyline(booking, taxiDriver);
            }
            setState(() {});
          }
          /*if (state is TaxiBookingConfirmedState) {
            clearData();
            TaxiBooking booking = state.booking;
            TaxiDriver taxiDriver = state.driver;
            driver = taxiDriver;
            markers.clear();
            polylines.clear();

            // If the ride hasn't started, add markers
            if (taxiDriver.isRideStarted && taxiDriver.RideStatus_Id == '4') {
              addPickupMarker(booking);
              addDropMarker(booking);

              if (taxiDriver.driverLocation != null) {
                addDriverMarker(taxiDriver.driverLocation!);
              }
              if (booking.polyline != null && booking.polyline!.isNotEmpty) {
                final polylinePoints = List<LatLng>.from(booking.polyline!);
                polylines.add(Polyline(
                  polylineId: PolylineId("route"),
                  points: polylinePoints,
                  color: Colors.black,
                  width: 3,
                  geodesic: true,
                ));
                _fitCameraToBounds(polylinePoints);
              } else {
                controller?.animateCamera(
                    CameraUpdate.newLatLngZoom(booking.source.position, 14));
              }
            }

            // Add markers for the driver's location if the ride has started
            if (taxiDriver.isRideStarted &&
                taxiDriver.driverLocation != null &&
                taxiDriver.RideStatus_Id != '4') {
              markers.add(Marker(
                markerId: MarkerId("start"),
                position: booking.source.position,
                infoWindow: InfoWindow(title: 'Sources Location'),
                icon: BitmapDescriptor.defaultMarker,
              ));
              markers.add(Marker(
                markerId: MarkerId("end"),
                position: taxiDriver.driverLocation!.position,
                infoWindow: InfoWindow(title: 'Driver Location'),
                icon: _ambulanceIcon!,
              ));
              _updatePolyline(booking, taxiDriver);
            }

            setState(() {});
          }*/

          if (state is TaxiBookingConfirmedState) {
            final booking = state.booking;
            final taxiDriver = state.driver;

            driver = taxiDriver;

            // --- Clear only once when booking changes ---
            markers.clear();
            polylines.clear();

            // -------------------------------
            // COMMON MARKERS
            // -------------------------------
            addPickupMarker(booking);
            addDropMarker(booking);

            if (taxiDriver.driverLocation != null) {
              addDriverMarker(taxiDriver.driverLocation!);
            }

            // -------------------------------
            // DRAW POLYLINE (ONLY FROM BOOKING)
            // -------------------------------
            if (booking.polyline != null && booking.polyline!.isNotEmpty) {
              final polylinePoints = List<LatLng>.from(booking.polyline!);

              polylines.add(
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylinePoints,
                  color: Colors.black,
                  width: 4,
                  geodesic: true,
                ),
              );
              _fitCameraToBounds(polylinePoints);
            } else {
              controller?.animateCamera(
                CameraUpdate.newLatLngZoom(booking.source.position, 14),
              );
            }

            // -------------------------------
            // DRIVER → PICKUP
            // -------------------------------
            if (!taxiDriver.isRideStarted
                && taxiDriver.RideStatus_Id == '4') {
              if (taxiDriver.driverLocation != null) {
                _updateDriverMarker(taxiDriver.driverLocation!);
              }
            }

            // -------------------------------
            // PICKUP → DROP (RIDE STARTED)
            // -------------------------------
            if (taxiDriver.isRideStarted &&
                taxiDriver.driverLocation != null &&
                taxiDriver.RideStatus_Id != '4') {
              _updateDriverMarker(taxiDriver.driverLocation!);
            }

            setState(() {});
          } else if (state is TaxiNotConfirmedState) {
            await clearData();
            TaxiBooking booking = state.booking;
            //addPolylines(booking.source.position, booking.destination.position);
          } else if (state is CompleteRideState) {
            await clearData();
            TaxiBooking booking = state.booking;
            GoogleLocation? currentLocation =
                await LocationController.getCurrentLocationNew();
            markers.add(Marker(
              markerId: MarkerId("passenger"),
              position: currentLocation.position,
              infoWindow: InfoWindow(title: 'Your Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
            ));
          }
          setState(() {});
        },
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(17.0, 24.0), zoom: 8.0),
              onMapCreated: (controller) async {
                this.controller = controller;
                currentLocation =
                    await LocationController.getCurrentLocationNew();
                controller.animateCamera(
                    CameraUpdate.newLatLngZoom(currentLocation!.position, 12));
                //TODO FETCH TAXI FROM API..
                BlocProvider.of<TaxiBookingBloc>(context).add(
                    TaxiBookingStartEvent(position: currentLocation!.position));
              },
              myLocationButtonEnabled: true,
              markers: markers,
              polylines: polylines,
              circles: circles,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
            ),
            // Buttons column
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                // Right side, vertically centered
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      heroTag: 'zoomIn',
                      mini: true,
                      child: Icon(Icons.add),
                      tooltip: 'Zoom In',
                      onPressed: _zoomIn,
                    ),
                    SizedBox(height: 10),
                    FloatingActionButton(
                      heroTag: 'zoomOut',
                      mini: true,
                      child: Icon(Icons.remove),
                      tooltip: 'Zoom Out',
                      onPressed: _zoomOut,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateDriverMarker(GoogleLocation location) {
    markers.removeWhere((m) => m.markerId.value == 'driver');
    markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: location.position,
        icon: _ambulanceIcon!,
        infoWindow: const InfoWindow(title: 'Driver'),
      ),
    );
  }

  void addPickupMarker(TaxiBooking booking) {
    markers.add(
      Marker(
        markerId: MarkerId("start"),
        position: booking.source.position,
        infoWindow: InfoWindow(title: "Sources Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
  }

  void addDropMarker(TaxiBooking booking) {
    markers.add(
      Marker(
        markerId: MarkerId("end"),
        position: booking.destination.position,
        infoWindow: InfoWindow(title: "Destination Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  void addDriverMarker(GoogleLocation driverLocation) {
    markers.add(
      Marker(
        markerId: MarkerId("driver"),
        position: driverLocation.position,
        icon: _ambulanceIcon ?? BitmapDescriptor.defaultMarker,
        // custom ambulance icon
        infoWindow: InfoWindow(title: "Driver"),
      ),
    );
    controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: driverLocation.position),
      ),
    );
  }

  void _zoomIn() {
    if (controller != null) {
      controller!.getZoomLevel().then((zoom) {
        double newZoom = (zoom + 1).clamp(0.0, 20.0);
        controller!.animateCamera(CameraUpdate.zoomTo(newZoom));
      });
    }
  }

  void _zoomOut() {
    if (controller != null) {
      controller!.getZoomLevel().then((zoom) {
        double newZoom = (zoom - 1).clamp(0.0, 20.0);
        controller!.animateCamera(CameraUpdate.zoomTo(newZoom));
      });
    }
  }

  Future addTaxis(List<Taxi> taxis) async {
    GoogleLocation currentPositon =
        await LocationController.getCurrentLocationNew();
    circles.add(createCircle(Colors.blueAccent, currentPositon.position));
    if (controller == null) return;
    controller!.moveCamera(CameraUpdate.newLatLng(currentPositon.position));
    markers.clear();

    await Future.wait(taxis.map((taxi) async {
      final Uint8List markerIcon =
          await getBytesFromAsset("images/taxi_marker.png", 100);
      BitmapDescriptor descriptor = BitmapDescriptor.fromBytes(markerIcon);
      markers.add(Marker(
        markerId: MarkerId("${taxi.id}"),
        position: LatLng(taxi.position.latitude, taxi.position.longitude),
        infoWindow: InfoWindow(
          title: taxi.title,
        ),
        icon: descriptor,
      ));
    }));
    setState(() {});
  }

  Future<Marker> createMarker(
      Color color, LatLng position, String title) async {
    final Uint8List markerIcon =
        await getBytesFromAsset("images/location.png", 100);
    BitmapDescriptor descriptor = BitmapDescriptor.fromBytes(markerIcon);
    return Marker(
      markerId: MarkerId("${position.toString()}"),
      position: position,
      infoWindow: InfoWindow(
        title: title,
      ),
      icon: descriptor,
    );
  }

  void _updatePolyline(TaxiBooking booking, TaxiDriver taxiDriver) async {
    List<LatLng> polylinePoints = List<LatLng>.from(booking.polyline!);
    polylinePoints.add(taxiDriver.driverLocation!.position);
    polylines.add(Polyline(
      polylineId: PolylineId("route"),
      points: polylinePoints,
      color: Colors.black,
      width: 3,
      geodesic: true,
    ));

    _fitCameraToBounds(polylinePoints);
  }

  void _updatePolylineNotBooked(TaxiBooking booking) async {
    List<LatLng> polylinePoints = List<LatLng>.from(booking.polyline!);
    polylinePoints.add(booking.destination!.position);
    polylines.add(Polyline(
      polylineId: PolylineId("route"),
      points: polylinePoints,
      color: Colors.black,
      width: 3,
      geodesic: true,
    ));

    _fitCameraToBounds(polylinePoints);
  }

  void _fitCameraToBounds(List<LatLng> polylinePoints) {
    double minLat = polylinePoints.first.latitude;
    double maxLat = polylinePoints.first.latitude;
    double minLng = polylinePoints.first.longitude;
    double maxLng = polylinePoints.first.longitude;

    for (var point in polylinePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    controller?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void dispose() {
    _taxiRefreshTimer?.cancel();
    controller?.dispose();
    super.dispose();
  }
}
