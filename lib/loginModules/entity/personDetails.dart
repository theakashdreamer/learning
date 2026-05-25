import 'package:schoolmanagementsystem/loginModules/entity/personProfilePhotoDetails.dart';

class PersonDetails {
  String? _id;
  String? _Person_Id;
  String? _Person_Name;
  String? _MobileNo;
  String? _Designation;
  String? _Designation_ID;
  String? _Deparment_ID;
  String? _Department_Name;
  String? _IsProfileCreated;
  String? _IsSynced;
  String? _Class_Name;
  String? _Section_Name;
  String? _Attendance_Datetime;
  String? _Attendance_PresentAbscent;
  String? _Attendance_AbscentReason;
  String? _OrgUnit_Latitude;
  String? _OrgUnit_Longitude;
  String? _RadiusOfGeoFence;
  String? _Profile_FilePath;
  String? _UserType;

  List<PersonProfilePhotoDetails>? _lstProfile;

  PersonDetails();

  PersonDetails.name(
      this._Person_Id,
      this._Person_Name,
      this._MobileNo,
      this._Class_Name,
      this._Section_Name,
      this._IsProfileCreated,
      this._lstProfile);

  PersonDetails.report(
      this._Person_Id,
      this._Person_Name,
      this._MobileNo,
      this._Designation,
      this._Designation_ID,
      this._Deparment_ID,
      this._Department_Name,
      this._IsProfileCreated,
      this._IsSynced,
      this._OrgUnit_Latitude,
      this._OrgUnit_Longitude,
      this._RadiusOfGeoFence,
      this._Attendance_Datetime,
      this._Attendance_PresentAbscent,
      this._Attendance_AbscentReason,
      this._Profile_FilePath,
      this._lstProfile);

  PersonDetails.show(
      this._Person_Id,
      this._Person_Name,
      this._MobileNo,
      this._Class_Name,
      this._Section_Name,
      this._IsProfileCreated,
      this._Profile_FilePath,
      this._IsSynced);

  factory PersonDetails.fromMap(dynamic map) {
    var temp = null;
    return PersonDetails.name(
        map['Person_Id']?.toString() ?? '',
        map['Person_Name']?.toString() ?? '',
        map['MobileNo']?.toString() ?? '',
        map['Class_Name']?.toString() ?? '',
        map['Section_Name']?.toString() ?? '',
        map['IsProfileCreated']?.toString() ?? '',
        null == (temp = map['lstProfile'])
            ? []
            : (temp is List
                ? temp
                    .map((map) => PersonProfilePhotoDetails.fromMap(map))
                    .toList()
                : []));
  }

  factory PersonDetails.fromMapReport(dynamic map) {
    return PersonDetails.show(
        map['Person_Id']?.toString() ?? '',
        map['Person_Name']?.toString() ?? '',
        map['MobileNo']?.toString() ?? '',
        map['Class_Name']?.toString() ?? '',
        map['Section_Name']?.toString() ?? '',
        map['IsProfileCreated']?.toString() ?? '',
        map['Profile_FilePath']?.toString() ?? '',
        map['IsSynced']?.toString() ?? '');
  }

  factory PersonDetails.fromMapShow(dynamic map) {
    return PersonDetails.show(
        map['Person_Id']?.toString() ?? '',
        map['Person_Name']?.toString() ?? '',
        map['MobileNo']?.toString() ?? '',
        map['Class_Name']?.toString() ?? '',
        map['Section_Name']?.toString() ?? '',
        map['IsProfileCreated']?.toString() ?? '',
        map['Profile_FilePath']?.toString() ?? '',
        map['IsSynced']?.toString() ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'Person_Id': _Person_Id ?? '',
      'Person_Name': _Person_Name ?? '',
      'MobileNo': _MobileNo ?? '',
      'Class_Name': _Class_Name ?? '',
      'Section_Name': _Section_Name ?? '',
      'UserType': _UserType ?? '-1',
    };
  }

  static List<PersonDetails> mapToPersonDetailsList(List<dynamic> jsonList) {
    return jsonList.map((json) => PersonDetails.fromMap(json)).toList();
  }

  List<PersonProfilePhotoDetails> get lstProfile => _lstProfile ?? [];

  set lstProfile(List<PersonProfilePhotoDetails>? value) {
    _lstProfile = value;
  }

  String get IsProfileCreated => _IsProfileCreated ?? '';

  set IsProfileCreated(String? value) {
    _IsProfileCreated = value ?? '';
  }

  String get Profile_FilePath => _Profile_FilePath ?? "";

  set Profile_FilePath(String? value) {
    _Profile_FilePath = value ?? "";
  }

  String get Department_Name => _Department_Name ?? '';

  set Department_Name(String? value) {
    _Department_Name = value ?? '';
  }

  String get Deparment_ID => _Deparment_ID ?? '';

  set Deparment_ID(String? value) {
    _Deparment_ID = value ?? '';
  }

  String get Designation_ID => _Designation_ID ?? '';

  set Designation_ID(String? value) {
    _Designation_ID = value ?? '';
  }

  String get Designation => _Designation ?? '';

  set Designation(String? value) {
    _Designation = value ?? '';
  }

  String get MobileNo => _MobileNo ?? '';

  set MobileNo(String? value) {
    _MobileNo = value ?? '';
  }

  String get Person_Name => _Person_Name ?? '';

  set Person_Name(String? value) {
    _Person_Name = value ?? '';
  }

  String get Person_Id => _Person_Id ?? '';

  set Person_ID(String? value) {
    _Person_Id = value ?? '';
  }

  String get IsSynced => _IsSynced ?? 'False';

  set IsSynced(String? value) {
    _IsSynced = value ?? 'False';
  }

  String get id => _id ?? '0';

  set id(String? value) {
    _id = value ?? '0';
  }

  String get Attendance_AbscentReason => _Attendance_AbscentReason ?? '';

  set Attendance_AbscentReason(String? value) {
    _Attendance_AbscentReason = value ?? '';
  }

  String get Attendance_PresentAbscent => _Attendance_PresentAbscent ?? '';

  set Attendance_PresentAbscent(String? value) {
    _Attendance_PresentAbscent = value ?? '';
  }

  String get Attendance_Datetime => _Attendance_Datetime ?? '';

  set Attendance_Datetime(String? value) {
    _Attendance_Datetime = value ?? '';
  }

  String get RadiusOfGeoFence => _RadiusOfGeoFence ?? '';

  set RadiusOfGeoFence(String? value) {
    _RadiusOfGeoFence = value ?? '';
  }

  String get OrgUnit_Longitude => _OrgUnit_Longitude ?? '';

  set OrgUnit_Longitude(String? value) {
    _OrgUnit_Longitude = value;
  }

  String get OrgUnit_Latitude => _OrgUnit_Latitude ?? '';

  set OrgUnit_Latitude(String? value) {
    _OrgUnit_Latitude = value ?? '';
  }

  String get Section_Name => _Section_Name ?? "";

  set Section_Name(String value) {
    _Section_Name = value;
  }

  String get Class_Name => _Class_Name ?? "";

  set Class_Name(String value) {
    _Class_Name = value;
  }

  String get UserType => _UserType ?? "-1";

  set UserType(String? value) {
    _UserType = value ?? "-1";
  }
}
