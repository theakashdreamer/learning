import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schoolmanagementsystem/bloc/taxi_booking_event.dart';
import 'package:schoolmanagementsystem/loginModules/entity/UserDetails.dart';
import 'package:schoolmanagementsystem/models/payment_details.dart';

import '../bloc/taxi_booking_bloc.dart';
import '../data/storage/hive_storage.dart';
import '../loginModules/data/dataSources/dataBaseHelper.dart';
import '../models/rating/rating_entity.dart';
import '../models/taxi_booking.dart';
import '../models/taxi_driver.dart';

class CompletedRideWidget extends StatefulWidget {
  final ScrollController? controller;
  final TaxiBooking booking;
  final TaxiDriver? driver;
  final PaymentDetails? paymentDetails;

  const CompletedRideWidget({
    Key? key,
    this.controller,
    required this.booking,
    this.driver,
    this.paymentDetails,
  }) : super(key: key);

  @override
  State<CompletedRideWidget> createState() => _CompletedRideWidgetState();
}

class _CompletedRideWidgetState extends State<CompletedRideWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  double _rating = 0.0;
  String _reviewText = "";
  UserDetails? userDetails;

  Future<void> _init() async {
    final data = await DataBaseHelper.getUserDetailsDetails();
    if (!mounted) return;
    setState(() {
      userDetails = data;
    });
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animation =
        CurvedAnimation(curve: Curves.easeOut, parent: animationController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
    });
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final booking = widget.booking;
    final driver = widget.driver;
    final paymentDetails = widget.paymentDetails;
    final isCompleted = paymentDetails?.PaymentStatus_Id == 1;
    final canRate = paymentDetails?.PaymentStatus_Id == 2;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          // Header Section
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ride Completed",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        isCompleted
                            ? "Trip details & receipt"
                            : "Rate your experience",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[300],
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<TaxiBookingBloc>(context)
                          .add(BackPressedEvent());
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Section
          Expanded(
            child: Container(
              color: Colors.black,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Driver Info Card
                        _buildDetailCard(
                          context,
                          title: "Driver Details",
                          icon: Icons.person_outline,
                          children: [
                            SizedBox(height: 8),
                            Row(
                              children: [
                                // Driver Avatar
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[700],
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: driver?.driverPic.isNotEmpty == true
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(driver!.driverPic!),
                                        )
                                      : Center(
                                          child: Text(
                                            driver?.driverName
                                                    .substring(0, 1)
                                                    .toUpperCase() ??
                                                'D',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                ),
                                SizedBox(width: 14),

                                // Driver Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        driver?.driverName ?? 'Unknown Driver',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.directions_car_outlined,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            driver?.taxiDetails?.AM_TypeName ??
                                                'Unknown Vehicle',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 14,
                                            color: Colors.amber[600],
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "${driver?.driverRating.toStringAsFixed(1) ?? '0.0'}",
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Trip Details Card
                        _buildDetailCard(
                          context,
                          title: "Trip Details",
                          icon: Icons.route_outlined,
                          children: [
                            SizedBox(height: 8),

                            // Locations
                            _buildLocationRow(
                              context,
                              icon: Icons.my_location_outlined,
                              iconColor: Colors.green[700],
                              backgroundColor: Colors.green[50],
                              title: "Pickup",
                              address: booking.source.areaDetails,
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  SizedBox(width: 16),
                                  Container(
                                    width: 2,
                                    height: 20,
                                    color: Colors.grey[300],
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey[300],
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            _buildLocationRow(
                              context,
                              icon: Icons.flag_outlined,
                              iconColor: Colors.red[700],
                              backgroundColor: Colors.red[50],
                              title: "Destination",
                              address: booking.destination.areaDetails,
                            ),
                            SizedBox(height: 16),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Payment Details Card (only if completed)
                        if (isCompleted) ...[
                          _buildDetailCard(
                            context,
                            title: "Payment Details",
                            icon: Icons.receipt_outlined,
                            children: [
                              SizedBox(height: 8),
                              _buildPaymentRow(
                                label: "Ride Fare",
                                value: "₹${paymentDetails?.PaidAmount ?? 0.0}",
                                isTotal: false,
                              ),
                              SizedBox(height: 8),
                              _buildPaymentRow(
                                label: "Tax & Charges",
                                value: "Included",
                                isTotal: false,
                              ),
                              Divider(
                                height: 24,
                                color: Colors.grey[300],
                              ),
                              _buildPaymentRow(
                                label: "Total Paid",
                                value: "₹${paymentDetails?.PaidAmount ?? 0.0}",
                                isTotal: true,
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.green[200]!, width: 1),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 14,
                                      color: Colors.green[700],
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "Payment completed successfully",
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],

                        // Rating Section (if applicable)
                        if (canRate) ...[
                          _buildDetailCard(
                            context,
                            title: "Rate Your Experience",
                            icon: Icons.star_outline,
                            children: [
                              SizedBox(height: 8),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "How was your ride?",
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    // Star Rating
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(5, (index) {
                                        final starValue = index + 1;

                                        return GestureDetector(
                                          onTapDown: (details) {
                                            final box =
                                                context.findRenderObject()
                                                    as RenderBox;
                                            final localX = box
                                                .globalToLocal(
                                                    details.globalPosition)
                                                .dx;

                                            setState(() {
                                              // Tap left half = 0.5, right half = 1.0
                                              _rating =
                                                  localX < box.size.width / 2
                                                      ? starValue - 0.5
                                                      : starValue.toDouble();
                                            });
                                          },
                                          child: Icon(
                                            _getStarIcon(index),
                                            size: 28,
                                            color: Colors.amber[600],
                                          ),
                                        );
                                      }),
                                    ),

                                    SizedBox(height: 4),
                                    Text(
                                      _rating == 0
                                          ? "Tap to rate"
                                          : "${_rating.toDouble()}",
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    // Review Input
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey[300]!, width: 1),
                                      ),
                                      child: TextField(
                                        controller: TextEditingController(
                                            text: _reviewText),
                                        onChanged: (value) {
                                          setState(() {
                                            _reviewText = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Add a comment (optional)",
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 13,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        maxLines: 3,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: _rating > 0
                                            ? () async {
                                                // Submit rating logic here
                                                String rideID = await HiveStorage
                                                        .fetchString(HiveStorage
                                                            .keyRideId) ??
                                                    "0";
                                                String driverID =
                                                    await HiveStorage.fetchString(
                                                            HiveStorage
                                                                .keyDriverId) ??
                                                        "";
                                                if (userDetails == null) return;
                                                final ratingEntity =
                                                    RatingEntity(
                                                  ratingId: 0,
                                                  rideId: _toInt(rideID),
                                                  passengerId: _toInt(
                                                      userDetails!.TraineeID),
                                                  driverId: _toInt(driverID),
                                                  ratingPoints: _rating,
                                                  description: _reviewText,
                                                );
                                                context
                                                    .read<TaxiBookingBloc>()
                                                    .add(
                                                      SubmitRatingEvent(
                                                          ratingEntity),
                                                    );
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          "Submit Rating",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],

                        // Map Section (if completed)
                        if (isCompleted &&
                            booking.source.position.latitude != 0) ...[
                          _buildDetailCard(
                            context,
                            title: "Route Overview",
                            icon: Icons.map_outlined,
                            children: [
                              SizedBox(height: 8),
                              Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: booking.source.position,
                                      zoom: 12,
                                    ),
                                    markers: {
                                      Marker(
                                        markerId: MarkerId('start'),
                                        position: booking.source.position,
                                        infoWindow: InfoWindow(title: 'Pickup'),
                                        icon: BitmapDescriptor
                                            .defaultMarkerWithHue(
                                          BitmapDescriptor.hueGreen,
                                        ),
                                      ),
                                      Marker(
                                        markerId: MarkerId('end'),
                                        position: booking.destination.position,
                                        infoWindow:
                                            InfoWindow(title: 'Destination'),
                                        icon: BitmapDescriptor
                                            .defaultMarkerWithHue(
                                          BitmapDescriptor.hueRed,
                                        ),
                                      ),
                                    },
                                    polylines: {
                                      Polyline(
                                        polylineId: PolylineId('route'),
                                        points: [
                                          booking.source.position,
                                          booking.destination.position,
                                        ],
                                        color: Colors.blue,
                                        width: 3,
                                      ),
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],

                        // Action Button
                        Container(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              BlocProvider.of<TaxiBookingBloc>(context)
                                  .add(BackPressedEvent());
                            },
                            icon: Icon(
                              Icons.home_outlined,
                              size: 18,
                            ),
                            label: Text(
                              "Go to Home",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                letterSpacing: 0.2,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                          ),
                        ),

                        SizedBox(height: 8),

                        // Information Note
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.blue[200]!, width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 14,
                                color: Colors.blue[700],
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  isCompleted
                                      ? "Receipt has been saved to your trip history"
                                      : "Thank you for choosing our service",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStarIcon(int index) {
    if (_rating >= index + 1) {
      return Icons.star;
    } else if (_rating >= index + 0.5) {
      return Icons.star_half;
    } else {
      return Icons.star_border;
    }
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Card Content
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(
    BuildContext context, {
    required IconData icon,
    required Color? iconColor,
    required Color? backgroundColor,
    required String title,
    required String address,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: iconColor!.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: iconColor.withOpacity(0.2), width: 1.5),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 14,
                color: iconColor,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                ),
                SizedBox(height: 2),
                Text(
                  address,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: Colors.grey[600],
            ),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow({
    required String label,
    required String value,
    required bool isTotal,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 17 : 14,
            fontWeight: FontWeight.w700,
            color: isTotal ? Colors.black : Colors.grey[800],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
