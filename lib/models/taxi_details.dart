import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:equatable/equatable.dart';

import 'google_location.dart';

class TaxiDetails extends Equatable {
  String? _AmbulanceId;
  String? _Facility_Id;
  String? _Facility_Name;
  String? _AmbulanceType_Id;
  String? _AM_TypeName;
  String? _AM_CrewMembersize;
  String? _AmbulanceCategory;
  String? _AmbCat_Name;
  String? _AmbulanceLinking;
  String? _AmbRegistrationNo;
  TaxiDetails();
  TaxiDetails.name(
      this._AmbulanceId,
      this._Facility_Id,
      this._Facility_Name,
      this._AmbulanceType_Id,
      this._AM_TypeName,
      this._AM_CrewMembersize,
      this._AmbulanceCategory,
      this._AmbCat_Name,
      this._AmbulanceLinking,
      this._AmbRegistrationNo);

  @override
  List<Object?> get props => [
        _AmbulanceId,
        _Facility_Id,
        _Facility_Name,
        _AmbulanceType_Id,
        _AM_TypeName,
        _AM_CrewMembersize,
        _AmbulanceCategory,
        _AmbCat_Name,
        _AmbulanceLinking,
        _AmbRegistrationNo
      ];

  Map<String, dynamic> toMap() {
    return {
      'AmbulanceId': this._AmbulanceId,
      'Facility_Id': this._Facility_Id,
      'Facility_Name': this._Facility_Name,
      'AmbulanceType_Id': this._AmbulanceType_Id,
      'AM_TypeName': this._AM_TypeName,
      'AM_CrewMembersize': this._AM_CrewMembersize,
      'AmbulanceCategory': this._AmbulanceCategory,
      'AmbCat_Name': this._AmbCat_Name,
      'AmbulanceLinking': this._AmbulanceLinking,
      'AmbRegistrationNo': this._AmbRegistrationNo,
    };
  }

  factory TaxiDetails.fromMap(Map<String, dynamic> map) {
    return TaxiDetails.name(
      map['AmbulanceId'] ?? "",
      map['Facility_Id'] ?? "",
      map['Facility_Name'] ?? "",
      map['AmbulanceType_Id'] ?? "",
      map['AM_TypeName'] ?? "",
      map['AM_CrewMembersize'] ?? "",
      map['AmbulanceCategory'] ?? "",
      map['AmbCat_Name'] ?? "",
      map['AmbulanceLinking'] ?? "",
      map['AmbRegistrationNo'] ?? "",
    );
  }

  String get AmbRegistrationNo => _AmbRegistrationNo ?? "";

  set AmbRegistrationNo(String? value) {
    _AmbRegistrationNo = value ?? "";
  }

  String get AmbulanceLinking => _AmbulanceLinking ?? "";

  set AmbulanceLinking(String? value) {
    _AmbulanceLinking = value ?? "";
  }

  String get AmbCat_Name => _AmbCat_Name ?? "";

  set AmbCat_Name(String? value) {
    _AmbCat_Name = value ?? "";
  }

  String get AmbulanceCategory => _AmbulanceCategory ?? "";

  set AmbulanceCategory(String? value) {
    _AmbulanceCategory = value ?? "";
  }

  String get AM_CrewMembersize => _AM_CrewMembersize ?? "";

  set AM_CrewMembersize(String? value) {
    _AM_CrewMembersize = value ?? "";
  }

  String get AM_TypeName => _AM_TypeName ?? "";

  set AM_TypeName(String? value) {
    _AM_TypeName = value ?? "";
  }

  String get AmbulanceType_Id => _AmbulanceType_Id ?? "";

  set AmbulanceType_Id(String? value) {
    _AmbulanceType_Id = value ?? "";
  }

  String get Facility_Name => _Facility_Name ?? "";

  set Facility_Name(String? value) {
    _Facility_Name = value ?? "";
  }

  String get Facility_Id => _Facility_Id ?? "";

  set Facility_Id(String? value) {
    _Facility_Id = value ?? "";
  }

  String get AmbulanceId => _AmbulanceId ?? "";

  set AmbulanceId(String? value) {
    _AmbulanceId = value ?? "";
  }
}
