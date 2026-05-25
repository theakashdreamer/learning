class UpdateActivity {
  String? _apkFileName;
  String? _apkUrl;
  String? _appDescription;
  String? _appName;
  String? _autoUpdate;
  String? _deviceUpdateRequestID;
  String? _forceUpdate;
  String? _isUpdateAvailable;
  String? _packageName;
  String? _updateMessage;
  String? _versionCode;
  String? _versionName;
  String? _appDeviceID;
  String? _appUserID;
  String? _SA05_UserID;
  String? _AppID;

  UpdateActivity();

  UpdateActivity.name(
      this._apkFileName,
      this._apkUrl,
      this._appDescription,
      this._appName,
      this._autoUpdate,
      this._deviceUpdateRequestID,
      this._forceUpdate,
      this._isUpdateAvailable,
      this._packageName,
      this._updateMessage,
      this._versionCode,
      this._versionName,
      this._appDeviceID,
      this._appUserID,
      this._SA05_UserID,
      this._AppID);

  factory UpdateActivity.fromMap(dynamic map) {
    return UpdateActivity.name(
        map['apkFileName'] ??"",
        map['apkUrl'] ??"",
        map['appDescription'] ??"",
        map['appName']  ??"",
        map['autoUpdate'] ??"",
        map['deviceUpdateRequestID'] ??"",
        map['forceUpdate'] ??"",
        map['isUpdateAvailable'] ??"",
        map['packageName'] ??"",
        map['updateMessage'] ??"",
        map['versionCode'] ??"",
        map['versionName'] ??"",
        map['appDeviceID']??"",
        map['appUserID'] ??"",
        map['SA05_UserID'].toString() ,
        map['AppID'].toString());
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['apkFileName'] = _apkFileName ?? "";
    data['apkUrl'] = _apkUrl ?? "";
    data['appDescription'] = _appDescription ?? "";
    data['appName'] = _appName ?? "";
    data['autoUpdate'] = _autoUpdate;
    data['deviceUpdateRequestID'] = _deviceUpdateRequestID ?? "";
    data['forceUpdate'] = _forceUpdate ?? "";
    data['isUpdateAvailable'] = _isUpdateAvailable ?? "";
    data['packageName'] = _packageName ?? "";
    data['updateMessage'] = _updateMessage ?? "";
    data['versionCode'] = _versionCode ?? "";
    data['versionName'] = _versionName ?? "";
    data['appDeviceID'] = _appDeviceID ?? "";
    data['appUserID'] = _appUserID ?? "";
    data['SA05_UserID'] = _SA05_UserID ?? "";
    data['AppID'] = _AppID ?? "";
    return data;
  }

  static List<Map<String, dynamic>> listToMap(List<UpdateActivity> surveyList) {
    List<Map<String, dynamic>> maps = [];
    for (var survey in surveyList) {
      maps.add(survey.toMap());
    }
    return maps;
  }

  String get AppID => _AppID ?? "";

  set AppID(String? value) {
    _AppID = value ?? "";
  }

  String get SA05_UserID => _SA05_UserID ?? "";

  set SA05_UserID(String? value) {
    _SA05_UserID = value ?? "";
  }

  String get appUserID => _appUserID ?? "";

  set appUserID(String? value) {
    _appUserID = value ?? "";
  }

  String get appDeviceID => _appDeviceID ?? "";

  set appDeviceID(String? value) {
    _appDeviceID = value ?? "";
  }

  String get versionName => _versionName ?? "";

  set versionName(String? value) {
    _versionName = value ?? "";
  }

  String get versionCode => _versionCode ?? "";

  set versionCode(String? value) {
    _versionCode = value ?? "";
  }

  String get updateMessage => _updateMessage ?? "";

  set updateMessage(String? value) {
    _updateMessage = value ?? "";
  }

  String get packageName => _packageName ?? "";

  set packageName(String? value) {
    _packageName = value ?? "";
  }

  String get isUpdateAvailable => _isUpdateAvailable ?? "";

  set isUpdateAvailable(String? value) {
    _isUpdateAvailable = value ?? "";
  }

  String get forceUpdate => _forceUpdate ?? "";

  set forceUpdate(String? value) {
    _forceUpdate = value ?? "";
  }

  String get deviceUpdateRequestID => _deviceUpdateRequestID ?? "";

  set deviceUpdateRequestID(String? value) {
    _deviceUpdateRequestID = value ?? "";
  }

  String get autoUpdate => _autoUpdate ?? "";

  set autoUpdate(String? value) {
    _autoUpdate = value ?? "";
  }

  String get appName => _appName ?? "";

  set appName(String? value) {
    _appName = value ?? "";
  }

  String get appDescription => _appDescription ?? "";

  set appDescription(String? value) {
    _appDescription = value ?? "";
  }

  String get apkUrl => _apkUrl ?? "";

  set apkUrl(String? value) {
    _apkUrl = value ?? "";
  }

  String get apkFileName => _apkFileName ?? "";

  set apkFileName(String? value) {
    _apkFileName = value ?? "";
  }
}
