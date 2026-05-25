import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schoolmanagementsystem/bloc/taxi_booking_bloc.dart';
import 'package:schoolmanagementsystem/bloc/taxi_booking_state.dart';


class Maindashboardscreen extends StatefulWidget {
  const Maindashboardscreen({super.key});
  @override
  _RideTrackingScreenState createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<Maindashboardscreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    // Start tracking
    WidgetsBinding.instance.addPostFrameCallback((_) {
    /*  context.read<TaxiBookingBloc>().add(StartRideTracking(widget.rideId));*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracking Ride'),
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () => _callDriver(context),
          ),
          IconButton(
            icon: Icon(Icons.sos),
            onPressed: () => _triggerSOS(context),
          ),
        ],
      ),
      body: BlocConsumer<TaxiBookingBloc, TaxiBookingState>(
        listener: (context, state) {
     /*     if (state is ) {
            _updateMap(state);
          }

          if (state is RideTrackingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }*/
        },
        builder: (context, state) {
     /*     if (state is RideTrackingLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is RideTrackingFailure) {
            return Center(child: Text('Failed to track ride'));
          }

          if (state is RideTrackingSuccess) {
            return _buildTrackingUI(context, state);
          }*/
          return _buildTrackingUI(context, state);
          return Center(child: Text('Waiting for ride to start...'));
        },
      ),
    );
  }

  Widget _buildTrackingUI(BuildContext context, TaxiBookingState state) {
    return Column(
      children: [
        // Map
        Expanded(
          flex: 2,
          child: GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                0.0,
                0.0,
              ),
              zoom: 15,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ),

        // Ride Details
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Driver Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,

                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                       'Driver',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text('${4.5}'),
                          SizedBox(width: 8),
                          Text('${ ''}'),
                          SizedBox(width: 8),
                          Text('${ ''}'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Ride Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatusChip(
                    icon: Icons.location_on,
                    label: _getStatusLabel("searching"),
                    color: _getStatusColor("searching"),
                  ),
                  _StatusChip(
                    icon: Icons.timer,
                    label: '${1 ?? 0} min',
                    color: Colors.blue,
                  ),
                  _StatusChip(
                    icon: Icons.currency_rupee,
                    label: '₹${1.56.toStringAsFixed(2)}',
                    color: Colors.green,
                  ),
                ],
              ),
              SizedBox(height: 16),

              // OTP (if driver has arrived)
              if ("arrived" == 'arrived')
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'OTP: ${7856 ?? '----'}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

              // Action Buttons
              SizedBox(height: 16),
              if ("searching" == 'searching' || "accepted" == 'accepted')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _cancelRide(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Cancel Ride'),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

/*  void _updateMap(RideTrackingSuccess state) {
    // Update driver marker
    if (state.driverLocation != null) {
      final driverMarker = Marker(
        markerId: MarkerId('driver'),
        position: LatLng(
          state.driverLocation!.latitude,
          state.driverLocation!.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        rotation: state.driverLocation?.bearing ?? 0,
        infoWindow: InfoWindow(title: 'Driver'),
      );

      _markers = {driverMarker};
    }

    // Update polyline if available
    if (state.route != null && state.route!.isNotEmpty) {
      final polyline = Polyline(
        polylineId: PolylineId('route'),
        color: Colors.blue,
        width: 4,
        points: state.route!.map((location) =>
            LatLng(location.latitude, location.longitude)
        ).toList(),
      );

      _polylines = {polyline};
    }

    // Move camera to show driver
    if (state.driverLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            state.driverLocation!.latitude,
            state.driverLocation!.longitude,
          ),
        ),
      );
    }
  }*/

  String _getStatusLabel(String status) {
    switch (status) {
      case 'searching': return 'Searching';
      case 'accepted': return 'Accepted';
      case 'arrived': return 'Arrived';
      case 'started': return 'On Trip';
      case 'completed': return 'Completed';
      case 'cancelled': return 'Cancelled';
      default: return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'searching': return Colors.orange;
      case 'accepted': return Colors.blue;
      case 'arrived': return Colors.green;
      case 'started': return Colors.purple;
      case 'completed': return Colors.grey;
      case 'cancelled': return Colors.red;
      default: return Colors.black;
    }
  }

  void _callDriver(BuildContext context) {
    // Implement call functionality
  }

  void _triggerSOS(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Emergency SOS'),
        content: Text('Are you sure you want to trigger emergency SOS?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Trigger SOS
              Navigator.pop(context);
            },
            child: Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _cancelRide(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Ride'),
        content: Text('Are you sure you want to cancel this ride?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {

              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
