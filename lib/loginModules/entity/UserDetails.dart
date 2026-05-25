import 'package:schoolmanagementsystem/loginModules/entity/personProfilePhotoDetails.dart';

class UserDetails {
  String? _PNO;
  String? _Course;
  String? _Course_ID;
  String? _AcademicSession;
  String? _TaineeName;
  String? _TraineeDesignation;
  String? _TraineeID;
  String? _MobileNo;
  String? _UserID;
  String? _User_Pin;
  String? _Designation_ID;
  String? _Section_Id;
  String? _DistrictID;
  String? _BlockID;
  String? _PanchayatID;
  String? _IsTrainer;
  String? _TrainingSchedule_ID;
  String? _Office_ID;
  String? _IsHead;
  String? _SchoolName;
  String? _District_Name;
  String? _DistrictName;
  String? _Class_Name;
  String? _Section_ID;
  String? _Class_Id;
  String? _Section_Name;
  String? _OTP;
  String? _O03_Org_Id;
  String? _sms_OrgUnitSection_Id;
  String? _master_PostType_Id;
  String? _ResultString;

  List<PersonProfilePhotoDetails>? _lstprofile;

  UserDetails();

  UserDetails.name(
      this._PNO,
      this._Course,
      this._Course_ID,
      this._AcademicSession,
      this._TaineeName,
      this._TraineeDesignation,
      this._TraineeID,
      this._MobileNo,
      this._UserID,
      this._User_Pin,
      this._Designation_ID,
      this._Section_Id,
      this._DistrictID,
      this._BlockID,
      this._PanchayatID,
      this._IsTrainer,
      this._TrainingSchedule_ID,
      this._Office_ID,
      this._IsHead,
      this._SchoolName,
      this._District_Name,
      this._DistrictName,
      this._Class_Name,
      this._Section_ID,
      this._Class_Id,
      this._Section_Name,
      this._master_PostType_Id,
      this._OTP,
      this._O03_Org_Id,
      this._sms_OrgUnitSection_Id,
      this._ResultString,
      this._lstprofile);

  Map<String, dynamic> toMap() {
    return {
      'PNO': _PNO,
      'Course': _Course,
      'Course_ID': _Course_ID,
      'AcademicSession': _AcademicSession,
      'TaineeName': _TaineeName,
      'TraineeDesignation': _TraineeDesignation,
      'TraineeID': _TraineeID,
      'MobileNo': _MobileNo,
      'UserID': _UserID,
      'User_Pin': _User_Pin,
      'Designation_ID': _Designation_ID,
      'Section_Id': _Section_Id,
      'DistrictID': _DistrictID,
      'BlockID': _BlockID,
      'PanchayatID': _PanchayatID,
      'IsTrainer': _IsTrainer,
      'TrainingSchedule_ID': _TrainingSchedule_ID,
      'Office_ID': _Office_ID,
      'IsHead': _IsHead,
      'SchoolName': _SchoolName,
      'District_Name': _District_Name,
      'DistrictName': _DistrictName,
      'Class_Name': _Class_Name,
      'Section_ID': _Section_ID,
      'Class_Id': _Class_Id,
      'Section_Name': _Section_Name,
      'OTP': _OTP,
      'O03_Org_Id': _O03_Org_Id,
      'sms_OrgUnitSection_Id': _sms_OrgUnitSection_Id,
      'master_PostType_Id': _master_PostType_Id
    };
  }

  factory UserDetails.fromMap(dynamic map) {
    var temp = null;
    return UserDetails.name(
        map['PNO']?.toString(),
        map['Course']?.toString(),
        map['Course_ID']?.toString(),
        map['AcademicSession']?.toString(),
        map['TaineeName']?.toString(),
        map['TraineeDesignation']?.toString(),
        map['TraineeID']?.toString(),
        map['MobileNo']?.toString(),
        map['UserID']?.toString(),
        map['User_Pin']?.toString(),
        map['Designation_ID']?.toString(),
        map['Section_Id']?.toString(),
        map['DistrictID']?.toString(),
        map['BlockID']?.toString(),
        map['PanchayatID']?.toString(),
        map['IsTrainer']?.toString(),
        map['TrainingSchedule_ID']?.toString(),
        map['Office_ID']?.toString(),
        map['IsHead']?.toString(),
        map['SchoolName']?.toString(),
        map['District_Name']?.toString(),
        map['DistrictName']?.toString(),
        map['Class_Name']?.toString(),
        map['Section_ID']?.toString(),
        map['Class_Id']?.toString(),
        map['Section_Name']?.toString(),
        map['master_PostType_Id']?.toString(),
        map['OTP']?.toString(),
        map['O03_Org_Id']?.toString(),
        map['sms_OrgUnitSection_Id']?.toString(),
        map['ResultString']?.toString(),
        null == (temp = map['lstprofile'])
            ? []
            : (temp is List
                ? temp
                    .map((map) => PersonProfilePhotoDetails.fromMapLogin(map))
                    .toList()
                : [])
    );
  }

