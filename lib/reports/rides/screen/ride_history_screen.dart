import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:schoolmanagementsystem/reports/rides/screen/widgets/empty_state_widget.dart';
import 'package:schoolmanagementsystem/reports/rides/screen/widgets/filter_bottom_sheet.dart';
import 'package:schoolmanagementsystem/reports/rides/screen/widgets/ride_card.dart';

import '../bloc/ride_history_bloc.dart';
import '../bloc/ride_history_event.dart';
import '../bloc/ride_history_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ride_history_bloc.dart';
import '../bloc/ride_history_event.dart';
import '../bloc/ride_history_state.dart';
import '../model/get_all_rides_for_driver_and_passenger.dart';
import '../model/ride_model.dart';
class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History'),
        actions: [
          BlocBuilder<RideHistoryBloc, RideHistoryState>(
            builder: (context, state) {
              if (state is RideHistoryLoaded && state.hasActiveFilters) {
                return IconButton(
                  icon: Badge(
                    label: const Text('1'),
                    child: const Icon(Icons.filter_alt),
                  ),
                  onPressed: () => _showFilterBottomSheet(context, state),
                );
              }
              return IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                onPressed: () => _showFilterBottomSheet(context, state),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<RideHistoryBloc, RideHistoryState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is RideHistoryInitial) {
              context.read<RideHistoryBloc>().add(LoadRideHistory());
              return const Center(child: CircularProgressIndicator());
            }
        
            if (state is RideHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
        
            if (state is RideHistoryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<RideHistoryBloc>().add(LoadRideHistory());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
        
            if (state is RideHistoryLoaded) {
              final rides = state.filteredRides;
        
              if (rides.isEmpty) {
                return EmptyStateWidget(
                  hasFilters: state.hasActiveFilters,
                  onClearFilters: () {
                    context.read<RideHistoryBloc>().add(ClearFilters());
                  },
                );
              }
        
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<RideHistoryBloc>().add(LoadRideHistory());
                },
                child: Column(
                  children: [
                    if (state.hasActiveFilters) _buildActiveFilters(state),
                    Expanded(
                      child: ListView.builder(
                        itemCount: rides.length,
                        itemBuilder: (context, index) {
                          final ride = rides[index];
                          ride.Ride_Id= index+1;
                          return RideCard(
                            ride: ride,
                            onTap: () {
                              // Navigate to ride details
                              _showRideDetails(context, ride);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
        
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildActiveFilters(RideHistoryLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.orange.withOpacity(0.1),
      child: Row(
        children: [
          const Icon(Icons.filter_alt, size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _buildFilterText(state),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildFilterText(RideHistoryLoaded state) {
    List<String> filters = [];
    if (state.activeStatusFilter != null) {
      filters.add(_statusToString(state.activeStatusFilter!));
    }
    if (state.activeTypeFilter != null) {
      filters.add(_typeToString(state.activeTypeFilter!));
    }
    if (state.activeDateRange != null) {
      filters.add('Date Range');
    }
    return 'Active filters: ${filters.join(', ')}';
  }

  String _statusToString(RideStatus status) {
    switch (status) {
      case RideStatus.completed:
        return 'Completed';
      case RideStatus.cancelled:
        return 'Cancelled';
      case RideStatus.upcoming:
        return 'Upcoming';
    }
  }

  String _typeToString(RideType type) {
    switch (type) {
      case RideType.bike:
        return 'Bike';
      case RideType.auto:
        return 'Auto';
      case RideType.car:
        return 'Car';
    }
  }

  void _showFilterBottomSheet(
      BuildContext context,
      RideHistoryState state,
      ) {
    RideStatus? initialStatus;
    RideType? initialType;
    DateTimeRange? initialDateRange;

    if (state is RideHistoryLoaded) {
      initialStatus = state.activeStatusFilter;
      initialType = state.activeTypeFilter;
      initialDateRange = state.activeDateRange;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FilterBottomSheet(
          initialStatus: initialStatus,
          initialType: initialType,
          initialDateRange: initialDateRange,
          onApplyFilters: (status, type, dateRange) {
            context.read<RideHistoryBloc>().add(
              FilterRides(
                status: status,
                type: type,
                dateRange: dateRange,
              ),
            );
          },
        );
      },
    );
  }

  void _showRideDetails(
      BuildContext context,
      GetAllRidesForDriverAndPassenger ride,
      ) {
    final LatLng startLatLng = _latLng(ride.Start_Lat, ride.Start_Long);
    final LatLng endLatLng = _latLng(ride.End_Lat, ride.End_Long);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.92,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // Custom Handle with Gradient
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepOrangeAccent.withOpacity(0.8),
                          Colors.deepOrangeAccent.withOpacity(0.4),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      physics: const ClampingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ride Details',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.grey[900],
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'ID: ${ride.Ride_Id}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(ride.Status_Title)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _getStatusColor(ride.Status_Title)
                                          .withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    ride.Status_Title.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: _getStatusColor(ride.Status_Title),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Date Chip
                            Container(
                              margin: const EdgeInsets.only(top: 12, bottom: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDate(ride.Scheduled_Time),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Real Path Map with Polyline
                            StatefulBuilder(
                              builder: (context, setModalState) {
                                bool showRoute = false;
                                GoogleMapController? mapController;

                                void fitBounds() {
                                  final bounds = LatLngBounds(
                                    southwest: LatLng(
                                      math.min(startLatLng.latitude, endLatLng.latitude),
                                      math.min(startLatLng.longitude, endLatLng.longitude),
                                    ),
                                    northeast: LatLng(
                                      math.max(startLatLng.latitude, endLatLng.latitude),
                                      math.max(startLatLng.longitude, endLatLng.longitude),
                                    ),
                                  );
                                  mapController?.animateCamera(
                                    CameraUpdate.newLatLngBounds(bounds, 80),
                                  );
                                }

                                return Container(
                                  height: 220,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 25,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        GoogleMap(
                                          onMapCreated: (controller) {
                                            mapController = controller;
                                            Future.delayed(const Duration(milliseconds: 300), fitBounds);
                                          },

                                          initialCameraPosition: CameraPosition(
                                            target: startLatLng,
                                            zoom: 14,
                                          ),

                                          gestureRecognizers: {Factory<OneSequenceGestureRecognizer>(
                                                () => EagerGestureRecognizer(),
                                          ),
                                          },

                                          markers: {
                                            Marker(
                                              markerId: const MarkerId("start"),
                                              position: startLatLng,
                                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                                BitmapDescriptor.hueGreen,
                                              ),
                                            ),
                                            Marker(
                                              markerId: const MarkerId("end"),
                                              position: endLatLng,
                                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                                BitmapDescriptor.hueRed,
                                              ),
                                            ),
                                          },

                                          polylines: {
                                            Polyline(
                                              polylineId: const PolylineId("route"),
                                              color: Colors.deepOrangeAccent,
                                              width: 5,
                                              points: [startLatLng, endLatLng],
                                              geodesic: true,
                                            ),
                                          },

                                          circles: {
                                            Circle(
                                              circleId: const CircleId("start_circle"),
                                              center: startLatLng,
                                              radius: 80,
                                              fillColor: Colors.green.withOpacity(0.15),
                                              strokeColor: Colors.green,
                                              strokeWidth: 1,
                                            ),
                                            Circle(
                                              circleId: const CircleId("end_circle"),
                                              center: endLatLng,
                                              radius: 80,
                                              fillColor: Colors.red.withOpacity(0.15),
                                              strokeColor: Colors.red,
                                              strokeWidth: 1,
                                            ),
                                          },

                                          zoomControlsEnabled: false,
                                          myLocationButtonEnabled: false,
                                        ),

                                        /// ROUTE TOGGLE BUTTON
                                        Positioned(
                                          bottom: 12,
                                          right: 12,
                                          child: GestureDetector(
                                            onTap: () {
                                              setModalState(() => showRoute = !showRoute);
                                              fitBounds();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: showRoute
                                                    ? Colors.deepOrangeAccent
                                                    : Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.15),
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.route,
                                                    color: showRoute ? Colors.white : Colors.grey[800],
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    showRoute ? "Hide Route" : "Show Route",
                                                    style: TextStyle(
                                                      color: showRoute
                                                          ? Colors.white
                                                          : Colors.grey[800],
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Map Legend
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildLegendItem(
                                    color: Colors.green,
                                    label: 'Pickup',
                                  ),
                                  const SizedBox(width: 24),
                                  _buildLegendItem(
                                    color: Colors.deepOrangeAccent,
                                    label: 'Route',
                                  ),
                                  const SizedBox(width: 24),
                                  _buildLegendItem(
                                    color: Colors.red,
                                    label: 'Drop',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Details Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Location Row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildDetailCardWithIcon(
                                          icon: Icons.location_on_outlined,
                                          title: 'From',
                                          value: ride.Start_Location,
                                          iconColor: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildDetailCardWithIcon(
                                          icon: Icons.location_pin,
                                          title: 'To',
                                          value: ride.End_Location,
                                          iconColor: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Fare & Distance Row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildDetailCardWithIcon(
                                          icon: Icons.attach_money,
                                          title: 'Fare',
                                          value: '₹${ride.Fare}',
                                          iconColor: Colors.amber[700]!,
                                          isHighlighted: true,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildDetailCardWithIcon(
                                          icon: Icons.space_dashboard,
                                          title: 'Distance',
                                          value: ride.Distance,
                                          iconColor: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Payment & Driver Row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildDetailCardWithIcon(
                                          icon: Icons.credit_card,
                                          title: 'Payment',
                                          value: ride.Method_Name,
                                          iconColor: Colors.purple,
                                        ),
                                      ),
                                      if (ride.Passenger_Name.isNotEmpty) ...[
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildDetailCardWithIcon(
                                            icon: Icons.person,
                                            title: 'Passenger Name',
                                            value: ride.Passenger_Name,
                                            iconColor: Colors.deepOrange,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepOrangeAccent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 2,
                                      shadowColor:
                                      Colors.deepOrangeAccent.withOpacity(0.3),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.close, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'Close',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Footer Note
                            Center(
                              child: Text(
                                'Route shown is approximate',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }
  Widget _buildDetailCardWithIcon({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    bool isHighlighted = false,
  }) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[100]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
                      color: isHighlighted ? Colors.deepOrangeAccent : Colors.grey[900],
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  LatLng _latLng(String lat, String lng) {
    return LatLng(double.parse(lat), double.parse(lng));
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'cancelled':
        return const Color(0xFFEF4444);
      case 'upcoming':
        return const Color(0xFF3B82F6);
      case 'ongoing':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

}