import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../models/google_location.dart';

class LocationService {
  static String apiKey = "AIzaSyBew8_tTpCWn4PrXTpra_besUQyr8lLZVs";

  static Future<List<Map<String, dynamic>>> getSuggestions(String input) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&types=geocode&components=country:in";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final predictions = data['predictions'] as List<dynamic>;
        return predictions.map((p) => p as Map<String, dynamic>).toList();
      } else {
        throw Exception(data['error_message'] ?? "Failed to fetch locations");
      }
    } else {
      throw Exception("Failed to fetch locations");
    }
  }

  Future<Map<String, dynamic>> getDirections(
    GoogleLocation origin,
    GoogleLocation destination,
  ) async {
    final url = "https://maps.googleapis.com/maps/api/directions/json"
        "?origin=${origin.position.latitude},${origin.position.longitude}"
        "&destination=${destination.position.latitude},${destination.position.longitude}"
        "&mode=driving"
        "&units=metric"
        "&alternatives=false"
        "&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception("HTTP Error: ${response.statusCode}");
      }

      final data = json.decode(response.body);

      if (data['status'] != 'OK') {
        throw Exception(data['error_message'] ?? data['status']);
      }

      final route = data['routes'][0];
      final leg = route['legs'][0];

      return {
        "distance": leg['distance']['text'],
        "duration": leg['duration']['text'],
        "polylinePoints": decodePolyline(route['overview_polyline']['points']),
        "bounds": route['bounds'], // 👈 for camera zoom
        "startLocation": leg['start_location'],
        "endLocation": leg['end_location'],
      };
    } catch (e) {
      throw Exception("Directions API error: $e");
    }
  }

  // 9453004094
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(
        LatLng(lat / 1E5, lng / 1E5),
      );
    }
    return polyline;
  }

  static Future<List<GoogleLocation>> getMockSuggestions(String input) async {
    // Mock data of nearby places around Lucknow, Uttar Pradesh, India
    List<Map<String, dynamic>> mockData = [
      {
        "description": "Hazratganj, Lucknow, Uttar Pradesh, India",
        "place_id": "ChIJqQcrlmX9mzkRlAR6pc8lhfkSFAoSCWuxMh-Z_Zs5EeeLlwmJusyT",
        "structured_formatting": {
          "main_text": "Hazratganj",
          "secondary_text": "Lucknow, Uttar Pradesh, India"
        },
      },
      {
        "description": "Mahanagar, Lucknow, Uttar Pradesh, India",
        "place_id":
            "Ej1Hb2wgTWFya2V0IENob3dyYWhhLCBNYWhhbmFnYXIsIEx1Y2tub3csIFV0dGFyIFByYWRlc2gsIEluZGlhIi4qLAoUChIJqQcrlmX9mzkRlAR6pc8lhfkSFAoSCWuxMh-Z_Zs5EeeLlwmJusyT",
        "structured_formatting": {
          "main_text": "Mahanagar",
          "secondary_text": "Lucknow, Uttar Pradesh, India"
        },
      },
      {
        "description": "Alambagh, Lucknow, Uttar Pradesh, India",
        "place_id": "ChIJu3H7UJntkDkRf5yz1taP0pM",
        "structured_formatting": {
          "main_text": "Alambagh",
          "secondary_text": "Lucknow, Uttar Pradesh, India"
        },
      },
      {
        "description": "Indira Nagar, Lucknow, Uttar Pradesh, India",
        "place_id": "ChIJb6pDzJ4O1zkR9FXKqBkrZgo",
        "structured_formatting": {
          "main_text": "Indira Nagar",
          "secondary_text": "Lucknow, Uttar Pradesh, India"
        },
      },
      {
        "description": "Gomti Nagar, Lucknow, Uttar Pradesh, India",
        "place_id": "ChIJ6a3AKRIZ1zkRkP-h57g7-BM",
        "structured_formatting": {
          "main_text": "Gomti Nagar",
          "secondary_text": "Lucknow, Uttar Pradesh, India"
        },
      },
    ];

    // Generate mock GoogleLocation objects based on mock data
    List<GoogleLocation> locationList = [];
    for (int i = 0; i < mockData.length; i++) {
      locationList.add(GoogleLocation.named(
        placeId: mockData[i]['place_id'],
        areaDetails: mockData[i]['description'],
      ));
    }

    return locationList;
  }

  static Future<double> calculateDistanceKm(
    Map<String, double> origin,
    Map<String, double> destination,
  ) async {
    try {
      final originLat = origin['latitude'] ?? origin['lat'];
      final originLng = origin['longitude'] ?? origin['lng'] ?? origin['lon'];

      final destLat = destination['latitude'] ?? destination['lat'];
      final destLng =
          destination['longitude'] ?? destination['lng'] ?? destination['lon'];

      if (originLat == null ||
          originLng == null ||
          destLat == null ||
          destLng == null) {
        throw Exception("Missing coordinates in map");
      }

      final uri = Uri.parse(
        'https://routes.googleapis.com/directions/v2:computeRoutes',
      );

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': 'routes.distanceMeters',
        },
        body: jsonEncode({
          "origin": {
            "location": {
              "latLng": {"latitude": originLat, "longitude": originLng}
            }
          },
          "destination": {
            "location": {
              "latLng": {"latitude": destLat, "longitude": destLng}
            }
          },
          "travelMode": "DRIVE",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final distanceMeters = data['routes'][0]['distanceMeters'];
          return distanceMeters / 1000.0;
        }
        throw Exception("No routes found");
      }

      throw Exception("HTTP error: ${response.statusCode}");
    } catch (e) {
      print('Distance calculation error: $e');
      rethrow;
    }
  }

  static LatLng? parseCoordinates(dynamic locationData) {
    if (locationData == null) return null;

    if (locationData is Map<String, dynamic>) {
      if (locationData['latitude'] != null &&
          locationData['longitude'] != null) {
        return LatLng(
          locationData['latitude'] as double,
          locationData['longitude'] as double,
        );
      }
    }
    return null;
  }
}
