import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolmanagementsystem/bloc/taxi_booking_event.dart';

import '../bloc/taxi_booking_bloc.dart';
import '../bloc/taxi_booking_state.dart';
import '../models/taxi_booking.dart';
import '../models/taxi_driver.dart';

class TaxiSearchingDriverWidget extends StatefulWidget {
  final ScrollController? controller;

  const TaxiSearchingDriverWidget({Key? key, this.controller})
      : super(key: key);

  @override
  State<TaxiSearchingDriverWidget> createState() =>
      _TaxiSearchingDriverWidgetState();
}

class _TaxiSearchingDriverWidgetState extends State<TaxiSearchingDriverWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late TaxiBooking booking;
  late TaxiDriver driver;

  @override
  void initState() {
    super.initState();

    final state = context.read<TaxiBookingBloc>().state as TaxiSearchingState;
    booking = state.booking;

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        height: height * 0.85,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            /// ================= HEADER =================
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Finding nearby drivers",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            /// ================= TRIP DETAILS =================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildTripCard(context),
            ),

            /// ================= SEARCHING ANIMATION =================
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      RotationTransition(
                        turns: _rotationController,
                        child: Container(
                          height: 72,
                          width: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.green, width: 3),
                          ),
                        ),
                      ),
                      RotationTransition(
                        turns: Tween<double>(begin: 1, end: 0)
                            .animate(_rotationController),
                        child: Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.green.withOpacity(0.4),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.directions_car,
                        size: 30,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Hang tight, we're connecting you",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// ================= CANCEL BUTTON =================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                height: 46,
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<TaxiBookingBloc>().add(
                          ShowRideCancelWidgetEvent(
                            booking: booking,
                            driver: driver, // logic untouched
                          ),
                        );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Cancel Ride",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= TRIP CARD =================
  Widget _buildTripCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Trip details",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 12),
          _locationRow(
            title: "Pickup",
            address: booking.source.areaDetails,
            color: Colors.green,
          ),
          const SizedBox(height: 10),
          _locationRow(
            title: "Drop",
            address: booking.destination.areaDetails,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _locationRow({
    required String title,
    required String address,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }
}
