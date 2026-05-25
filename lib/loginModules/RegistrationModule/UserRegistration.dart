class UserRegistration {
  String? _id;
  String? _Person_Id;
  String? _Person_FirstName;
  String? _Person_MiddleName;
  String? _Person_LastName;
  String? _Person_Mobile1;
  String? _Person_Mobile2;
  String? _Person_Mobile3;
  String? _Person_Email_Personal;
  String? _P01_Gender;
  String? _Person_DOB;
  String? _Person_Age;
  String? _Person_AgeAsOnDate;
  String? _Person_IsActive;
  String? _Person_MotherName;
  String? _Person_HeightInCM;
  String? _Person_WeightInKG;
  String? _Person_FatherName;
  String? _P02_AddedBy;
  String? _O12_AddedBy;
  String? _AddedOn;
  String? _UpdatedOn;
  String? _User_LoginName;
  String? _User_Password;
  String? _Lattitude;
  String? _Longitude;
  String? _SA08_App_Id;
  String? _AppVersion;
  String? _SyncedOn;
  String? _NITZTime;
  String? _GPSTime;
  String? _NTPServerTime;
  String? _LocalTime;
  String? _AppInstance_Id;
  String? _RemoteServerId;
  String? _ResultString;
  String? _IS_Synced;
  String? _OTP_Number;

  UserRegistration();

  UserRegistration.name(
      this._id,
      this._Person_Id,
      this._Person_FirstName,
      this._Person_MiddleName,
      this._Person_LastName,
      this._Person_Mobile1,
      this._Person_Mobile2,
      this._Person_Mobile3,
      this._Person_Email_Personal,
      this._P01_Gender,
      this._Person_DOB,
      this._Person_Age,
      this._Person_AgeAsOnDate,
      this._Person_IsActive,
      this._Person_MotherName,
      this._Person_HeightInCM,
      this._Person_WeightInKG,
      this._Person_FatherName,
      this._P02_AddedBy,
      this._O12_AddedBy,
      this._AddedOn,
      this._UpdatedOn,
      this._User_LoginName,
      this._User_Password,
      this._Lattitude,
      this._Longitude,
      this._SA08_App_Id,
      this._AppVersion,
      this._SyncedOn,
      this._NITZTime,
      this._GPSTime,
      this._NTPServerTime,
      this._LocalTime,
      this._AppInstance_Id,
      this._RemoteServerId,
      this._ResultString,
      this._IS_Synced,
      this._OTP_Number);

  Map<String, dynamic> toMap() {
    return {
      'Person_Id': _Person_Id ?? '',
      'Person_FirstName': _Person_FirstName ?? '',
      'Person_MiddleName': _Person_MiddleName ?? '',
      'Person_LastName': _Person_LastName ?? '',
      'Person_Mobile1': _Person_Mobile1 ?? '',
      'Person_Mobile2': _Person_Mobile2 ?? '',
      'Person_Mobile3': _Person_Mobile3 ?? '',
      'Person_Email_Personal': _Person_Email_Personal ?? '',
      'P01_Gender': _P01_Gender ?? '',
      'Person_DOB': _Person_DOB ?? '',
      'Person_Age': _Person_Age ?? '',
      'Person_AgeAsOnDate': _Person_AgeAsOnDate ?? '',
      'Person_IsActive': _Person_IsActive ?? '',
      'Person_MotherName': _Person_MotherName ?? '',
      'Person_HeightInCM': _Person_HeightInCM ?? '',
      'Person_WeightInKG': _Person_WeightInKG ?? '',
      'Person_FatherName': _Person_FatherName ?? '',
      'P02_AddedBy': _P02_AddedBy ?? '',
      'O12_AddedBy': _O12_AddedBy ?? '',
      'AddedOn': _AddedOn ?? '',
      'UpdatedOn': _UpdatedOn ?? '',
      'User_LoginName': _User_LoginName ?? '',
      'User_Password': _User_Password ?? '',
      'Lattitude': _Lattitude ?? '',
      'Longitude': _Longitude ?? '',
      'SA08_App_Id': _SA08_App_Id ?? '',
      'AppVersion': _AppVersion ?? '',
      'SyncedOn': _SyncedOn ?? '',
      'NITZTime': _NITZTime ?? '',
      'GPSTime': _GPSTime ?? '',
      'NTPServerTime': _NTPServerTime ?? '',
      'LocalTime': _LocalTime ?? '',
      'AppInstance_Id': _AppInstance_Id ?? '',
      'RemoteServerId': _RemoteServerId ?? '',
      'ResultString': _ResultString ?? '',
      'IS_Synced': _IS_Synced ?? '',
      'OTP_Number':_OTP_Number??'',
    };
  }

  Map<String, dynamic> toMapForSaving() {
    return {
      'id': _id ?? '',
      'Person_Id': _Person_Id ?? '',
      'Person_FirstName': _Person_FirstName ?? '',
      'Person_MiddleName': _Person_MiddleName ?? '',
      'Person_LastName': _Person_LastName ?? '',
      'Person_Mobile1': _Person_Mobile1 ?? '',
      'Person_Mobile2': _Person_Mobile2 ?? '',
      'Person_Mobile3': _Person_Mobile3 ?? '',
      'Person_Email_Personal': _Person_Email_Personal ?? '',
      'P01_Gender': _P01_Gender ?? '',
      'Person_DOB': _Person_DOB ?? '',
      'Person_Age': _Person_Age ?? '',
      'Person_AgeAsOnDate': _Person_AgeAsOnDate ?? '',
      'Person_IsActive': _Person_IsActive ?? '',
      'Person_MotherName': _Person_MotherName ?? '',
      'Person_HeightInCM': _Person_HeightInCM ?? '',
      'Person_WeightInKG': _Person_WeightInKG ?? '',
      'Person_FatherName': _Person_FatherName ?? '',
      'P02_AddedBy': _P02_AddedBy ?? '',
      'O12_AddedBy': _O12_AddedBy ?? '',
      'AddedOn': _AddedOn ?? '',
      'UpdatedOn': _UpdatedOn ?? '',
      'User_LoginName': _User_LoginName ?? '',
      'User_Password': _User_Password ?? '',
      'Lattitude': _Lattitude ?? '',
      'Longitude': _Longitude ?? '',
      'SA08_App_Id': _SA08_App_Id ?? '',
      'AppVersion': _AppVersion ?? '',
      'SyncedOn': _SyncedOn ?? '',
      'NITZTime': _NITZTime ?? '',
      'GPSTime': _GPSTime ?? '',
      'NTPServerTime': _NTPServerTime ?? '',
      'LocalTime': _LocalTime ?? '',
      'AppInstance_Id': _AppInstance_Id ?? '',
      'RemoteServerId': _RemoteServerId ?? '',
      'ResultString': _ResultString ?? '',
      'IS_Synced': _IS_Synced ?? '',
      'OTP_Number':_OTP_Number??'',
    };
  }

  factory UserRegistration.fromMap(dynamic map) {
    var temp2 = null;
    return UserRegistration.name(
      map['id'].toString() ?? '',
      map['Person_Id'] ?? '',
      map['Person_FirstName'] ?? '',
      map['Person_MiddleName'] ?? '',
      map['Person_LastName'] ?? '',
      map['Person_Mobile1'] ?? '',
      map['Person_Mobile2'] ?? '',
      map['Person_Mobile3'] ?? '',
      map['Person_Email_Personal'] ?? '',
      map['P01_Gender'] ?? '',
      map['Person_DOB'] ?? '',
      map['Person_Age'] ?? '',
      map['Person_AgeAsOnDate'] ?? '',
      map['Person_IsActive'] ?? '',
      map['Person_MotherName'] ?? '',
      map['Person_HeightInCM'] ?? '',
      map['Person_WeightInKG'] ?? '',
      map['Person_FatherName'] ?? '',
      map['P02_AddedBy'] ?? '',
      map['O12_AddedBy'] ?? '',
      map['AddedOn'] ?? '',
      map['UpdatedOn'] ?? '',
      map['User_LoginName'] ?? '',
      map['User_Password'] ?? '',
      map['Lattitude'] ?? '',
      map['Longitude'] ?? '',
      map['SA08_App_Id'] ?? '',
      map['AppVersion'] ?? '',
      map['SyncedOn'] ?? '',
      map['NITZTime'] ?? '',
      map['GPSTime'] ?? '',
      map['NTPServerTime'] ?? '',
      map['LocalTime'] ?? '',
      map['AppInstance_Id'] ?? '',
      map['RemoteServerId'] ?? '',
      map['ResultString'] ?? '',
      map['IS_Synced'] ?? '',
      map['OTP_Number']??'',
    );
  }

  static List<Map<String, dynamic>> listOfToMap(
      List<UserRegistration> jsonMap) {
    return jsonMap.map((map) => map.toMapForSaving()).toList();
  }

  String get IS_Synced => _IS_Synced ?? "";

  set IS_Synced(String? value) {
    _IS_Synced = value ?? "";
  }

  String get ResultString => _ResultString ?? "";

  set ResultString(String? value) {
    _ResultString = value ?? "";
  }

  String get RemoteServerId => _RemoteServerId ?? "";

  set RemoteServerId(String value) {
    _RemoteServerId = value ?? "";
  }

  String get AppInstance_Id => _AppInstance_Id ?? "";

  set AppInstance_Id(String? value) {
    _AppInstance_Id = value ?? "";
  }

  String get LocalTime => _LocalTime ?? "";

  set LocalTime(String? value) {
    _LocalTime = value ?? "";
  }

  String get NTPServerTime => _NTPServerTime ?? "";

  set NTPServerTime(String? value) {
    _NTPServerTime = value ?? "";
  }

  String get GPSTime => _GPSTime ?? "";

  set GPSTime(String? value) {
    _GPSTime = value ?? "";
  }

  String get NITZTime => _NITZTime ?? "";

  set NITZTime(String? value) {
    _NITZTime = value ?? "";
  }

  String get SyncedOn => _SyncedOn ?? "";

  set SyncedOn(String? value) {
    _SyncedOn = value ?? "";
  }

  String get AppVersion => _AppVersion ?? "";

  set AppVersion(String? value) {
    _AppVersion = value ?? "";
  }

  String get SA08_App_Id => _SA08_App_Id ?? "";

  set SA08_App_Id(String? value) {
    _SA08_App_Id = value ?? "";
  }

  String get Longitude => _Longitude ?? "";

  set Longitude(String? value) {
    _Longitude = value ?? "";
  }

  String get Lattitude => _Lattitude ?? "";

  set Lattitude(String? value) {
    _Lattitude = value ?? "";
  }

  String get User_Password => _User_Password ?? "";

  set User_Password(String? value) {
    _User_Password = value ?? "";
  }

  String get User_LoginName => _User_LoginName ?? "";

  set User_LoginName(String? value) {
    _User_LoginName = value ?? "";
  }

  String get UpdatedOn => _UpdatedOn ?? "";

  set UpdatedOn(String? value) {
    _UpdatedOn = value ?? "";
  }

  String get AddedOn => _AddedOn ?? "";

  set AddedOn(String? value) {
    _AddedOn = value ?? "";
  }

  String get O12_AddedBy => _O12_AddedBy ?? "";

  set O12_AddedBy(String? value) {
    _O12_AddedBy = value ?? "";
  }

  String get P02_AddedBy => _P02_AddedBy ?? "";

  set P02_AddedBy(String? value) {
    _P02_AddedBy = value ?? "";
  }

  String get Person_FatherName => _Person_FatherName ?? "";

  set Person_FatherName(String? value) {
    _Person_FatherName = value ?? "";
  }

  String get Person_WeightInKG => _Person_WeightInKG ?? "";

  set Person_WeightInKG(String? value) {
    _Person_WeightInKG = value ?? "";
  }

  String get Person_HeightInCM => _Person_HeightInCM ?? "";

  set Person_HeightInCM(String? value) {
    _Person_HeightInCM = value ?? "";
  }

  String get Person_MotherName => _Person_MotherName ?? "";

  set Person_MotherName(String? value) {
    _Person_MotherName = value ?? "";
  }

  String get Person_IsActive => _Person_IsActive ?? "";

  set Person_IsActive(String? value) {
    _Person_IsActive = value ?? "";
  }

  String get Person_AgeAsOnDate => _Person_AgeAsOnDate ?? "";

  set Person_AgeAsOnDate(String? value) {
    _Person_AgeAsOnDate = value ?? "";
  }

  String get Person_Age => _Person_Age ?? "";

  set Person_Age(String? value) {
    _Person_Age = value ?? "";
  }

  String get Person_DOB => _Person_DOB ?? "";

  set Person_DOB(String? value) {
    _Person_DOB = value ?? "";
  }

  String get P01_Gender => _P01_Gender ?? "";

  set P01_Gender(String? value) {
    _P01_Gender = value ?? "";
  }

  String get Person_Email_Personal => _Person_Email_Personal ?? "";

  set Person_Email_Personal(String? value) {
    _Person_Email_Personal = value ?? "";
  }

  String get Person_Mobile3 => _Person_Mobile3 ?? "";

  set Person_Mobile3(String? value) {
    _Person_Mobile3 = value ?? "";
  }

  String get Person_Mobile2 => _Person_Mobile2 ?? "";

  set Person_Mobile2(String? value) {
    _Person_Mobile2 = value ?? "";
  }

  String get Person_Mobile1 => _Person_Mobile1 ?? "";

  set Person_Mobile1(String? value) {
    _Person_Mobile1 = value ?? "";
  }

  String get Person_LastName => _Person_LastName ?? "";

  set Person_LastName(String? value) {
    _Person_LastName = value ?? "";
  }

  String get Person_MiddleName => _Person_MiddleName ?? "";

  set Person_MiddleName(String? value) {
    _Person_MiddleName = value ?? "";
  }

  String get Person_FirstName => _Person_FirstName ?? "";

  set Person_FirstName(String? value) {
    _Person_FirstName = value ?? "";
  }

  String get Person_Id => _Person_Id ?? "";

  set Person_Id(String? value) {
    _Person_Id = value ?? "";
  }

  String get id => _id ?? "";

  set id(String? value) {
    _id = value ?? "";
  }

  String get OTP_Number => _OTP_Number??"";

  set OTP_Number(String? value) {
    _OTP_Number = value??"";
  }
}
