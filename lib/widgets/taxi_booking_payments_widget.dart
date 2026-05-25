import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/taxi_booking_bloc.dart';
import '../bloc/taxi_booking_event.dart';
import '../bloc/taxi_booking_state.dart';
import '../models/payment_method.dart';
import '../models/taxi_booking.dart';

class TaxiBookingPaymentsWidget extends StatefulWidget {
  @override
  _TaxiBookingPaymentsWidgetState createState() =>
      _TaxiBookingPaymentsWidgetState();
}

class _TaxiBookingPaymentsWidgetState extends State<TaxiBookingPaymentsWidget> {
  late List<PaymentMethod> methods;
  PaymentMethod? selectedMethod;
  TaxiBooking? booking;

  @override
  void initState() {
    super.initState();
    methods =
        (BlocProvider.of<TaxiBookingBloc>(context).state as PaymentNotInitializedState)
            .methodsAvaiable;
    booking =
        (BlocProvider.of<TaxiBookingBloc>(context).state as PaymentNotInitializedState)
            .booking;
    selectedMethod = methods.isNotEmpty ? methods[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final estimatedPrice = booking?.estimatedPrice ?? 0;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Header Section - Enhanced
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Title and Distance Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Choose payment",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Choose the most suitable option",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[300],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (estimatedPrice != null)
                          Container(
                            width: 80,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.grey[700]!, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "fare",
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "$estimatedPrice",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        /// PAYMENT METHODS
                        Container(
                          child: Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: methods.length,
                              itemBuilder: (context, index) {
                                final method = methods[index];
                                return _olaPaymentTile(method);
                              },
                            ),
                          ),
                        ),

                        /// BOTTOM ACTION
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.05),
                                blurRadius: 8,
                                offset: const Offset(0, -3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Back Button
                              Container(
                                width: 45,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<TaxiBookingBloc>(context)
                                        .add(BackPressedEvent());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: EdgeInsets.zero,
                                    elevation: 4,
                                    shadowColor: Colors.black.withOpacity(0.3),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              /// CONFIRM PAYMENT
                              Expanded(
                                child: SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      booking?.paymentMethod = selectedMethod!;
                                      BlocProvider.of<TaxiBookingBloc>(context).add(
                                        PaymentMadeEvent(booking: booking!),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      "Confirm & Pay",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
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

          ],
        ),
      ),
    );
  }


  Widget _olaPaymentTile(PaymentMethod method) {
    final bool isEnabled = method.id == "5";
    final bool isSelected = selectedMethod == method;

    return GestureDetector(
      onTap: isEnabled
          ? () {
        setState(() => selectedMethod = method);
      }
          : null, // ❌ disable tap
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.4, // greyed out
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            color: Colors.white,
          ),
          child: Row(
            children: [
              /// ICON
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[100],
                child: Icon(
                  _getMethodIcon(method.title),
                  color: _getMethodColor(method.title),
                  size: 18,
                ),
              ),
              const SizedBox(width: 18),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              /// RADIO
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildPaymentMethodCard(PaymentMethod method) {
    final bool isSelected = selectedMethod == method;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedMethod = method;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[50] : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.blue[300]! : Colors.grey[200]!,
              width: isSelected ? 2 : 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ]
                : [],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _getMethodIcon(method.title),
                    size: 12,
                    color: _getMethodColor(method.title),
                  ),
                ),
              ),

              SizedBox(width: 8),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      method.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Selection Indicator
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.green : Colors.grey[400]!,
                    width: 2.5,
                  ),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: isSelected ? 16 : 0,
                    height: isSelected ? 16 : 0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: isSelected
                        ? Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to get appropriate icon based on payment method
  IconData _getMethodIcon(String methodTitle) {
    final title = methodTitle.toLowerCase();
    if (title.contains('card') || title.contains('credit') || title.contains('debit')) {
      return Icons.credit_card_rounded;
    } else if (title.contains('cash')) {
      return Icons.money_rounded;
    } else if (title.contains('wallet')) {
      return Icons.account_balance_wallet_rounded;
    } else if (title.contains('upi') || title.contains('pay')) {
      return Icons.payment_rounded;
    } else if (title.contains('netbanking') || title.contains('bank')) {
      return Icons.account_balance_rounded;
    }
    return Icons.payments_rounded;
  }

  // Helper function to get color based on payment method
  Color _getMethodColor(String methodTitle) {
    final title = methodTitle.toLowerCase();
    if (title.contains('card')) return Colors.purple[700]!;
    if (title.contains('cash')) return Colors.green[700]!;
    if (title.contains('wallet')) return Colors.orange[700]!;
    if (title.contains('upi')) return Colors.blue[700]!;
    if (title.contains('netbanking')) return Colors.indigo[700]!;
    return Colors.black;
  }
}