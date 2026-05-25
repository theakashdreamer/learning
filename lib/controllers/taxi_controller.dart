import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/taxi.dart';
import '../models/taxi_type.dart';

class TaxiController {
  static Future<List<Taxi>> getTaxis() async {
    return [
      Taxi.named(
        id: "1",
        title: "Standard",
        plateNo: "DL1AB1234",
        isAvailable: true,
        taxiType: TaxiType.Standard1,
        position: LatLng(28.6139, 77.2090), // example coordinates
      ),
      Taxi.named(
        id: "2",
        title: "Premium",
        plateNo: "DL1CD5678",
        isAvailable: true,
        taxiType: TaxiType.Premium,
        position: LatLng(28.6140, 77.2100),
      ),
      Taxi.named(
        id: "3",
        title: "Platinum",
        plateNo: "DL1EF9012",
        isAvailable: true,
        taxiType: TaxiType.Platinum,
        position: LatLng(28.6150, 77.2110),
      ),
    ];
  }
}
