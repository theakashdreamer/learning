import 'TypeOfAmbulance.dart';

class MasterDataEntity {
  List<TypeOfAmbulance>? _lstTypeofAmbulance = [];

  MasterDataEntity.name(this._lstTypeofAmbulance);

  Map<String, dynamic> toMap() {
    return {
      'lstTypeofAmbulance': _lstTypeofAmbulance ?? [],
    };
  }

  factory MasterDataEntity.fromMap(Map<String, dynamic> map) {
    var temp1 = null;
    return MasterDataEntity.name(
      null ==
          (temp1 = map['lstTypeofAmbulance'])
          ? [] : (temp1 is List ? temp1.map((map) => TypeOfAmbulance.fromMap(map)).toList() : [])
    );
  }

  static List<MasterDataEntity> convertJsonToList(
      List<dynamic> jsonAsString) {
    List<MasterDataEntity> listUserDetails =
    jsonAsString.map((json) => MasterDataEntity.fromMap(json)).toList();
    return listUserDetails;
  }

  List<TypeOfAmbulance> get lstTypeofAmbulance => _lstTypeofAmbulance?? [];

  set lstTypeofAmbulance(List<TypeOfAmbulance>? value) {
    _lstTypeofAmbulance = value;
  }
}
