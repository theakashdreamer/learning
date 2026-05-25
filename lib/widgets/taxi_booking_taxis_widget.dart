import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/taxi_booking_bloc.dart';
import '../bloc/taxi_booking_event.dart';
import '../bloc/taxi_booking_state.dart';
import '../loginModules/entity/TypeOfAmbulance.dart';
import '../models/taxi.dart';
import '../models/taxi_booking.dart';
import '../storage/taxi_storage.dart';

class TaxiBookingTaxisWidget extends StatefulWidget {
  @override
  _TaxiBookingTaxisWidgetState createState() => _TaxiBookingTaxisWidgetState();
}

class _TaxiBookingTaxisWidgetState extends State<TaxiBookingTaxisWidget> {
  TaxiBooking? taxiBooking;
  List<TypeOfAmbulance> typeOfAmbulanceList = [];
  late TypeOfAmbulance? selectedAmbulanceType;
  List<Taxi> taxis = [];
  double? distanceKm;
  Map<String, double>? calculatedFares = {};
  bool isLoadingDistance = false;
  String? distanceError;
  static const double basePrice = 100.0;
  static const double defaultPricePerKm = 15.0;
  int totalFare = 0;
  final Map<TypeOfAmbulance, double> _priceCache = {};
  final Map<TypeOfAmbulance, String> _priceDuration = {};
  final Map<TypeOfAmbulance, String> _priceDistance = {};

