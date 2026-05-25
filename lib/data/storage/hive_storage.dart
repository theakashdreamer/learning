import 'package:hive_flutter/hive_flutter.dart';

import '../../loginModules/data/sharePreferencesKeys.dart';

class HiveStorage {
  static const String boxName = 'driver_data';

  static const String keyURL = 'URL';

  // 🔒 Ride-related keys (single source of truth)
  static const String keyRideId = 'RideID';
  static const String keyDriverId = 'DriverID';
  static const String keyRideOtp = 'Ride_OTP';
  static const String keyRideStatus = 'RideStatus';
  static const String keyPaymentDetails = 'PaymentDetails';
  static const String keyConnectionID = 'ConnectionID';
  static const String keySelectCity = 'SelectCity';
  static const String keyTaxiBooking = 'TaxiBooking';
  static const String keyCreatePin = 'CreatePin';
  static const String keyOtp = 'Otp';

  static const String keyCreatePinScreenStatus = 'CreatePinScreenStatus';
  static const String keyLoginScreenStatus = 'LoginScreenStatus';
  static const String keyMasterScreenStatus = 'MasterScreenStatus';

  static const String keySavedUsername = 'SavedUsername';
  static const String keySavedPassword = 'SavedPassword';
  static const String keyRememberMe = 'RememberMe';
  static const String keyToken = 'Token';
  static const String keyOtpStatus = 'OtpStatus';
  static const String keyUserDetails = 'UserDetails';

  static const String keyOnBoarding = 'OnBoarding';
  static const String keySelectMode = 'SelectMode';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static Box get _box => Hive.box(boxName);

  // Save methods
  static Future<void> saveString(String key, String value) async {
    await _box.put(key, value);
  }

  static Future<void> saveBool(String key, bool value) async {
    await _box.put(key, value);
  }

  static Future<void> saveInt(String key, int value) async {
    await _box.put(key, value);
  }

  static Future<void> saveDouble(String key, double value) async {
    await _box.put(key, value);
  }

  // Fetch methods
  static String? fetchString(String key) {
    return _box.get(key);
  }

  static bool? fetchBool(String key) {
    return _box.get(key);
  }

  static int? fetchInt(String key) {
    return _box.get(key);
  }

  static double? fetchDouble(String key) {
    return _box.get(key);
  }

  // Remove methods
  static Future<void> remove(String key) async {
    await _box.delete(key);
  }

  static Future<void> clearAll() async {
    await _box.clear();
  }

  static Future<void> clearAllExceptURL() async {
    final urlValue = _box.get(SharePreferencesKeys.URL);
    bool onBoardingStatus = await HiveStorage.fetchBool(HiveStorage.keyOnBoarding) ?? false;
    bool selectCity = await HiveStorage.fetchBool(HiveStorage.keySelectCity) ?? false;
    bool selectmode = await HiveStorage.fetchBool(HiveStorage.keySelectMode) ?? false;
    await _box.clear();

    if (urlValue != null) {
      await _box.put(SharePreferencesKeys.URL, urlValue);
      await _box.put(HiveStorage.keyOnBoarding, onBoardingStatus);
      await _box.put(HiveStorage.keySelectCity, selectCity);
      await _box.put(HiveStorage.keySelectMode, selectmode);
    }
  }

  static bool containsKey(String key) {
    return _box.containsKey(key);
  }

  /// Deletes all ride-related data only
  static Future<void> deleteRideData() async {
    await init();

    const rideKeys = [
      keyRideId,
      keyDriverId,
      keyRideOtp,
      keyRideStatus,
      keyPaymentDetails,
      SharePreferencesKeys.TAXI_BOOKING,
    ];

    for (final key in rideKeys) {
      if (_box.containsKey(key)) {
        await _box.delete(key);
      }
    }
  }
}
