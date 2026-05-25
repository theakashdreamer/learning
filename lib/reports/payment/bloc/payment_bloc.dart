import 'package:bloc/bloc.dart';
import 'package:schoolmanagementsystem/reports/payment/bloc/payment_event.dart';
import 'package:schoolmanagementsystem/reports/payment/bloc/payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentLoadingState()) {
    on<LoadPaymentDetailsEvent>(_onLoadPaymentDetails);
    on<PaymentStatusUpdatedEvent>(_onPaymentStatusUpdated);
  }

  // Event handler for LoadPaymentDetailsEvent
  void _onLoadPaymentDetails(
      LoadPaymentDetailsEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoadingState()); // Emit loading state immediately
    try {
      await Future.delayed(Duration(seconds: 2)); // Simulate delay
      final paymentDetails = _mockPaymentDetails(event.paymentId);
      emit(PaymentLoadedState(payments: paymentDetails)); // Emit loaded state
    } catch (e) {
      emit(PaymentErrorState(
          "Failed to load payment details")); // Emit error state
    }
  }

  // Event handler for PaymentStatusUpdatedEvent
  void _onPaymentStatusUpdated(
      PaymentStatusUpdatedEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoadingState()); // Emit loading state immediately
    try {
      final updatedPayments = _mockPaymentDetails("12345"); // Example paymentId
      final updatedPayment =
          updatedPayments[0]; // Assume we update the first payment's status
      updatedPayment['paymentStatus'] =
          event.paymentStatus; // Update the status
      emit(PaymentLoadedState(
          payments: updatedPayments)); // Emit updated payment state
    } catch (e) {
      emit(PaymentErrorState(
          "Failed to update payment status")); // Emit error state
    }
  }

  // Mock data method to simulate loading payment details
  List<Map<String, dynamic>> _mockPaymentDetails(String paymentId) {
    return [
      {
        'totalAmount': 499.99,
        'paymentMethod': 'Credit Card',
        'paymentStatus': 'Success',
      },
      {
        'totalAmount': 299.99,
        'paymentMethod': 'Debit Card',
        'paymentStatus': 'Failed',
      },
    ];
  }
}
