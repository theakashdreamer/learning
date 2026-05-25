import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class LoadPaymentDetailsEvent extends PaymentEvent {
  final String paymentId;

  LoadPaymentDetailsEvent(this.paymentId);

  @override
  List<Object?> get props => [paymentId];
}

class PaymentStatusUpdatedEvent extends PaymentEvent {
  final String paymentStatus;

  PaymentStatusUpdatedEvent(this.paymentStatus);

  @override
  List<Object?> get props => [paymentStatus];
}
