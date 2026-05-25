import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentLoadingState extends PaymentState {}

class PaymentLoadedState extends PaymentState {
  final List<Map<String, dynamic>> payments;

  PaymentLoadedState({required this.payments});
}

class PaymentErrorState extends PaymentState {
  final String errorMessage;

  PaymentErrorState(this.errorMessage);
}
