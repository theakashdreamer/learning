import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleLocation {
  String _placeId;
  LatLng _position;
  String _areaDetails;

  // Named constructor with default values

  // Default constructor
  GoogleLocation({
    required String placeId,
    required LatLng position,
    required String areaDetails,
  })  : _placeId = placeId,
        _position = position,
        _areaDetails = areaDetails;

  GoogleLocation.named({
    String placeId = '',
    LatLng position = const LatLng(0.0, 0.0),
    String areaDetails = '',
  })  : _placeId = placeId,
        _position = position,
        _areaDetails = areaDetails;

  // Getters and setters
  String get placeId => _placeId;

  set placeId(String value) => _placeId = value;

  LatLng get position => _position;

  set position(LatLng value) => _position = value;

  String get areaDetails => _areaDetails;

  set areaDetails(String value) => _areaDetails = value;

  factory GoogleLocation.fromJson(Map<String, dynamic> json) {
    double latitude = json.containsKey('position')
        ? json['position'][0] != null && json['position'][0] is double
            ? json['position'][0]
            : double.tryParse(json['position'][0]?.toString() ?? '') ?? 0.0
        : 0.0;

    double longitude = json.containsKey('position')
        ? json['position'][1] != null && json['position'][1] is double
            ? json['position'][1]
            : double.tryParse(json['position'][1]?.toString() ?? '') ?? 0.0
        : 0.0;
    return GoogleLocation(
      placeId: json['placeId'] as String? ?? '',
      position: LatLng(
        latitude,
        longitude,
      ),
      areaDetails: json['areaDetails'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'placeId': this._placeId,
      'position': this._position,
      /* 'latitude': this._position.latitude,
        'longitude': this._position.longitude,
      },*/
      'areaDetails': this._areaDetails,
    };
  }

  GoogleLocation copyWith({LatLng? position}) {
    return GoogleLocation(
      placeId: placeId,
      areaDetails: areaDetails,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toJson() => toMap();
}
