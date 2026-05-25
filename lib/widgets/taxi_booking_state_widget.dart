import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolmanagementsystem/widgets/taxi_booking_cancellation_dialog.dart';
import '../bloc/taxi_booking_bloc.dart';
import '../bloc/taxi_booking_state.dart';
import 'dashed_line.dart';

class TaxiBookingStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaxiBookingBloc, TaxiBookingState>(
      builder: (context, state) {
        int selectedTab = 1;
        TaxiBookingState currentState = state;
        String title = "";

        if (state is TaxiBookingLoadingState) {
          currentState = state.state;
        }

        // Determine title and selected tab based on current state
        switch (currentState.runtimeType) {
          case DetailsNotFilledState:
            selectedTab = 1;
            title = "New Destination";
            break;
          case TaxiNotSelectedState:
            selectedTab = 2;
            title = "Choose Ride";
            break;
          case PaymentNotInitializedState:
            selectedTab = 3;
            title = "Payment Method";
            break;
          case TaxiNotConfirmedState:
            selectedTab = 4;
            title = "Ride Info";
            break;
        }

        return Container(
          color: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                  IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                TaxiBookingCancellationDialog());
                      },
                      color: Colors.white),
                ],
              ),

              Row(
                children: [
                  buildTab(context, "1", selectedTab >= 1),
                  Expanded(
                    child: DashedLine(color: Colors.white.withOpacity(0.3)),
                  ),
                  buildTab(context, "2", selectedTab >= 2),
                  Expanded(
                    child: DashedLine(color: Colors.white.withOpacity(0.3)),
                  ),
                  buildTab(context, "3", selectedTab >= 3),
                  Expanded(
                    child: DashedLine(color: Colors.white.withOpacity(0.3)),
                  ),
                  buildTab(context, "4", selectedTab >= 4),
                ],
              ),
              SizedBox(height: 12.0)
            ],
          ),
        );
      },
    );
  }

  Widget buildTab(BuildContext context, String val, bool enabled) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 9.0),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        "$val",
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: enabled ? Colors.black : Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }
}
