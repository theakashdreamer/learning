
/*
controller: AmbulanceTracking

mode: SaveRatings

QSCollection["SA10_UserType"]

QSCollection["SA10_UserType"] 3 for driver and 4 for passenger

public class Ratings { public int Rating_Id { get; set; } public int Ride_Id { get; set; } public int Passenger_Id { get; set; } public int Driver_Id { get; set; } public int Rating_Points { get; set; } public string ResultString { get; set; } }
*/
class RatingEntity {
  int? _ratingId;
  int? _rideId;
  int? _passengerId;
  int? _driverId;
  double? _ratingPoints;
  String? _resultString;
  String? _description;
  RatingEntity({
    int? ratingId,
    int? rideId,
    int? passengerId,
    int? driverId,
    double? ratingPoints,
    String? resultString,
    String? description,
  }) {
    _ratingId = ratingId;
    _rideId = rideId;
    _passengerId = passengerId;
    _driverId = driverId;
    _ratingPoints = ratingPoints;
    _resultString = resultString;
    _description = description;
  }

  // Getters
  int? get ratingId => _ratingId;
  int? get rideId => _rideId;
  int? get passengerId => _passengerId;
  int? get driverId => _driverId;
  double? get ratingPoints => _ratingPoints;
  String? get resultString => _resultString;
  String? get description => _description;
  // Setters
  set ratingPoints(double? value) => _ratingPoints = value;
  set resultString(String? value) => _resultString = value;
  set description(String? value) => _description = value;
  Map<String, dynamic> toMap() {
    return {
      'Rating_Id': _ratingId,
      'Ride_Id': _rideId,
      'Passenger_Id': _passengerId,
      'Driver_Id': _driverId,
      'Rating_Points': _ratingPoints,
      'ResultString': _resultString,
      'Description': _description,
    };
  }
}


