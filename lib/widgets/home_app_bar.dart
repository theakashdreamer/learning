import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/taxi_booking_bloc.dart';
import '../bloc/taxi_booking_state.dart';
import '../loginModules/data/dataSources/dataBaseHelper.dart';
import '../loginModules/entity/UserDetails.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(64);
}

class _HomeAppBarState extends State<HomeAppBar> with TickerProviderStateMixin {
  late AnimationController controller;
  UserDetails? userDetails;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    getUserDetails();
  }

  Future<void> getUserDetails() async {
    final details = await DataBaseHelper.getUserDetailsDetails();
    setState(() {
      userDetails = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaxiBookingBloc, TaxiBookingState>(
      listener: (context, state) {
        if (state is TaxiBookingNotSelectedState) {
          controller.forward();
        } else {
          controller.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(controller),
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
                  .animate(controller),
              child: child,
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                blurRadius: 25.0,
                spreadRadius: 0.2,
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Hey ${userDetails?.TaineeName}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        "Grab your new ride now",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.05),
                          blurRadius: 25.0,
                          spreadRadius: 0.2,
                        ),
                      ],
                    ),
                    child: Icon(Icons.menu),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
