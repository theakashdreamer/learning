import 'dart:core';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class OTP {
  String? _User_LoginName;

  String? _User_Password;

  String? _OTP_Number;

  String? _OTP_Status;

  String? _Device_Id;

  String? _Person_ServerId;

  String? _Designation_ServerId;

  String? _SenderID;

  String? _Designation_Name;

  String? _User_Mobile;

  String? _ResultString;

  String? _SA10_UserType_Id;

  String? _HashCodeString;

  String? _UserType;
  String? _PRD_URL;
  String? _UserCategory;
  String? _Panchayat_ID;

  String? _Post_Id;

  OTP();

  OTP.name(
    this._User_LoginName,
    this._User_Password,
    this._OTP_Number,
    this._OTP_Status,
    this._Device_Id,
    this._Person_ServerId,
    this._Designation_ServerId,
    this._SenderID,
    this._Designation_Name,
    this._User_Mobile,
    this._ResultString,
    this._SA10_UserType_Id,
    this._HashCodeString,
    this._Post_Id,
    this._UserType,
    this._PRD_URL,
    this._UserCategory,
    this._Panchayat_ID,
  );

  factory OTP.fromMap(dynamic map) {
    return OTP.name(
      map['User_LoginName'] ?? '',
      map['User_Password'] ?? '',
      map['OTP_Number'] ?? '',
      map['OTP_Status'] ?? '',
      map['Device_Id'].toString() ?? '',
      map['Person_ServerId'].toString() ?? '',
      map['Designation_ServerId'].toString() ?? '',
      map['SenderID'] ?? '',
      map['Designation_Name'] ?? '',
      map['User_Mobile'] ?? '',
      map['ResultString'] ?? '',
      map['SA10_UserType_Id'].toString() ?? '',
      map['HashCodeString'] ?? '',
      map['Post_Id'] ?? '',
      map['UserType'] ?? '',
      map['PRD_URL'] ?? '',
      map['UserCategory'] ?? '',
      map['Panchayat_ID'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'User_LoginName': _User_LoginName ?? '',
      'User_Password': _User_Password ?? '',
      'OTP_Number': _OTP_Number ?? '',
      'OTP_Status': _OTP_Status ?? '',
      'Device_Id': _Device_Id ?? '',
      'Person_ServerId': _Person_ServerId ?? '',
      'Designation_ServerId': _Designation_ServerId ?? '',
      'SenderID': _SenderID ?? '',
      'Designation_Name': _Designation_Name ?? '',
      'User_Mobile': _User_Mobile ?? '',
      'ResultString': _ResultString ?? '',
      'SA10_UserType_Id': _SA10_UserType_Id ?? '',
      'HashCodeString': _HashCodeString ?? '',
      'Post_Id': _Post_Id ?? '',
      'UserType': _UserType ?? '',
      'PRD_URL': _PRD_URL ?? '',
      'UserCategory': _UserCategory ?? '',
      'Panchayat_ID': _Panchayat_ID ?? '',
    };
  }

  String get HashCodeString => _HashCodeString ?? '';

  set HashCodeString(String? value) {
    _HashCodeString = value ?? '';
  }

  String get SA10_UserType_Id => _SA10_UserType_Id ?? '';

  set SA10_UserType_Id(String? value) {
    _SA10_UserType_Id = value ?? '';
  }

  String get ResultString => _ResultString ?? '';

  set ResultString(String? value) {
    _ResultString = value ?? '';
  }

  String get User_Mobile => _User_Mobile ?? '';

  set User_Mobile(String? value) {
    _User_Mobile = value ?? '';
  }

  String get Designation_Name => _Designation_Name ?? '';

  set Designation_Name(String? value) {
    _Designation_Name = value ?? '';
  }

  String get SenderID => _SenderID ?? '';

  set SenderID(String? value) {
    _SenderID = value ?? '';
  }

  String get Designation_ServerId => _Designation_ServerId ?? '';

  set Designation_ServerId(String? value) {
    _Designation_ServerId = value ?? '';
  }

  String get Person_ServerId => _Person_ServerId ?? '';

  set Person_ServerId(String? value) {
    _Person_ServerId = value ?? '';
  }

  String get Device_Id => _Device_Id ?? '';

  set Device_Id(String? value) {
    _Device_Id = value ?? '';
  }

  String get OTP_Status => _OTP_Status ?? '';

  set OTP_Status(String? value) {
    _OTP_Status = value ?? '';
  }

  String get OTP_Number => _OTP_Number ?? '';

  set OTP_Number(String? value) {
    _OTP_Number = value ?? '';
  }

  String get User_Password => _User_Password ?? '';

  set User_Password(String? value) {
    _User_Password = value ?? '';
  }

  String get User_LoginName => _User_LoginName ?? '';

  set User_LoginName(String? value) {
    _User_LoginName = value ?? '';
  }

  Map<String, dynamic> toJsonUserMobileNumber() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['User_Mobile'] = _User_Mobile ?? '800900994';
    data['UserType'] = _SA10_UserType_Id ?? '1';
    return data;
  }

  String get Post_Id => _Post_Id ?? "";

  set Post_Id(String value) {
    _Post_Id = value;
  }

  String get Panchayat_ID => _Panchayat_ID ?? "";

  set Panchayat_ID(String? value) {
    _Panchayat_ID = value ?? "";
  }

  String get UserCategory => _UserCategory ?? "";

  set UserCategory(String? value) {
    _UserCategory = value ?? "";
  }

  String get PRD_URL => _PRD_URL ?? "";

  set PRD_URL(String? value) {
    _PRD_URL = value ?? "";
  }

  String get UserType => _UserType ?? "";

  set UserType(String? value) {
    _UserType = value ?? "";
  }
}
