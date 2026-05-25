class FireBaseDeviceToken {
  int? _deviceTokenId;
  String? _deviceTokenCode;
  int? _p02AddedBy;
  int? _o12AddedBy;
  int? _appId;
  String? _resultString;
  int? _SA10_UserType_Id;


  FireBaseDeviceToken(); // Named constructor for initializing the object
  FireBaseDeviceToken.name(
      this._deviceTokenId,
      this._deviceTokenCode,
      this._p02AddedBy,
      this._o12AddedBy,
      this._appId,
      this._resultString,
      this._SA10_UserType_Id);

  // Converts the object to JSON
  Map<String, dynamic> toJson() {
    return {
      "DeviceToken_Id": _deviceTokenId ?? 0,
      "DeviceToken_Code": _deviceTokenCode ?? "",
      "P02_AddedBy": _p02AddedBy ?? 0,
      "O12_AddedBy": _o12AddedBy ?? 0,
      "AppId": _appId ?? 0,
      "ResultString": _resultString ?? "",
      "SA10_UserType_Id": _SA10_UserType_Id ?? 0,
    };
  }


  int get SA10_UserType_Id => _SA10_UserType_Id??0;

  set SA10_UserType_Id(int value) {
    _SA10_UserType_Id = value;
  } // Factory method for creating the object from a map
  factory FireBaseDeviceToken.fromMap(Map<String, dynamic> map) {
    return FireBaseDeviceToken.name(
      map['DeviceToken_Id'] ?? 0,
      map['DeviceToken_Code'] ?? '',
      map['P02_AddedBy'] ?? 0,
      map['O12_AddedBy'] ?? 0,
      map['AppId'] ?? 0,
      map['ResultString'] ?? '',
      map['SA10_UserType_Id'] ?? 0,
    );
  }

  // Converts a list of JSON maps into a list of FireBaseDeviceToken objects
  static List<FireBaseDeviceToken> convertJsonToList(List<dynamic> jsonAsString) {
    List<FireBaseDeviceToken> list =
    jsonAsString.map((json) => FireBaseDeviceToken.fromMap(json)).toList();
    return list;
  }

  // Getters and setters
  int get deviceTokenId => _deviceTokenId ?? 0;

  set deviceTokenId(int? value) {
    _deviceTokenId = value ?? 0;
  }

  String get deviceTokenCode => _deviceTokenCode ?? "";

  set deviceTokenCode(String? value) {
    _deviceTokenCode = value ?? "";
  }

  int get p02AddedBy => _p02AddedBy ?? 0;

  set p02AddedBy(int? value) {
    _p02AddedBy = value ?? 0;
  }

  int get o12AddedBy => _o12AddedBy ?? 0;

  set o12AddedBy(int? value) {
    _o12AddedBy = value ?? 0;
  }

  int get appId => _appId ?? 0;

  set appId(int? value) {
    _appId = value ?? 0;
  }

  String get resultString => _resultString ?? "";

  set resultString(String? value) {
    _resultString = value ?? "";
  }
}
