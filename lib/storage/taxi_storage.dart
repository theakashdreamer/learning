import '../models/taxi.dart';

class Taxistorage{
  static List<Taxi>? _taxi;

  static Future<void> open() async {
    _taxi ??= [];
  }

  static Future<List<Taxi>> addDetails(
      List<Taxi> taxi) async {
    if (_taxi == null) await open();
    _taxi!.addAll(taxi);
    return _taxi!;
  }

  /// Retrieve the current taxi booking
  static Future<List<Taxi>?> getTaxis() async {
    return _taxi;
  }

  static Future<void> clear() async {
    _taxi = null;
  }
}