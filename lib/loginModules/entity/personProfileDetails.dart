import 'package:schoolmanagementsystem/loginModules/entity/personProfilePhotoDetails.dart';

class PersonProfileDetails {
  String? _Profile_PersonID;
  String? _Profile_CreatedON;
  String? _Profile_Status;
  String? _IsSynced;
  List<PersonProfilePhotoDetails>? _lstPhoto;


  PersonProfileDetails();

  PersonProfileDetails.name(this._Profile_PersonID, this._Profile_CreatedON,
      this._Profile_Status, this._IsSynced,this._lstPhoto);

  factory PersonProfileDetails.fromMap(dynamic map) {
    var temp;
    return PersonProfileDetails.name(
      map?['Profile_PersonID']?.toString(),
      map?['Profile_CreatedON']?.toString(),
      map?['Profile_Status']?.toString(),
      map?['IsSynced']?.toString(),
      null == (temp = map?['lstPhoto'])
          ? []
          : (temp is List
              ? temp.map((map) => PersonProfilePhotoDetails.fromMap(map)).toList()
              : []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Profile_PersonID': _Profile_PersonID,
      'Profile_CreatedON': _Profile_CreatedON,
      'Profile_Status': _Profile_Status,
      'IsSynced': _IsSynced
    };
  }

  List<PersonProfilePhotoDetails> get lstPhoto => _lstPhoto??[];

  set lstPhoto(List<PersonProfilePhotoDetails>? value) {
    _lstPhoto = value??[];
  }

  String get Profile_Status => _Profile_Status??'';

  set Profile_Status(String? value) {
    _Profile_Status = value??'';
  }

  String get Profile_CreatedON => _Profile_CreatedON??'';

  set Profile_CreatedON(String? value) {
    _Profile_CreatedON = value??'';
  }

  String get Profile_PersonID => _Profile_PersonID??'';

  set Profile_PersonID(String? value) {
    _Profile_PersonID = value??'';
  }

  String get IsSynced => _IsSynced??"false";

  set IsSynced(String? value) {
    _IsSynced = value??"false";
  }
}
