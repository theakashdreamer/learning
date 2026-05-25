import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolmanagementsystem/loginModules/data/dataSources/dataBaseHelper.dart';
import 'package:schoolmanagementsystem/loginModules/globalClass/globalClass.dart';

import '../bloc/taxi_booking_bloc.dart';
import '../bloc/taxi_booking_event.dart';
import '../bloc/taxi_booking_state.dart';
import '../controllers/location_controller.dart';
import '../loginModules/entity/UserDetails.dart';
import '../models/google_location.dart';
import 'edit_location_screen.dart';

class TaxiBookingDetailsWidget extends StatefulWidget {
  @override
  _TaxiBookingDetailsWidgetState createState() =>
      _TaxiBookingDetailsWidgetState();
}

class _TaxiBookingDetailsWidgetState extends State<TaxiBookingDetailsWidget> {
  late GoogleLocation? source = null, destination = null;
  late String noOfPersons;
  DateTime? bookingTime;
  bool _isLoading = false;
  bool _showScheduleTime = false;

  @override
  void initState() {
    super.initState();
    noOfPersons = "1";
    bookingTime = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final state = BlocProvider.of<TaxiBookingBloc>(context).state;
      var currentLocation = await LocationController.getCurrentLocationNew();
      if (state is DetailsNotFilledState) {
        final taxiBooking = state.booking;
        noOfPersons = taxiBooking?.noOfPersons ?? "1";
        bookingTime = taxiBooking?.bookingTime ?? DateTime.now();
        source =
            taxiBooking?.source ?? currentLocation ?? GoogleLocation.named();
        destination = taxiBooking?.destination ?? GoogleLocation.named();
        _showScheduleTime = taxiBooking?.bookingTime != null;
      } else {
        source = currentLocation;
        destination = GoogleLocation.named();
      }
      setState(() {});
    });
  }

  Future<void> _submitDetails() async {
    if (source == null || source!.areaDetails.isEmpty) {
      GlobalClass.fetchToastPosition("Please enter your current location");
      return;
    }

    if (destination == null ||
        destination!.areaDetails.isEmpty ||
        destination!.areaDetails == "Where To?") {
      GlobalClass.fetchToastPosition("Please enter your destination");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final UserDetails? userDetails =
          await DataBaseHelper.getUserDetailsDetails();

      if (userDetails != null) {
        BlocProvider.of<TaxiBookingBloc>(context).add(
          DetailsSubmittedEvent(
            bookingTime: bookingTime ?? DateTime.now(),
            source: source!,
            destination: destination!,
            noOfPersons: noOfPersons.toString(),
            Driver_Id: "",
            Passenger_Id: userDetails.TraineeID,
            O12_AddedBy: userDetails.Designation_ID,
          ),
        );
      } else {
        GlobalClass.fetchToastPosition(
            "Something went wrong. Please try again");
      }
    } catch (e) {
      GlobalClass.fetchToastPosition("Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black, // Header background color
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP DRAG HANDLE (OLA STYLE)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Drag handle color
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                /// BACK BUTTON + TITLE ROW
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Book a ride",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// PICKUP
                          _simpleLocationTile(
                            context,
                            title: "Pickup",
                            value: source?.areaDetails,
                            hint: "Select pickup location",
                            icon: Icons.my_location,
                            color: Colors.green,
                            onTap: () async {
                              final selectedLocation = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditLocationScreen(
                                      initialValue: source?.areaDetails ?? "",
                                      mode: 1),
                                ),
                              );
                              if (selectedLocation != null && mounted) {
                                setState(() => source = selectedLocation);
                              }
                            },
                          ),

                          /// DROP
                          _simpleLocationTile(
                            context,
                            title: "Drop",
                            value: destination?.areaDetails,
                            hint: "Where are you going?",
                            icon: Icons.location_on,
                            color: Colors.red,
                            onTap: () async {
                              final dest = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditLocationScreen(
                                    initialValue:
                                        destination?.areaDetails ?? "",
                                    mode: 2,
                                  ),
                                ),
                              );
                              if (dest != null && mounted) {
                                setState(() => destination = dest);
                                await _submitDetails();
                              }
                            },
                          ),

                          const SizedBox(height: 20),
/*
                          /// PASSENGERS
                          Text(
                            "Passengers",
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),

                          Row(
                            children: [1, 2, 3, 4]
                                .map((e) => Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(
                                              () => noOfPersons = e.toString());
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          height: 52,
                                          decoration: BoxDecoration(
                                            color: noOfPersons == e.toString()
                                                ? Colors.black
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                              color: noOfPersons == e.toString()
                                                  ? Colors.black
                                                  : Colors.grey[300]!,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "$e",
                                              style: TextStyle(
                                                color:
                                                    noOfPersons == e.toString()
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),

                          const SizedBox(height: 24),

                          /// SCHEDULE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Schedule ride",
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Switch(
                                value: _showScheduleTime,
                                activeColor: Colors.black,
                                onChanged: (v) {
                                  setState(() {
                                    _showScheduleTime = v;
                                    if (!v) bookingTime = DateTime.now();
                                  });
                                },
                              ),
                            ],
                          ),

                          if (_showScheduleTime)
                            GestureDetector(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030),
                                  initialDate: bookingTime ?? DateTime.now(),
                                );
                                if (date != null) {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        TimeOfDay.fromDateTime(bookingTime!),
                                  );
                                  if (time != null) {
                                    setState(() {
                                      bookingTime = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        time.hour,
                                        time.minute,
                                      );
                                    });
                                  }
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.schedule),
                                    const SizedBox(width: 12),
                                    Text(
                                      bookingTime != null
                                          ? DateFormat('EEE, MMM d • hh:mm a')
                                              .format(bookingTime!)
                                          : "Select date & time",
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          const SizedBox(height: 80),*/
                        ],
                      ),
                    ),
                  ),

                  /// BOTTOM CTA
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: SizedBox(
                      height: 54,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Book",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey[200]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                ),
              ],
            ),

            SizedBox(height: 5),

            // Card Content
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _simpleLocationTile(
    BuildContext context, {
    required String title,
    required String? value,
    required String hint,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    value?.isNotEmpty == true ? value! : hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
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
    required String subtitle,
    required String hint,
    required bool hasValue,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasValue ? iconColor!.withOpacity(0.3) : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: iconColor!.withOpacity(0.2), width: 1.5),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  hasValue ? subtitle : hint,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: hasValue ? Colors.black : Colors.grey[600],
                    fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Icon(
                Icons.edit_outlined,
                size: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerOptionEnhanced(String value, bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.black : Colors.grey[300]!,
          width: isSelected ? 2.5 : 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 22,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
