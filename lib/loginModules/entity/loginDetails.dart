


import 'package:schoolmanagementsystem/loginModules/entity/personDetails.dart';

class LoginDetails {
  String? _User_ID;
  String? _Person_ID;
  String? _Person_Name;
  String? _Person_Mobile;
  String? _Designation;
  String? _Designation_ID;
  String? _Deparment_ID;
  String? _Department_Name;
  String? _IsGroupLead;
  String? _NodalOfficer;
  String? _Group_ID;
  String? _Post_ID;

  String? _P02_CurrentIncharge_Id;

  List<PersonDetails>? _lstNodalPerson;
  List<PersonDetails>? _lstGroupPerson;

  LoginDetails();

  LoginDetails.name(
      this._User_ID,
      this._Person_ID,
      this._Person_Name,
      this._Person_Mobile,
      this._Designation,
      this._Designation_ID,
      this._Deparment_ID,
      this._Department_Name,
      this._IsGroupLead,
      this._NodalOfficer,
      this._Group_ID,
      this._Post_ID,
      this._P02_CurrentIncharge_Id,
      this._lstNodalPerson,
      this._lstGroupPerson);

  Map<String, dynamic> toMap() {
    return {
      'User_ID': _User_ID ?? '',
      'Person_ID': _Person_ID ?? '',
      'Person_Name': _Person_Name ?? '',
      'Person_Mobile': _Person_Mobile ?? '',
      'Designation': _Designation ?? '',
      'Designation_ID': _Designation_ID ?? '',
      'Deparment_ID': _Deparment_ID ?? '',
      'Department_Name': _Department_Name ?? '',
      'IsGroupLead': _IsGroupLead ?? '',
      'NodalOfficer': _NodalOfficer ?? '',
      'Group_ID': _Group_ID ?? '',
      'Post_ID': _Post_ID ?? '',
      'P02_CurrentIncharge_Id': _P02_CurrentIncharge_Id ?? '',
      'lstNodalPerson': _lstNodalPerson ?? [],
      'lstGroupPerson': _lstGroupPerson ?? [],
    };
  }

  Map<String, dynamic> toMapWithOutList() {
    return {
      'User_ID': _User_ID ?? '',
      'Person_ID': _Person_ID ?? '',
      'Person_Name': _Person_Name ?? '',
      'Person_Mobile': _Person_Mobile ?? '',
      'Designation': _Designation ?? '',
      'Designation_ID': _Designation_ID ?? '',
      'Deparment_ID': _Deparment_ID ?? '',
      'Department_Name': _Department_Name ?? '',
      'IsGroupLead': _IsGroupLead ?? '',
      'NodalOfficer': _NodalOfficer ?? '',
      'Group_ID': _Group_ID ?? '',
      'Post_ID': _Post_ID ?? '',
      'P02_CurrentIncharge_Id': _P02_CurrentIncharge_Id ?? '',
    };
  }

  factory LoginDetails.fromMap(dynamic map) {
    var temp;
    return LoginDetails.name(
        map['User_ID']?.toString() ?? '',
        map['Person_ID']?.toString() ?? '',
        map['Person_Name']?.toString() ?? '',
        map['Person_Mobile']?.toString() ?? '',
        map['Designation']?.toString() ?? '',
        map['Designation_ID']?.toString() ?? '',
        map['Deparment_ID']?.toString() ?? '',
        map['Department_Name']?.toString() ?? '',
        map['IsGroupLead']?.toString() ?? '',
        map['NodalOfficer']?.toString() ?? '',
        map['Group_ID']?.toString() ?? '',
        map['Post_ID']?.toString() ?? '',
        map['P02_CurrentIncharge_Id']?.toString() ?? '',
        null == (temp = map['lstNodalPerson']) ? [] : (temp is List ? temp.map((map) => PersonDetails.fromMap(map)).toList() : []),
        null == (temp = map['lstGroupPerson']) ? [] : (temp is List ? temp.map((map) => PersonDetails.fromMap(map)).toList() : []));
  }

  List<PersonDetails> get lstGroupPerson => _lstGroupPerson ?? [];

  set lstGroupPerson(List<PersonDetails>? value) {
    _lstGroupPerson = value ?? [];
  }

  List<PersonDetails> get lstNodalPerson => _lstNodalPerson ?? [];

  set lstNodalPerson(List<PersonDetails>? value) {
    _lstNodalPerson = value ?? [];
  }

  String get NodalOfficer => _NodalOfficer ?? '';

  set NodalOfficer(String value) {
    _NodalOfficer = value ?? '';
  }

  String get IsGroupLead => _IsGroupLead ?? '';

  set IsGroupLead(String value) {
    _IsGroupLead = value ?? '';
  }

  String get Department_Name => _Department_Name ?? '';

  set Department_Name(String value) {
    _Department_Name = value ?? '';
  }

  String get Deparment_ID => _Deparment_ID ?? '';

  set Deparment_ID(String value) {
    _Deparment_ID = value ?? '';
  }

  String get Designation_ID => _Designation_ID ?? '';

  set Designation_ID(String value) {
    _Designation_ID = value ?? '';
  }

  String get Designation => _Designation ?? '';

  set Designation(String value) {
    _Designation = value ?? '';
  }

  String get Person_Mobile => _Person_Mobile ?? '';

  set Person_Mobile(String value) {
    _Person_Mobile = value ?? '';
  }

  String get Person_Name => _Person_Name ?? '';

  set Person_Name(String value) {
    _Person_Name = value ?? '';
  }

  String get Person_ID => _Person_ID ?? '';

  set Person_ID(String value) {
    _Person_ID = value ?? '';
  }

  String get User_ID => _User_ID ?? '';

  set User_ID(String value) {
    _User_ID = value ?? '';
  }

  String get P02_CurrentIncharge_Id => _P02_CurrentIncharge_Id ?? '';

  set P02_CurrentIncharge_Id(String? value) {
    _P02_CurrentIncharge_Id = value ?? '';
  }

  String get Group_ID => _Group_ID ?? '';

  set Group_ID(String? value) {
    _Group_ID = value ?? '';
  }

  String get Post_ID => _Post_ID??"0";

  set Post_ID(String? value) {
    _Post_ID = value??"0";
  }
}