  @override
  void initState() {
    super.initState();
    taxiBooking = (BlocProvider.of<TaxiBookingBloc>(context).state
            as TaxiNotSelectedState)
        .booking;
    typeOfAmbulanceList = (BlocProvider.of<TaxiBookingBloc>(context).state
            as TaxiNotSelectedState)
        .typeOfAmbulanceList;
    selectedAmbulanceType = taxiBooking?.typeOfAmbulance.AM_TypeId != null
        ? taxiBooking?.typeOfAmbulance
        : typeOfAmbulanceList.isNotEmpty
            ? typeOfAmbulanceList[0]
            : null;
    getTaxi();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Column(
          children: [
            // Header Section - Enhanced
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
                child: Column(
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Title and Distance Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Ambulance Type",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Choose the most suitable option",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[300],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        // Distance Badge
                        if (taxiBooking?.distance != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.grey[700]!, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Distance",
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "${taxiBooking?.distance!}",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
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
                    child: Column(
                      children: [
                        // Vehicle Selection Content
                        Expanded(
                          child: typeOfAmbulanceList.isEmpty
                              ? _buildEmptyState()
                              : SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Vehicle Options Title
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons
                                                          .directions_car_filled,
                                                      size: 18,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "Available Options",
                                                  style: theme
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              "Tap to select your preferred vehicle type",
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: Colors.grey[600],
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Vehicle Type Cards
                                      ...typeOfAmbulanceList
                                          .map((ambulance) =>
                                              _buildAmbulanceCardEnhanced(
                                                  ambulance))
                                          .toList(),

                                      SizedBox(height: 24),

                                      // Price Information Card
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                              color: Colors.grey[300]!,
                                              width: 1),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 36,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons
                                                          .info_outline_rounded,
                                                      size: 18,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  "Pricing Information",
                                                  style: theme
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              "Prices are calculated based on distance and vehicle type. The final fare may vary based on traffic conditions and waiting time.",
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: Colors.grey[600],
                                                fontSize: 13,
                                              ),
                                            ),
                                            if (taxiBooking?.expectedTime !=
                                                null)
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 12),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.timer_outlined,
                                                      size: 16,
                                                      color: Colors.blue[600],
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      "Estimated time: ${taxiBooking?.expectedTime}",
                                                      style: theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        color: Colors.blue[700],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                        ),

                        // Action Buttons Section
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                top: BorderSide(
                                    color: Colors.grey[200]!, width: 1)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: Offset(0, -2),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.fromLTRB(
                              10,
                              8,
                              10,
                              MediaQuery.of(context).viewInsets.bottom > 0
                                  ? 8
                                  : 12),
                          child: Row(
                            children: [
                              // Back Button
                              Container(
                                width: 45,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<TaxiBookingBloc>(context)
                                        .add(BackPressedEvent());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding: EdgeInsets.zero,
                                    elevation: 4,
                                    shadowColor: Colors.black.withOpacity(0.3),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    size: 24,
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),

                              // Confirm Button
                              Expanded(
                                child: Container(
                                  height: 45,
                                  child: ElevatedButton.icon(
                                    onPressed: (typeOfAmbulanceList.isEmpty ||
                                            selectedAmbulanceType == null)
                                        ? null
                                        : () {
                                            double? selectedPrice =
                                                selectedAmbulanceType != null
                                                    ? _priceCache[
                                                        selectedAmbulanceType]
                                                    : null;
                                            BlocProvider.of<TaxiBookingBloc>(
                                                    context)
                                                .add(
                                              TaxiSelectedEvent(selectedAmbulanceType:
                                                      selectedAmbulanceType,
                                                  typeOfAmbulanceList:
                                                      typeOfAmbulanceList,
                                                  price: selectedPrice,
                                                  espectedTime:
                                                      taxiBooking!.expectedTime,
                                                  distance:
                                                      taxiBooking!.distance),
                                            );
                                          },
                                    icon: Icon(
                                      Icons.directions_car_filled,
                                      size: 20,
                                    ),
                                    label: Text(
                                      typeOfAmbulanceList.isEmpty
                                          ? "No Options"
                                          : "Confirm Vehicle",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 4,
                                      shadowColor:
                                          Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmbulanceCardEnhanced(TypeOfAmbulance ambulance) {
    final bool isSelected = ambulance == selectedAmbulanceType;

    return GestureDetector(
      onTap: () {
        if (!mounted) return;
        double? selectedPrice = ambulance != null ? _priceCache[ambulance] : null;
        String? selectedDuration = ambulance != null ? _priceDuration[ambulance] : null;
        print("Selected ambulance price: ₹$selectedPrice");
        setState(() {
          selectedAmbulanceType = ambulance;
        });
        context.read<TaxiBookingBloc>().add(
              TaxiSelectedEvent(
                  selectedAmbulanceType: selectedAmbulanceType,
                  typeOfAmbulanceList: typeOfAmbulanceList,
                  price: selectedPrice,
                  espectedTime: taxiBooking!.expectedTime,
                  distance:  taxiBooking!.distance?.replaceAll(" km", "")),
            );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? Colors.blue[300]! : Colors.grey[200]!,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.08 : 0.04),
              blurRadius: isSelected ? 12 : 8,
              offset: Offset(0, isSelected ? 4 : 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Icon Container
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[50] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? Colors.blue[200]! : Colors.grey[200]!,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.local_taxi_outlined,
                    size: 25,
                    color: isSelected ? Colors.blue[700] : Colors.grey[700],
                  ),
                ),
              ),

              SizedBox(width: 10),

              // Vehicle Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Selection Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ambulance.AM_TypeName.toString()
                                    .replaceFirst("TaxiType.", ""),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              if (ambulance.AM_TypeDescription?.isNotEmpty ==
                                  true)
                                Text(
                                  ambulance.AM_TypeDescription!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green[200]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle,
                                    size: 14, color: Colors.green[700]),
                                SizedBox(width: 4),
                                Text(
                                  "Selected",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Vehicle Features
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // Distance Chip
                        _buildEnhancedFeatureChip(
                          icon: Icons.directions_outlined,
                          text: taxiBooking?.distance ?? "Calculating...",
                          backgroundColor: Colors.blue[50],
                          iconColor: Colors.blue[700],
                          textColor: Colors.blue[800],
                        ),

                        // Time Chip
                        _buildEnhancedFeatureChip(
                          icon: Icons.timer_outlined,
                          text: taxiBooking?.expectedTime ?? "Calculating...",
                          backgroundColor: Colors.orange[50],
                          iconColor: Colors.orange[700],
                          textColor: Colors.orange[800],
                        ),

                        // Price Chip (FutureBuilder)
                        FutureBuilder<double>(
                          future: _priceCache.containsKey(ambulance)
                              ? Future.value(_priceCache[ambulance])
                              : _getAmbulanceTypePrice1(ambulance)
                                  .then((price) {
                                  _priceCache[ambulance] = price;
                                  return price;
                                }),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _buildEnhancedFeatureChip(
                                icon: Icons.currency_rupee_outlined,
                                text: "Calculating...",
                                backgroundColor: Colors.grey[100],
                                iconColor: Colors.grey[600],
                                textColor: Colors.grey[700],
                              );
                            }

                            if (snapshot.hasError) {
                              return _buildEnhancedFeatureChip(
                                icon: Icons.error_outline,
                                text: "Error",
                                backgroundColor: Colors.red[50],
                                iconColor: Colors.red[600],
                                textColor: Colors.red[700],
                              );
                            }

                            final price = snapshot.data ?? 0;
                            return _buildEnhancedFeatureChip(
                              icon: Icons.currency_rupee_outlined,
                              text: "$price",
                              backgroundColor: Colors.green[50],
                              iconColor: Colors.green[700],
                              textColor: Colors.green[800],
                              isHighlighted: isSelected,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedFeatureChip({
    required IconData icon,
    required String text,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: backgroundColor?.withOpacity(0.3) ??
                      Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: iconColor ?? Colors.grey[700],
          ),
          SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: textColor ?? Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<double> _getAmbulanceTypePrice1(TypeOfAmbulance ambulance) async {
    List<Taxi> taxis = (await Taxistorage.getTaxis()) ?? [];
    final distanceString = taxiBooking!.distance ?? "0";
    final distance =
        double.tryParse(distanceString.replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0.0;
    Taxi? selectedTaxi = taxis.firstWhere(
      (taxi) => ambulance.AM_TypeId.contains(taxi.AmbulanceType_Id),
      orElse: () => Taxi(),
    );
    if (selectedTaxi != null && selectedTaxi.AmountPerKM.isNotEmpty) {
      try {
        final amountPerKM = double.tryParse(selectedTaxi.AmountPerKM) ?? 0.0;
        final totalPrice = amountPerKM * distance;
        print('Total price for ambulance: \$${totalPrice}');
        return totalPrice.toDouble();
      } catch (e) {
        print('Error parsing AmountPerKM: $e');
        return 0;
      }
    } else {
      print('No valid taxi found or AmountPerKM is empty');
      return 0;
    }
  }

  Future<void> getTaxi() async {
    taxis = (await Taxistorage.getTaxis())!;
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: Colors.grey[200]!, width: 2),
              ),
              child: Center(
                child: Icon(
                  Icons.directions_car_outlined,
                  size: 20,
                  color: Colors.grey[400],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "No Ambulance Available",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              "Sorry, there are no Ambulance types available at the moment.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
