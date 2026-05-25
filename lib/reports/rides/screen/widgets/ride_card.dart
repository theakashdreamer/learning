import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/get_all_rides_for_driver_and_passenger.dart';
import '../../model/ride_model.dart';

class RideCard extends StatelessWidget {
  final GetAllRidesForDriverAndPassenger ride;
  final VoidCallback? onTap;

  const RideCard({
    super.key,
    required this.ride,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------- Header -------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${ride.Ride_Id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(ride.Status_Title).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ride.Status_Title,
                      style: TextStyle(
                        color: _getStatusColor(ride.Status_Title),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              // ------------------- Date & Time -------------------
              Text(
                ride.Scheduled_Time,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              // ------------------- Locations -------------------
              // Replace your location rows with this
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column: icons + vertical line
                  Column(
                    children: [
                      Icon(Icons.my_location, color: Colors.green, size: 20),
                      Container(
                        width: 2,
                        height: 40, // adjust to match spacing between locations
                        color: Colors.grey[400],
                      ),
                      Icon(Icons.location_on, color: Colors.red, size: 20),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // Right column: location texts
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120, // adjust to card width
                        child: Text(
                          ride.Start_Location,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 22), // spacing matches vertical line height
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        child: Text(
                          ride.End_Location,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 5),
              // ------------------- Ride Details -------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem(
                    icon: Icons.local_taxi_outlined,
                    text: getAbbreviationRideName(ride.AM_TypeName),
                  ),
                  _buildDetailItem(
                    icon: Icons.space_dashboard,
                    text: '${ride.Distance} km',
                  ),
                  _buildDetailItem(
                    icon: Icons.currency_rupee,
                    text: '₹${ride.Fare}',
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // ------------------- Driver Info -------------------
              if (ride.Driver_Name != null)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person, size: 16),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Driver: ${ride.Driver_Name}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              // ------------------- Rating -------------------
              if (ride.Rating_Points != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: buildRatingStars(ride.Rating_Points),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRatingStars(double rating) {
    // Round rating to nearest half for display
    int fullStars = rating.floor(); // full stars
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    List<Widget> stars = [];

    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 18));
    }

    // Add half star if needed
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 18));
    }

    // Add empty stars
    for (int i = 0; i < emptyStars; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 18));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }
  String getAbbreviationRideName(String fullName) {
    final regex = RegExp(r'\(([^)]+)\)');
    final match = regex.firstMatch(fullName);
    if (match != null) {
      final abbr = match.group(1); // e.g., "BLS"
      // Get the rest of the string after parentheses (remove the parentheses part)
      final after = fullName.replaceAll(regex, '').trim();
      return '$abbr Ambulance'; // "BLS Ambulance"
    }
    return fullName; // fallback if no parentheses found
  }

  Widget _buildLocationRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String text,
    Color iconColor = Colors.grey,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    if(status!.isNotEmpty){
      if(status.toLowerCase()=="completed"){
        return Colors.green;
      }else if(status.toLowerCase()=="cancelled"){
        return Colors.red;
      }else if(status.toLowerCase()=="pending"){
        return Colors.yellow;
      }
      return Colors.blue;
    }
    return Colors.blue;
  }

  String _getStatusText(RideStatus status) {
    switch (status) {
      case RideStatus.completed:
        return 'Completed';
      case RideStatus.cancelled:
        return 'Cancelled';
      case RideStatus.upcoming:
        return 'Upcoming';
    }
  }

  String _getRideTypeText(RideType type) {
    switch (type) {
      case RideType.bike:
        return 'Bike';
      case RideType.auto:
        return 'Auto';
      case RideType.car:
        return 'Car';
    }
  }
}