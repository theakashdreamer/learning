import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/taxi_booking_bloc.dart';
import '../bloc/taxi_booking_event.dart';
import '../bloc/taxi_booking_state.dart';
import '../widgets/completed_ride_widget.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_drawer.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/rideCancel/show_ride_cancel_widget.dart';
import '../widgets/rideStart/taxi_booking_start_widget.dart';
import '../widgets/taxi_booking_confirmed_widget.dart';
import '../widgets/taxi_booking_details_widget.dart';
import '../widgets/taxi_booking_not_confirmed_widget.dart';
import '../widgets/taxi_booking_payments_widget.dart';
import '../widgets/taxi_booking_taxis_widget.dart';
import '../widgets/taxi_map.dart';
import '../widgets/taxi_searching_driver_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TaxiBookingBloc _taxiBookingBloc;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
    );

    WidgetsBinding.instance.addObserver(this);
    _taxiBookingBloc = context.read<TaxiBookingBloc>();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _taxiBookingBloc.add(DisconnectWebSocketEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<TaxiBookingBloc>().add(BackPressedEvent());
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        endDrawer: HomeDrawer(),
        body: Stack(
          children: [
            /// MAP (Always visible like Ola)
            TaxiMap(),

            /// APP BAR (Transparent overlay)
            HomeAppBar(),

            /// BOTTOM SHEET
            BlocListener<TaxiBookingBloc, TaxiBookingState>(
              listener: (context, state) async {
                if (state is TaxiBookingCancelledState) {
                  await _animationController.reverse(from: 1);
                }
              },
              child: BlocBuilder<TaxiBookingBloc, TaxiBookingState>(
                builder: (context, state) {
                  if (state is TaxiBookingNotSelectedState &&
                      !state.showBottomSheet) {
                    return const SizedBox.shrink();
                  }

                  return AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - _animation.value)),
                        child: Opacity(opacity: _animation.value, child: child),
                      );
                    },
                    child: DraggableScrollableSheet(
                      initialChildSize: _initialSize(state),
                      minChildSize: _minSize(state),
                      maxChildSize: _maxSize(state),
                      builder: (context, scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 18,
                                color: Colors.black26,
                                offset: Offset(0, -3),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24)),
                            child: CustomScrollView(
                              controller: scrollController,
                              slivers: [
                                SliverFillRemaining(
                                  hasScrollBody: false, // 🔴 IMPORTANT
                                  child: _buildBottomSheetContent(state),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Ola-style dynamic sheet sizes
  double _initialSize(TaxiBookingState state) {
    if (state is TaxiBookingConfirmedState ||
        state is TaxiRideStartedState) return 0.65;
    if (state is TaxiNotSelectedState ||
        state is CompleteRideState) return 0.75;
    if (state is TaxiBookingNotSelectedState ||
        state is DetailsNotFilledState ||
        state is PaymentNotInitializedState ||
        state is ShowRideCancelWidgetState) return 0.75;
    return 0.65; // Search peek (Ola style)
  }

  double _minSize(TaxiBookingState state) {
    return 0.18;
  }

  double _maxSize(TaxiBookingState state) {
    if (state is TaxiBookingNotSelectedState ||
        state is DetailsNotFilledState ||
        state is PaymentNotInitializedState ||
        state is CompleteRideState ||
        state is ShowRideCancelWidgetState) {
      return 0.75;
    }

    if (state is TaxiRideStartedState || state is CompleteRideState) {
      return 0.65;
    }
    return 0.85;
  }

  Widget _buildBottomSheetContent(TaxiBookingState state) {
    /// Loading shimmer
    if (state is TaxiBookingLoadingState) {
      return LoadingShimmer();
    }

    /// SEARCH / ENTER DESTINATION (Ola Home)
    if (state is TaxiBookingNotSelectedState ||
        state is DetailsNotFilledState) {
      return TaxiBookingDetailsWidget();
    }

    /// SELECT CAB (Mini / Sedan / Auto)
    if (state is TaxiNotSelectedState) {
      return TaxiBookingTaxisWidget();
    }

    /// PAYMENT SELECTION
    if (state is PaymentNotInitializedState) {
      return TaxiBookingPaymentsWidget();
    }

    /// DRIVER SEARCHING

    if (state is TaxiSearchingState) {
      return TaxiSearchingDriverWidget();
    }

    if (state is TaxiNotConfirmedState) {
      return TaxiBookingNotConfirmedWidget();
    }

    /// DRIVER CONFIRMED
    if (state is TaxiBookingConfirmedState) {
      return TaxiBookingConfirmedWidget();
    }

    /// RIDE STARTED
    if (state is TaxiRideStartedState) {
      return TaxiBookingStartWidget();
    }

    /// RIDE COMPLETED
    if (state is CompleteRideState) {
      return CompletedRideWidget(
        booking: state.booking,
        driver: state.booking.taxiDriver,
        paymentDetails: state.paymentDetails,
      );
    }

    /// CANCEL SCREEN
    if (state is ShowRideCancelWidgetState) {
      return const ShowRideCancelWidget();
    }
    return TaxiBookingDetailsWidget();
  }
}
