import '../models/taxi_driver.dart';

class TaxiDriverStorage {
  static TaxiDriver? _driver;
  static Future<TaxiDriver> saveDriver(TaxiDriver driver) async {
    if (_driver == null) {
      _driver = driver;
    } else {
      _driver = _driver!.copyWith(
        ride_Id: driver.ride_Id,
        driverName: driver.driverName,
        driverRating: driver.driverRating,
        taxiDetails: driver.taxiDetails,
        driverPic: driver.driverPic,
        isRideStarted: driver.isRideStarted,
        driverLocation: driver.driverLocation,
        driverAccepted: driver.driverAccepted,
        ResultString: driver.ResultString,
        RideStatus_Id: driver.RideStatus_Id,
        Mobile_No: driver.Mobile_No,
      );
    }
    return _driver!;
  }

  /// Get current driver
  static TaxiDriver? get driver => _driver;
}
