import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/taxi_booking_bloc.dart';
import '../../bloc/taxi_booking_event.dart';
import '../../bloc/taxi_booking_state.dart';
import '../../models/taxi_booking.dart';
import '../../models/taxi_driver.dart';

class TaxiBookingStartWidget extends StatefulWidget {
  final ScrollController? controller;

  TaxiBookingStartWidget({this.controller});

  @override
  _TaxiBookingStartWidgetState createState() =>
      _TaxiBookingStartWidgetState();
}

class _TaxiBookingStartWidgetState extends State<TaxiBookingStartWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  TaxiDriver? driver = null;
  TaxiBooking? booking = null;

  @override
  void initState() {
    super.initState();
    final state = BlocProvider.of<TaxiBookingBloc>(context).state;
    if (state is TaxiRideStartedState) {
      booking = state.booking;
      driver = state.driver;
    }
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      curve: Curves.easeOut,
      parent: animationController,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          height: screenHeight * 0.8 * animation.value,
          child: child,
        );
      },
      child: Column(
        children: [
          // Header Section
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ride Started",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Your ride is now in progress",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[300],
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final phone = 'tel:${driver?.Mobile_No}';
                      if (await canLaunch(phone)) {
                        await launch(phone);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call,
                          color: Colors.white, size: 18),
                    ),
                  ),

                ],
              ),
            ),
          ),

          // Content Section
          Expanded(
            child: Container(
              color: Colors.black,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    controller: widget.controller,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Ride Details Section
                        _buildDetailCard(
                          context,
                          title: "Ride Details",
                          icon: Icons.directions_car_outlined,
                          children: [
                            // Trip Stats
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildRideStat(
                                    icon: Icons.timer_outlined,
                                    label: "Duration",
                                    value: booking?.expectedTime ?? "--",
                                  ),
                                  Container(
                                    width: 1,
                                    height: 25,
                                    color: Colors.grey[300],
                                  ),
                                  _buildRideStat(
                                    icon: Icons.currency_rupee_outlined,
                                    label: "Fare",
                                    value: "₹${booking?.estimatedPrice ?? "--"}",
                                  ),
                                  Container(
                                    width: 1,
                                    height: 25,
                                    color: Colors.grey[300],
                                  ),
                                  _buildRideStat(
                                    icon: Icons.people_outline,
                                    label: "Passengers",
                                    value: booking?.noOfPersons ?? "1",
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 8),

                            // Pickup Location
                            _buildLocationRow(
                              context,
                              icon: Icons.my_location_outlined,
                              iconColor: Colors.green[700],
                              backgroundColor: Colors.green[50],
                              title: "Pickup",
                              address: booking?.source.areaDetails ?? "Pickup location",
                            ),

                            SizedBox(height: 3),

                            // Destination
                            _buildLocationRow(
                              context,
                              icon: Icons.flag_outlined,
                              iconColor: Colors.red[700],
                              backgroundColor: Colors.red[50],
                              title: "Destination",
                              address: booking?.destination.areaDetails ?? "Drop location",
                            ),
                          ],
                        ),

                        SizedBox(height: 8),

                        // Driver Info Section
                        _buildDetailCard(
                          context,
                          title: "Driver Details",
                          icon: Icons.person_outline,
                          children: [
                            SizedBox(height: 8),
                            Row(
                              children: [
                                // Driver Avatar
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[700],
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      driver?.driverName?.substring(0, 1).toUpperCase() ?? 'D',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 7),

                                // Driver Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        driver?.driverName ?? 'Driver',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.directions_car_outlined,
                                            size: 12,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            driver?.taxiDetails?.AM_TypeName ?? 'Vehicle',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone_outlined,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            driver?.Mobile_No ?? 'No contact',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Rating
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: Colors.amber[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.amber[200]!),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.amber[700],
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        driver?.driverRating?.toStringAsFixed(1) ?? '0.0',
                                        style: TextStyle(
                                          color: Colors.amber[800],
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 2),


                        // Action Buttons
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber[200]!),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final phone = 'tel:${driver?.Mobile_No}';
                                  if (await canLaunch(phone)) {
                                    await launch(phone);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.green[700],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.call,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                              SizedBox(width: 20),
                              // Cancel Ride Button (Now shows emergency/safety options)
                              Container(
                                height: 50,
                                child: OutlinedButton.icon(
                                  onPressed: () => _showEmergencyOptions(context),
                                  icon: Icon(
                                    Icons.emergency_outlined,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    "Emergency / Cancel",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.red,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          "Emergency Options",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.emergency, color: Colors.red),
              title: const Text(
                "Emergency Call",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text("Call emergency services"),
              onTap: () {
                Navigator.pop(dialogContext); // ✅ close dialog
                _callEmergency();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.orange),
              title: const Text(
                "Cancel Ride",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text("Cancel current ride with penalty"),
              onTap: () {
                Navigator.pop(dialogContext); // ✅ close dialog
                context.read<TaxiBookingBloc>().add(
                  ShowRideCancelWidgetEvent(
                    driver: driver!,
                    booking: booking!,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _callEmergency() async {
    final emergencyNumber = 'tel:112'; // Change to your local emergency number
    if (await canLaunch(emergencyNumber)) {
      await launch(emergencyNumber);
    }
  }

  Widget _buildDetailCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required List<Widget> children,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Card Content
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRideStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: Colors.grey[600],
            ),
            SizedBox(width: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow(
      BuildContext context, {
        required IconData icon,
        required Color? iconColor,
        required Color? backgroundColor,
        required String title,
        required String address,
      }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: iconColor!.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: iconColor.withOpacity(0.2), width: 1.5),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 14,
                color: iconColor,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  address,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}