  String get master_PostType_Id => _master_PostType_Id ?? "";

  set master_PostType_Id(String? value) {
    _master_PostType_Id = value ?? "";
  }

  String get OTP => _OTP ?? "";

  set OTP(String value) {
    _OTP = value ?? "";
  }

  String get Class_Id => _Class_Id ?? "";

  set Class_Id(String? value) {
    _Class_Id = value ?? "";
  }

  String get Section_Name => _Section_Name ?? "";

  set Section_Name(String? value) {
    _Section_Name = value ?? "";
  }

  String get Section_ID => _Section_ID ?? '';

  set Section_ID(String? value) {
    _Section_ID = value ?? '';
  }

  String get Class_Name => _Class_Name ?? '';

  set Class_Name(String? value) {
    _Class_Name = value ?? '';
  }

  String get DistrictName => _DistrictName ?? '';

  set DistrictName(String? value) {
    _DistrictName = value ?? '';
  }

  String get District_Name => _District_Name ?? '';

  set District_Name(String? value) {
    _District_Name = value ?? '';
  }

  String get SchoolName => _SchoolName ?? '';

  set SchoolName(String? value) {
    _SchoolName = value ?? '';
  }

  String get IsHead => _IsHead ?? '';

  set IsHead(String? value) {
    _IsHead = value ?? '';
  }

  String get Office_ID => _Office_ID ?? '';

  set Office_ID(String? value) {
    _Office_ID = value ?? '';
  }

  String get TrainingSchedule_ID => _TrainingSchedule_ID ?? '';

  set TrainingSchedule_ID(String? value) {
    _TrainingSchedule_ID = value ?? '';
  }

  String get IsTrainer => _IsTrainer ?? '';

  set IsTrainer(String? value) {
    _IsTrainer = value ?? '';
  }

  String get PanchayatID => _PanchayatID ?? '';

  set PanchayatID(String? value) {
    _PanchayatID = value ?? '';
  }

  String get BlockID => _BlockID ?? '';

  set BlockID(String? value) {
    _BlockID = value ?? '';
  }

  String get DistrictID => _DistrictID ?? '';

  set DistrictID(String? value) {
    _DistrictID = value ?? '';
  }

  String get Section_Id => _Section_Id ?? '';

  set Section_Id(String? value) {
    _Section_Id = value ?? '';
  }

  String get Designation_ID => _Designation_ID ?? '';

  set Designation_ID(String? value) {
    _Designation_ID = value ?? '';
  }

  String get User_Pin => _User_Pin ?? '';

  set User_Pin(String? value) {
    _User_Pin = value ?? '';
  }

  String get UserID => _UserID ?? '';

  set UserID(String? value) {
    _UserID = value ?? '';
  }

  String get MobileNo => _MobileNo ?? '';

  set MobileNo(String? value) {
    _MobileNo = value ?? '';
  }

  String get TraineeID => _TraineeID ?? '';

  set TraineeID(String? value) {
    _TraineeID = value ?? '';
  }

  String get TraineeDesignation => _TraineeDesignation ?? '';

  set TraineeDesignation(String? value) {
    _TraineeDesignation = value ?? '';
  }

  String get TaineeName => _TaineeName ?? '';

  set TaineeName(String? value) {
    _TaineeName = value ?? '';
  }

  String get AcademicSession => _AcademicSession ?? '';

  set AcademicSession(String? value) {
    _AcademicSession = value ?? '';
  }

  String get Course_ID => _Course_ID ?? '';

  set Course_ID(String? value) {
    _Course_ID = value ?? '';
  }

  String get Course => _Course ?? '';

  set Course(String? value) {
    _Course = value ?? '';
  }

  String get PNO => _PNO ?? '';

  set PNO(String? value) {
    _PNO = value ?? '';
  }

  String get O03_Org_Id => _O03_Org_Id ?? "-1";

  set O03_Org_Id(String? value) {
    _O03_Org_Id = value ?? "-1";
  }

  List<PersonProfilePhotoDetails> get lstprofile => _lstprofile ?? [];

  set lstprofile(List<PersonProfilePhotoDetails>? value) {
    _lstprofile = value ?? [];
  }

  String get sms_OrgUnitSection_Id => _sms_OrgUnitSection_Id ?? "-1";

  set sms_OrgUnitSection_Id(String? value) {
    _sms_OrgUnitSection_Id = value ?? "-1";
  }

  String get ResultString => _ResultString??"Failure";

  set ResultString(String value) {
    _ResultString = value??"Failure";
  }
}
