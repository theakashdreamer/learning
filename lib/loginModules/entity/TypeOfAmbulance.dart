class TypeOfAmbulance {
  String? _AM_TypeId;
  String? _AM_TypeName;
  String? _AM_TypeDescription;
  String? _AM_TypeAddedOn2;
  String? _AM_TypeIsActive;
  TypeOfAmbulance();
  TypeOfAmbulance.name(this._AM_TypeId, this._AM_TypeName,
      this._AM_TypeDescription, this._AM_TypeAddedOn2, this._AM_TypeIsActive);

  Map<String, dynamic> toMap() {
    return {
      'AM_TypeId': _AM_TypeId ?? "",
      'AM_TypeName': _AM_TypeName ?? "",
      'AM_TypeDescription': _AM_TypeDescription ?? "",
      'AM_TypeAddedOn2': _AM_TypeAddedOn2 ?? "",
      'AM_TypeIsActive': _AM_TypeIsActive ?? "",
    };
  }

  factory TypeOfAmbulance.fromMap(Map<String, dynamic> map) {
    return TypeOfAmbulance.name(
      map['AM_TypeId'] ?? '',
      map['AM_TypeName'] ?? '',
      map['AM_TypeDescription'] ?? '',
      map['AM_TypeAddedOn2'] ?? '',
      map['AM_TypeIsActive'] ?? '',
    );
  }

  static List<TypeOfAmbulance> convertJsonToList(List<dynamic> jsonAsString) {
    List<TypeOfAmbulance> listUserDetails =
        jsonAsString.map((json) => TypeOfAmbulance.fromMap(json)).toList();
    return listUserDetails;
  }

  String get AM_TypeIsActive => _AM_TypeIsActive??"";

  set AM_TypeIsActive(String? value) {
    _AM_TypeIsActive = value??"";
  }

  String get AM_TypeAddedOn2 => _AM_TypeAddedOn2??"";

  set AM_TypeAddedOn2(String? value) {
    _AM_TypeAddedOn2 = value??"";
  }

  String get AM_TypeDescription => _AM_TypeDescription??"";

  set AM_TypeDescription(String? value) {
    _AM_TypeDescription = value??"";
  }

  String get AM_TypeName => _AM_TypeName??"";

  set AM_TypeName(String? value) {
    _AM_TypeName = value??"";
  }

  String get AM_TypeId => _AM_TypeId??"";

  set AM_TypeId(String? value) {
    _AM_TypeId = value??"";
  }
}
