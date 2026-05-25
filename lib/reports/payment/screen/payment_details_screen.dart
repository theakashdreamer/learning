import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';

class PaymentDetailsScreen extends StatelessWidget {
  final String paymentId;

  PaymentDetailsScreen({required this.paymentId});

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return BlocProvider(
      create: (_) => PaymentBloc()..add(LoadPaymentDetailsEvent(paymentId)),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Payment Details"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, state) {
                if (state is PaymentLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is PaymentLoadedState) {
                  List<Map<String, dynamic>> paymentData =
                      state.payments; // List of payment data
        
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: paymentData.map((payment) {
                        index++;
                        return Card(
                          elevation: 5,
                          // Subtle shadow for the card
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          // Small margins for card
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 10.0),
                            // Reduced padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Total Amount
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Amount",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                    ),
                                    Text(
                                      "$index",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.red),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // Smaller space between text and amount
                                Text(
                                  "₹${payment['totalAmount']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Divider(),
                                // Line separator
                                const SizedBox(height: 8),
        
                                // Payment Method
                                Text(
                                  "Payment Method",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  payment['paymentMethod'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: Colors.black87, fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Divider(),
                                const SizedBox(height: 8),
        
                                // Payment Status
                                Text(
                                  "Payment Status",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  payment['paymentStatus'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: payment['paymentStatus'] ==
                                                  'Success'
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else if (state is PaymentErrorState) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  );
                }
        
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
