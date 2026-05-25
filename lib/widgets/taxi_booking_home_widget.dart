import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolmanagementsystem/bloc/taxi_booking_event.dart';
import 'package:schoolmanagementsystem/widgets/taxi_booking_confirmed_widget.dart';
import 'package:schoolmanagementsystem/widgets/taxi_booking_details_widget.dart';
import 'package:schoolmanagementsystem/widgets/taxi_booking_not_confirmed_widget.dart';
import 'package:schoolmanagementsystem/widgets/taxi_booking_payments_widget.dart';
import 'package:schoolmanagementsystem/widgets/taxi_booking_state_widget.dart';
import 'package:schoolmanagementsystem/widgets/taxi_booking_taxis_widget.dart';

import '../bloc/taxi_booking_bloc.dart';
import '../bloc/taxi_booking_state.dart';
import 'loading_shimmer.dart';

class TaxiBookingHomeWidget extends StatefulWidget {
  @override
  _TaxiBookingHomeWidgetState createState() => _TaxiBookingHomeWidgetState();
}

class _TaxiBookingHomeWidgetState extends State<TaxiBookingHomeWidget>
    with TickerProviderStateMixin<TaxiBookingHomeWidget> {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    print("Home Build ");
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = CurvedAnimation(
      curve: Curves.easeIn,
      parent: animationController,
    );
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    double requiredHeight = MediaQuery.of(context).size.height * 2.5 / 3;
    return BlocListener<TaxiBookingBloc, TaxiBookingState>(
      listener: (context, state) async {
        if (state is TaxiBookingCancelledState)
          await animationController.reverse(from: 1.0);
      },
      child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Container(
              height: requiredHeight * animation.value,
              child: child,
            );
          },
          child: SingleChildScrollView(
            child: Container(
              height: requiredHeight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  /*   ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0)),
                      child: TaxiBookingStateWidget()),*/
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36.0),
                          topRight: Radius.circular(36.0)),
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * 1 / 1.6,
                        margin: EdgeInsets.only(bottom: 24.0),
                        child: BlocBuilder<TaxiBookingBloc, TaxiBookingState>(
                          builder: (context, currentState) {
                            switch (currentState.runtimeType) {
                              case TaxiBookingLoadingState:
                                return LoadingShimmer();
                              case DetailsNotFilledState:
                              case TaxiBookingNotSelectedState:
                                return TaxiBookingDetailsWidget();
                              case TaxiNotSelectedState:
                                return TaxiBookingTaxisWidget();
                              case PaymentNotInitializedState:
                                return TaxiBookingPaymentsWidget();
                              case TaxiNotConfirmedState:
                                return TaxiBookingNotConfirmedWidget();
                              case TaxiBookingConfirmedState:
                                return TaxiBookingConfirmedWidget();
                              default:
                                return TaxiBookingDetailsWidget();
                            }
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
