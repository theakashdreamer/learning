import 'package:schoolmanagementsystem/loginModules/data/sharePreferencesKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveString(String Keys, String value) async {
    await _prefs.setString(Keys, value);
  }

  Future<String?> getToken(String key) async {
    return _prefs.getString(key);
  }

  Future<void> saveBool(String Keys, bool value) async {
    await _prefs.setBool(Keys, value);
  }

  Future<String?> fetchString(String key) async {
    return _prefs.getString(key);
  }

  Future<bool?> fetchBool(String key) async {
    return _prefs.getBool(key);
  }



  Future<void> setAcId(String Keys, String value) async {
    await _prefs.setString(Keys, value);
  }

  Future<String?> getAcID(String key) async {
    return _prefs.getString(key);
  }

  Future<void> setPartId(String Keys, String value) async {
    await _prefs.setString(Keys, value);
  }

  Future<String?> getPartId(String key) async {
    return _prefs.getString(key);
  }


  Future<void> setSectionId(String Keys, String value) async {
    await _prefs.setString(Keys, value);
  }

  Future<String?> getSectionId(String key) async {
    return _prefs.getString(key);
  }

  Future<void> setManagerId(String Keys, String value) async {
    await _prefs.setString(Keys, value);
  }

  Future<String?> getManagerId(String key) async {
    return _prefs.getString(key);
  }


  // Method to save data to SharedPreferences

  Future<void> clearSharePreferences() async {
    await _prefs.remove(SharePreferencesKeys.OTP);
    await _prefs.remove(SharePreferencesKeys.otpStatus);
    await _prefs.remove(SharePreferencesKeys.createPin);
    await _prefs.remove(SharePreferencesKeys.createPinScreenStatus);
    await _prefs.remove(SharePreferencesKeys.token);
    await _prefs.remove(SharePreferencesKeys.loginScreenStatus);
    await _prefs.remove(SharePreferencesKeys.masterScreenStatus);
  }

  Future<void> clearTaxiBooking() async {
    await _prefs.remove(SharePreferencesKeys.TAXI_BOOKING);
  }

}
