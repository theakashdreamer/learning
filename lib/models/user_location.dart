import 'package:google_maps_flutter/google_maps_flutter.dart';

enum UserLocationType { Home, Office }

class UserLocation {
  String _name;
  UserLocationType _locationType;
  LatLng _position;
  int _minutesFar;

  // Default constructor
  UserLocation({
    String name = '',
    UserLocationType locationType = UserLocationType.Home,
    LatLng? position,
    int minutesFar = 0,
  })  : _name = name,
        _locationType = locationType,
        _position = position ?? const LatLng(0.0, 0.0),
        _minutesFar = minutesFar;

  // Getters
  String get name => _name;

  UserLocationType get locationType => _locationType;

  LatLng get position => _position;

  int get minutesFar => _minutesFar;

  // Setters
  set name(String value) => _name = value;

  set locationType(UserLocationType value) => _locationType = value;

  set position(LatLng value) => _position = value;

  set minutesFar(int value) => _minutesFar = value;
}
