class PinUserRegister {
  String? _Pin;

  String? _User_Mobile;

  String? _Device_Id;

  String? _ResultString;

  String? _Designation_ServerId;

  String? _DeviceID;

  String? _AppVersion;

  String? _Post_Id;

  PinUserRegister();

  PinUserRegister.name(
      this._Pin,
      this._User_Mobile,
      this._Device_Id,
      this._ResultString,
      this._Designation_ServerId,
      this._DeviceID,
      this._AppVersion,
      this._Post_Id);

  factory PinUserRegister.fromMap(dynamic map) {
    return PinUserRegister.name(
      map['Pin']??"",
      map['User_Mobile']??"",
      map['Device_Id'].toString()??"",
      map['ResultString']??"",
      map['Designation_ServerId'].toString()??"",
      map['DeviceID']??"",
      map['AppVersion']??"",
      map['Post_Id']??""
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Pin': _Pin ?? "",
      'User_Mobile': _User_Mobile ?? "",
      'Device_Id': _Device_Id ?? "",
      'ResultString': _ResultString ?? "",
      'Designation_ServerId': _Designation_ServerId ?? "",
      'DeviceID': _DeviceID ?? "",
      'AppVersion': _AppVersion ?? "",
      'Post_Id': _Post_Id ?? "",
    };
  }

  String get AppVersion => _AppVersion??"";

  set AppVersion(String? value) {
    _AppVersion = value??"";
  }

  String get DeviceID => _DeviceID??"";

  set DeviceID(String? value) {
    _DeviceID = value??"";
  }

  String get Designation_ServerId => _Designation_ServerId??"";

  set Designation_ServerId(String? value) {
    _Designation_ServerId = value??"";
  }

  String get ResultString => _ResultString??"";

  set ResultString(String? value) {
    _ResultString = value??"";
  }

  String get Device_Id => _Device_Id??"";

  set Device_Id(String? value) {
    _Device_Id = value??"";
  }

  String get User_Mobile => _User_Mobile??"";

  set User_Mobile(String? value) {
    _User_Mobile = value??"";
  }

  String get Pin => _Pin??"";

  set Pin(String? value) {
    _Pin = value??"";
  }

  String get Post_Id => _Post_Id??"";

  set Post_Id(String value) {
    _Post_Id = value;
  }
}
