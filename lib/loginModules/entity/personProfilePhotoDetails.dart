class PersonProfilePhotoDetails {
  String? _id;
  String? _Person_Id;
  String? _Profile_FilePath;
  String? _embeedings;

  PersonProfilePhotoDetails();

  PersonProfilePhotoDetails.name(this._Person_Id, this._Profile_FilePath, this._embeedings);

  factory PersonProfilePhotoDetails.fromMap(dynamic map) {
    var temp;
    return PersonProfilePhotoDetails.name(
      map['Person_Id']?.toString() ?? '',
      map['Profile_FilePath']?.toString() ?? '',
      map['embeedings']?.toString() ?? '',
    );
  }

  factory PersonProfilePhotoDetails.fromMapLogin(dynamic map) {
    var temp;
    return PersonProfilePhotoDetails.name(
      map['Profile_ID']?.toString() ?? '',
      map['Profile_FilePath']?.toString() ?? '',
      map['embeedings']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Person_Id': _Person_Id ?? '',
      'Profile_FilePath': _Profile_FilePath ?? '',
      'embeedings': _embeedings ?? '',
    };
  }

  Map<String, dynamic> toMapLogin() {
    return {
      'Person_Id': _Person_Id ?? '',
      'Profile_FilePath': _Profile_FilePath ?? '',
      'embeedings': _embeedings ?? '',
    };
  }

  static List<PersonProfilePhotoDetails> mapToProfilePhotoList(
      List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => PersonProfilePhotoDetails.fromMap(json)).toList();
  }

  String get embeedings => _embeedings ?? "";

  set embeedings(String? value) {
    embeedings = value ?? "";
  }

  String get Profile_FilePath => _Profile_FilePath ?? '';

  set Profile_FilePath(String? value) {
    Profile_FilePath = value ?? '';
  }

  String get Person_Id => _Person_Id ?? '';

  set Person_Id(String? value) {
    _Person_Id = value ?? '';
  }

  String get id => _id ?? "";

  set id(String? value) {
    _id = value ?? "";
  }
}
