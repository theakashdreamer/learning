class AmountOfCharges {
  String? _AmountOfCharges_Id;
  String? _AM_TypeId;
  String? _AmountPerKM;
  String? _AmountPerMinutes;
  String? _IsActive;

  AmountOfCharges.name(this._AmountOfCharges_Id, this._AM_TypeId,
      this._AmountPerKM, this._AmountPerMinutes, this._IsActive);

  Map<String, dynamic> toJson() {
    return {
      "AmountOfCharges_Id": this._AmountOfCharges_Id ?? "",
      "AM_TypeId": this._AM_TypeId ?? "",
      "AmountPerKM": this._AmountPerKM ?? "",
      "AmountPerMinutes": this._AmountPerMinutes ?? "",
      "IsActive": this._IsActive ?? "",
    };
  }

  factory AmountOfCharges.fromMap(Map<String, dynamic> map) {
    return AmountOfCharges.name(
      map['AmountOfCharges_Id'] ?? '',
      map['AM_TypeId'] ?? '',
      map['AmountPerKM'] ?? '',
      map['AmountPerMinutes'] ?? '',
      map['IsActive'] ?? '',
    );
  }

  static List<AmountOfCharges> convertJsonToList(List<dynamic> jsonAsString) {
    List<AmountOfCharges> listUserDetails =
        jsonAsString.map((json) => AmountOfCharges.fromMap(json)).toList();
    return listUserDetails;
  }

  String get IsActive => _IsActive ?? "";

  set IsActive(String? value) {
    _IsActive = value ?? "";
  }

  String get AmountPerMinutes => _AmountPerMinutes ?? "";

  set AmountPerMinutes(String? value) {
    _AmountPerMinutes = value ?? "";
  }

  String get AmountPerKM => _AmountPerKM ?? "";

  set AmountPerKM(String? value) {
    _AmountPerKM = value ?? "";
  }

  String get AM_TypeId => _AM_TypeId ?? "";

  set AM_TypeId(String? value) {
    _AM_TypeId = value ?? "";
  }

  String get AmountOfCharges_Id => _AmountOfCharges_Id ?? "";

  set AmountOfCharges_Id(String? value) {
    _AmountOfCharges_Id = value ?? "";
  }
}
