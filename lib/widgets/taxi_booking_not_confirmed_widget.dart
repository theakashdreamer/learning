import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolmanagementsystem/widgets/taxi_booking_cancellation_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/taxi_booking_bloc.dart';
import '../bloc/taxi_booking_event.dart';
import '../bloc/taxi_booking_state.dart';
import '../data/storage/hive_storage.dart';
import '../loginModules/data/localStorage.dart';
import '../loginModules/data/sharePreferencesKeys.dart';
import '../loginModules/entity/UserDetails.dart';
import '../loginModules/res/appColors.dart';
import '../models/taxi_booking.dart';
import '../models/taxi_driver.dart';

class TaxiBookingNotConfirmedWidget extends StatefulWidget {
  final ScrollController? controller;

  TaxiBookingNotConfirmedWidget({this.controller});

  @override
  _TaxiBookingNotConfirmedWidgetState createState() =>
      _TaxiBookingNotConfirmedWidgetState();
}

class _TaxiBookingNotConfirmedWidgetState
    extends State<TaxiBookingNotConfirmedWidget>
    with TickerProviderStateMixin {

  late AnimationController animationController;
  late Animation<double> animation;

  TaxiBooking? booking;
  TaxiDriver? driver;
  String _otpRide = "";

  @override
  void initState() {
    super.initState();

    final state =
    BlocProvider.of<TaxiBookingBloc>(context).state as TaxiNotConfirmedState;
    booking = state.booking;
    driver = state.driver;

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
    });

    _initOtp();
  }

  Future<void> _initOtp() async {
    await HiveStorage.init();
    _otpRide = await HiveStorage.fetchString(HiveStorage.keyRideOtp) ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            height: screenHeight * 0.8 * animation.value,
            child: child,
          );
        },
        child: Container(
          child: Column(
            children: [
              /// ================= HEADER (FIXED / ALWAYS VISIBLE) =================
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  decoration: BoxDecoration(
                    color: Colors.black, // header background color
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// Drag Handle
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            // handle color visible on black
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Ride Status + Call
                      Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Ride confirmed",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color:
                                Colors.white, // text white for visibility
                              ),
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
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green[700],
                                // more contrast on black
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.call,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// OTP STRIP (OLA STYLE)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey[800], // dark strip on black
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_outline,
                                size: 18, color: Colors.white70),
                            const SizedBox(width: 10),
                            const Text(
                              "OTP",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _otpRide,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 6,
                                  color: Colors.white, // OTP value visible
                                ),
                              ),
                            ),
                            const Text(
                              "Share",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// ================= DRAGGABLE CONTENT =================
              Expanded(
                child: Container(
                  color: Colors.white, // header background color
                  child: SingleChildScrollView(
                    controller: widget.controller,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// LOCATIONS
                        _buildDetailCard(
                          context,
                          title: "Trip",
                          icon: Icons.location_on_outlined,
                          children: [
                            _buildLocationRow(
                              context: context,
                              icon: Icons.circle,
                              iconColor: Colors.green,
                              backgroundColor: Colors.green[50],
                              title: "Pickup",
                              address: booking?.source.areaDetails ?? "",
                            ),
                            const SizedBox(height: 6),
                            _buildLocationRow(
                              context: context,
                              icon: Icons.location_on,
                              iconColor: Colors.red,
                              backgroundColor: Colors.red[50],
                              title: "Drop",
                              address: booking?.destination.areaDetails ?? "",
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// DRIVER DETAILS
                        _buildDetailCard(
                          context,
                          title: "Driver",
                          icon: Icons.person_outline,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    driver?.driverName
                                        .substring(0, 1)
                                        .toUpperCase() ??
                                        "D",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        driver?.driverName ?? "Driver",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        driver?.taxiDetails?.AM_TypeName ??
                                            "Vehicle",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                _ratingChip(),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// RIDE STATS
                        _buildDetailCard(
                          context,
                          title: "Ride",
                          icon: Icons.directions_car_outlined,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildRideStat(
                                  icon: Icons.timer_outlined,
                                  label: "ETA",
                                  value: booking?.expectedTime ?? "--",
                                ),
                                _buildRideStat(
                                  icon: Icons.currency_rupee_outlined,
                                  label: "Fare",
                                  value: "₹${booking?.estimatedPrice ?? '--'}",
                                ),
                                _buildRideStat(
                                  icon: Icons.people_outline,
                                  label: "Seats",
                                  value: booking?.noOfPersons ?? "1",
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Call Driver Button (Black)
                            Expanded(
                              child: SizedBox(
                                height: 45, // fixed height
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final phoneNumber =
                                        'tel:${driver?.Mobile_No}';
                                    if (await canLaunch(phoneNumber)) {
                                      await launch(phoneNumber);
                                    } else {
                                      print('Could not launch $phoneNumber');
                                    }
                                  },
                                  icon:
                                  const Icon(Icons.call_outlined, size: 18),
                                  label: const Text(
                                    "Call Driver",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    // black button
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12), // space between buttons

                            // Cancel Ride Button (Red)
                            Expanded(
                              child: SizedBox(
                                height: 45, // fixed height
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    context.read<TaxiBookingBloc>().add(
                                      ShowRideCancelWidgetEvent(
                                          driver: driver!,
                                          booking: booking!),
                                    );
                                  },
                                  icon: const Icon(Icons.close,
                                      color: Colors.red),
                                  label: const Text(
                                    "Cancel Ride",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required List<Widget> children,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Header
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔹 Content
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _ratingChip({double rating = 0.0}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color? backgroundColor,
    required String title,
    required String address,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: iconColor.withOpacity(0.3), width: 1),
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
                size: 16,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
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
