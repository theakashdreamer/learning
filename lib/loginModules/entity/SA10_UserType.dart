class SA10_UserType {
  String? _UserType_Id;
  String? _UserType_Name;
  String? _TotalMember;


  String get TotalMember => _TotalMember??"";

  set TotalMember(String value) {
    _TotalMember = value;
  }

  SA10_UserType();

  SA10_UserType.name(this._UserType_Id, this._UserType_Name,this._TotalMember);

  Map<String, dynamic> toMap() {
    return {
      'UserType_Id': _UserType_Id,
      'UserType_Name': _UserType_Name,
      'TotalMember': _TotalMember,
    };
  }

  factory SA10_UserType.fromMap(dynamic map) {
    return SA10_UserType.name(
      map['UserType_Id']?.toString(),
      map['UserType_Name']?.toString(),
      map['TotalMember']?.toString(),
    );
  }

  String get UserType_Name => _UserType_Name??"";

  set UserType_Name(String value) {
    _UserType_Name = value;
  }

  String get UserType_Id => _UserType_Id??"";
  set UserType_Id(String value) {
    _UserType_Id = value;
  }
}