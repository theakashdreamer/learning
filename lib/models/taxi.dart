import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schoolmanagementsystem/models/taxi_type.dart';


class Taxi extends Equatable {
  String? _id;
  String? _title;
  bool? _isAvailable;
  String? _plateNo;
  TaxiType? _taxiType;
  LatLng? _position;
  String? _AmbulanceType_Id;
  String? _AM_TypeName;
  String? _VehicleType_Id;
  String? _Vehicle_Name;
  String? _AmountPerKM;
  String? _DistanceInKM;
  String? _BasicPayOfAmbulance;
  String? _TotalFareAccordingPerKM;

  Taxi();

  Taxi.named({
    required String id,
    required String title,
    required bool isAvailable,
    required String plateNo,
    required TaxiType taxiType,
    required LatLng position,
    AmbulanceType_Id,
    AM_TypeName,
    VehicleType_Id,
    Vehicle_Name,
    AmountPerKM,
    DistanceInKM,
    BasicPayOfAmbulance,
    TotalFareAccordingPerKM,
  })  : _id = id,
        _title = title,
        _isAvailable = isAvailable,
        _plateNo = plateNo,
        _taxiType = taxiType,
        _position = position,
        _AmbulanceType_Id = AmbulanceType_Id.toString(),
        _AM_TypeName = AM_TypeName,
        _VehicleType_Id = VehicleType_Id.toString(),
        _Vehicle_Name = Vehicle_Name,
        _AmountPerKM = AmountPerKM.toString(),
        _DistanceInKM = DistanceInKM.toString(),
        _BasicPayOfAmbulance = BasicPayOfAmbulance.toString(),
        _TotalFareAccordingPerKM = TotalFareAccordingPerKM.toString();

  String get id => _id ?? "";

  set id(String value) => _id = value;

  String get title => _title ?? "";

  set title(String value) => _title = value;

  bool get isAvailable => _isAvailable ?? false;

  set isAvailable(bool value) => _isAvailable = value;

  String get plateNo => _plateNo ?? "";

  set plateNo(String value) => _plateNo = value;

  TaxiType get taxiType => _taxiType ?? TaxiType.Standard1;

  set taxiType(TaxiType value) => _taxiType = value;

  LatLng get position => _position ?? LatLng(0, 0);

  set position(LatLng value) => _position = value;

  String get AmbulanceType_Id => _AmbulanceType_Id ?? "";

  set AmbulanceType_Id(String value) {
    _AmbulanceType_Id = value;
  }

  @override
  List<Object?> get props => [_id, _title, _isAvailable, _plateNo, _taxiType, _position];

  factory Taxi.fromMap(Map<String, dynamic> map) {
    //+
    // +TaxiType taxitype = _taxiTypeFromString(map["taxiType"]);
    var temp;
    return Taxi.named(
      id: map["id"] ?? "",
      title: map["title"] ?? "",
      isAvailable: map["isAvailable"] ?? "",
      plateNo: map["plateNo"] ?? "",
      taxiType: TaxiType.Standard1,
      position: map["LatLng"] != null && map["LatLng"] is Map<String, dynamic>
          ? LatLng(map["LatLng"]["Lat"], map["LatLng"]["Lng"])
          : LatLng(26.8467, 80.9462),
      AmbulanceType_Id: map["AmbulanceType_Id"] ?? "",
      AM_TypeName: map["AM_TypeName"] ?? "",
      VehicleType_Id: map["VehicleType_Id"] ?? "",
      Vehicle_Name: map["Vehicle_Name"] ?? "",
      AmountPerKM: map["AmountPerKM"] ?? "",
      DistanceInKM: map["DistanceInKM"] ?? "",
      BasicPayOfAmbulance: map["BasicPayOfAmbulance"] ?? "",
      TotalFareAccordingPerKM: map["TotalFareAccordingPerKM"] ?? "",
    );
  }

  TaxiType _taxiTypeFromString(String? taxiTypeString) {
    int index = int.tryParse(taxiTypeString!) ?? 1;
    if (index < 0 || index >= TaxiType.values.length) {
      index = 2;
    }
    return TaxiType.values[index];
  }

  String get AM_TypeName => _AM_TypeName ?? "";

  set AM_TypeName(String value) {
    _AM_TypeName = value;
  }

  String get VehicleType_Id => _VehicleType_Id ?? "";

  set VehicleType_Id(String value) {
    _VehicleType_Id = value;
  }

  String get Vehicle_Name => _Vehicle_Name ?? "";

  set Vehicle_Name(String value) {
    _Vehicle_Name = value;
  }

  String get AmountPerKM => _AmountPerKM ?? "";

  set AmountPerKM(String value) {
    _AmountPerKM = value;
  }

  String get DistanceInKM => _DistanceInKM ?? "";

  set DistanceInKM(String value) {
    _DistanceInKM = value;
  }

  String get BasicPayOfAmbulance => _BasicPayOfAmbulance ?? "";

  set BasicPayOfAmbulance(String value) {
    _BasicPayOfAmbulance = value;
  }

  String get TotalFareAccordingPerKM => _TotalFareAccordingPerKM ?? "";

  set TotalFareAccordingPerKM(String value) {
    _TotalFareAccordingPerKM = value;
  }
  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'title': this._title,
      'isAvailable': this._isAvailable,
      'plateNo': this._plateNo,
      'taxiType': this._taxiType.toString(), // If TaxiType is an enum, store its string value
      'LatLng': {
        'Lat': this._position?.latitude,
        'Lng': this._position?.longitude,
      },
      'AmbulanceType_Id': this._AmbulanceType_Id,
      'AM_TypeName': this._AM_TypeName,
      'VehicleType_Id': this._VehicleType_Id,
      'Vehicle_Name': this._Vehicle_Name,
      'AmountPerKM': this._AmountPerKM,
      'DistanceInKM': this._DistanceInKM,
      'BasicPayOfAmbulance': this._BasicPayOfAmbulance,
      'TotalFareAccordingPerKM': this._TotalFareAccordingPerKM,
    };
  }


}