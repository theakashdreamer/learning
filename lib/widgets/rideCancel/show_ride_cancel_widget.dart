import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolmanagementsystem/models/ride_cancellation_reason.dart';
import 'package:schoolmanagementsystem/models/taxi_booking.dart';
import 'package:schoolmanagementsystem/models/taxi_driver.dart';

import '../../bloc/taxi_booking_bloc.dart';
import '../../bloc/taxi_booking_event.dart';
import '../../bloc/taxi_booking_state.dart';
import '../../storage/ride_cancellation_reason_storage.dart';

class ShowRideCancelWidget extends StatefulWidget {
  const ShowRideCancelWidget({super.key});

  @override
  State<ShowRideCancelWidget> createState() => _ShowRideCancelWidgetState();
}

class _ShowRideCancelWidgetState extends State<ShowRideCancelWidget> {
  RideCancellationReason? _selectedReason;
  List<RideCancellationReason> _cancellationReasons = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _customReasonController = TextEditingController();

  late TaxiDriver driver;
  late TaxiBooking booking;

  @override
  void initState() {
    super.initState();
    _loadCancellationReasons();
    final state = BlocProvider.of<TaxiBookingBloc>(context).state;
    if (state is ShowRideCancelWidgetState) {
      booking = state.booking;
      driver = state.driver;
    }
  }

  Future<void> _loadCancellationReasons() async {
    try {
      final reasons =
          await RideCancellationReasonStorage.getRideCancellationReason();
      setState(() {
        _cancellationReasons = reasons ?? [];
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _errorMessage = "Failed to load reasons";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _customReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔴 REQUIRED
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<TaxiBookingBloc>().add(BackPressedEvent());
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Cancel Ride",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "Select a reason for cancellation",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // ================= CONTENT =================
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: _buildContent(theme),
          ),

          // ================= CTA =================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canSubmit() ? _cancelRide : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canSubmit() ? Colors.red : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel Ride",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._cancellationReasons.map(
          (reason) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildReasonCard(
              context: context,
              reason: reason,
              isSelected: _selectedReason == reason,
              onTap: () {
                setState(() {
                  _selectedReason = _selectedReason == reason ? null : reason;
                });
              },
            ),
          ),
        ),
        if (_selectedReason != null &&
            _selectedReason!.RideCancellationReason_Title
                .toLowerCase()
                .contains('other'))
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextField(
              controller: _customReasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Please specify your reason",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _canSubmit() {
    if (_selectedReason == null) return false;
    if (_selectedReason!.RideCancellationReason_Title
            .toLowerCase()
            .contains('other') &&
        _customReasonController.text.isEmpty) return false;
    return true;
  }

  void _cancelRide() {
    if (_selectedReason == null) return;
    context.read<TaxiBookingBloc>().add(
      RideCancellationApiEvent(
              cancellationReason: _selectedReason!,
              taxiBooking: booking),
        );
  }

  Widget _buildReasonCard({
    required BuildContext context,
    required RideCancellationReason reason,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ICON
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getReasonIcon(reason.RideCancellationReason_Id),
                size: 22,
                color: Colors.black87,
              ),
            ),

            const SizedBox(width: 14),

            // TEXT
            Expanded(
              child: Text(
                reason.RideCancellationReason_Title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // CHECK INDICATOR
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.black : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getReasonIcon(int reasonId) {
    switch (reasonId) {
      case 1:
        return Icons.schedule_outlined; // Change of plans
      case 2:
        return Icons.directions_car_outlined; // Found other transport
      case 3:
        return Icons.attach_money_outlined; // Fare too high
      case 4:
        return Icons.person_off_outlined; // Driver issue
      case 5:
        return Icons.cloud_outlined; // Weather
      case 6:
        return Icons.emergency_outlined; // Emergency
      case 7:
        return Icons.safety_check_outlined; // Safety concern
      case 8:
        return Icons.event_busy_outlined; // Schedule conflict
      case 9:
        return Icons.more_horiz_outlined; // Other
      default:
        return Icons.help_outline_outlined;
    }
  }
}
