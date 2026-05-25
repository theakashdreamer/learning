import '../models/taxi_booking.dart';
import '../models/taxi_type.dart';

class TaxiBookingStorage {
  static TaxiBooking? _taxiBooking;

  static Future<void> open() async {
    _taxiBooking ??= TaxiBooking();
  }

  static Future<TaxiBooking> addDetails(TaxiBooking taxiBooking) async {
    if (_taxiBooking == null) await open();
    _taxiBooking = await _taxiBooking!.copyWith(
      id: taxiBooking.id,
      source: taxiBooking.source,
      destination: taxiBooking.destination,
      noOfPersons: taxiBooking.noOfPersons,
      bookingTime: taxiBooking.bookingTime,
      taxiType: taxiBooking.typeOfAmbulance,
      estimatedPrice: taxiBooking.estimatedPrice,
      paymentMethod: taxiBooking.paymentMethod,
      promoApplied: taxiBooking.promoApplied,
      distance: taxiBooking.distance,
      expectedTime: taxiBooking.expectedTime,
      Ride_Id: taxiBooking.Ride_Id,
      taxiDriver: taxiBooking.taxiDriver,
      polyline: taxiBooking.polyline,
      Status_ID: taxiBooking.Status_ID,
    );
    return _taxiBooking!;
  }

  /// Retrieve the current taxi booking
  static Future<TaxiBooking?> getTaxiBooking() async {
    return _taxiBooking;
  }

  /// Clear the current taxi booking
  static Future<void> clear() async {
    _taxiBooking = null;
  }

  static var myRideMockData = [
    {
      "_id": "1",
      "source": {
        "placeId": "src1",
        "position": {"lat": 28.6139, "lng": 77.2090},
        "areaDetails": "Delhi"
      },
      "destination": {
        "placeId": "dest1",
        "position": {"lat": 28.7041, "lng": 77.1025},
        "areaDetails": "Noida"
      },
      "noOfPersons": 2,
      "bookingTime": "2025-09-03T10:30:00Z",
      "taxiType": TaxiType.Standard1,
      "estimatedPrice": 350,
      "paymentMethod": null,
      "promoApplied": "WELCOME"
    },
    {
      "_id": "2",
      "source": {
        "placeId": "src2",
        "position": {"lat": 19.0760, "lng": 72.8777},
        "areaDetails": "Mumbai"
      },
      "destination": {
        "placeId": "dest2",
        "position": {"lat": 18.5204, "lng": 73.8567},
        "areaDetails": "Pune"
      },
      "noOfPersons": 3,
      "bookingTime": "2025-09-02T15:00:00Z",
      "taxiType": TaxiType.Standard1,
      "estimatedPrice": 1200,
      "paymentMethod": null,
      "promoApplied": null
    },
    {
      "_id": "3",
      "source": {
        "placeId": "src3",
        "position": {"lat": 12.9716, "lng": 77.5946},
        "areaDetails": "Bangalore"
      },
      "destination": {
        "placeId": "dest3",
        "position": {"lat": 13.0827, "lng": 80.2707},
        "areaDetails": "Chennai"
      },
      "noOfPersons": 1,
      "bookingTime": "2025-09-01T12:00:00Z",
      "taxiType": TaxiType.Platinum,
      "estimatedPrice": 3000,
      "paymentMethod": null,
      "promoApplied": "FESTIVE50"
    }
  ];
}
