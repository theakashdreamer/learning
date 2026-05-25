import '../models/ride_cancellation_reason.dart';

class RideCancellationReasonStorage {
  static List<RideCancellationReason>? _rideCancellationReason;

  static Future<void> open() async {
    _rideCancellationReason ??= [];
  }

  static Future<List<RideCancellationReason>> addDetails(
      List<RideCancellationReason> rideCancellationReasonList) async {
    if (_rideCancellationReason == null) await open();
    _rideCancellationReason!.addAll(rideCancellationReasonList);
    return _rideCancellationReason!;
  }

  /// Retrieve the current taxi booking
  static Future<List<RideCancellationReason>?>
      getRideCancellationReason() async {
    return _rideCancellationReason;
  }

  static Future<void> clear() async {
    _rideCancellationReason = null;
  }
}
