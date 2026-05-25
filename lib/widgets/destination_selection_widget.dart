import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../bloc/taxi_booking_bloc.dart';
import '../bloc/taxi_booking_event.dart';
import '../controllers/user_location_controller.dart';
import '../models/user_location.dart';

class DestinationSelectionWidget extends StatefulWidget {
  @override
  _DestinationSelectionWidgetState createState() =>
      _DestinationSelectionWidgetState();
}

class _DestinationSelectionWidgetState extends State<DestinationSelectionWidget>
    with TickerProviderStateMixin {
  late bool isLoading;
  List<UserLocation>? savedLocations;
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    isLoading = true;

    // Initialize animation controller
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(
      curve: Curves.easeInExpo,
      parent: animationController,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      animationController.forward();
      loadDestinations();
    });
  }

  Future<void> loadDestinations() async {
    setState(() => isLoading = true);
    savedLocations = await UserLocationController.getSavedLocations();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    double requiredHeight = MediaQuery.of(context).size.height * 2.5 / 3;
    return AnimatedBuilder(
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
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0)),
                  child: Container(
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    child: Text("Select Destination", // your heading text
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal)),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36.0),
                          topRight: Radius.circular(36.0)),
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * 1 / 1.6,
                        margin: EdgeInsets.only(bottom: 24.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: savedLocations != null
                              ? savedLocations!.length + 1
                              : 0,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return buildNewDestinationWidget();
                            } else {
                              return buildDestinationWidget(
                                  savedLocations![index - 1]);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget buildDestinationWidget(UserLocation location) {
    return GestureDetector(
      onTap: () {
        selectDestination(location.position);
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 15.0,
              spreadRadius: 0.05,
            ),
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(0xffeeeeee),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8.0),
              child: Icon(
                location.locationType == UserLocationType.Home
                    ? Icons.home
                    : Icons.work,
                size: 22.0,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              location.locationType
                  .toString()
                  .replaceFirst("UserLocationType.", ""),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 4.0),
            Text(
              "${location.minutesFar} minutes",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNewDestinationWidget() {
    return GestureDetector(
      onTap: () {
        selectDestination(null);
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 15.0,
              spreadRadius: 0.05,
            ),
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.my_location,
                size: 22.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              "New Ride",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 4.0),
            Text(
              "Select Dest.",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  void selectDestination(LatLng? position) async {
    await animationController.reverse(from: 1.0);
    BlocProvider.of<TaxiBookingBloc>(context)
        .add(DestinationSelectedEvent(destination: position));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
