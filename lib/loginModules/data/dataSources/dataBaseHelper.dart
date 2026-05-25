import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../entity/UserDetails.dart';
import '../../entity/personDetails.dart';
import '../../entity/personProfileDetails.dart';
import '../../entity/personProfilePhotoDetails.dart';

class DataBaseHelper {
  static Database? _database;
  static const String _tblAttendance = 'tblAttendance';
  static const String _tblAttendancePhoto = 'tblAttendancePhoto';
  static const String _tblUserDetails = 'tblUserDetails';
  static const String _createTblUserDetails = """CREATE TABLE $_tblUserDetails (
    CommonID INTEGER PRIMARY KEY,
    PNO TEXT,
    Course TEXT,
    Course_ID TEXT, 
    AcademicSession TEXT,
    TaineeName TEXT,
    TraineeDesignation TEXT,
    TraineeID TEXT,
    MobileNo TEXT,
    UserID TEXT,
    User_Pin TEXT,
    Designation_ID TEXT,
    DistrictID TEXT,
    BlockID TEXT,
    PanchayatID TEXT,
    IsTrainer TEXT,
    TrainingSchedule_ID TEXT,
    Office_ID TEXT,
    IsHead TEXT,
    SchoolName TEXT,
    District_Name TEXT,
    DistrictName TEXT,
    Class_Name TEXT,
    Section_Id TEXT,
    Class_Id TEXT,
    OTP TEXT,
    Section_Name TEXT,
    O03_Org_Id TEXT,
    sms_OrgUnitSection_Id TEXT,
    master_PostType_Id TEXT
    );
""";

  static const String tblState = "tblState";
  static const String _createTblState = """CREATE TABLE $tblState (
    commonID INTEGER PRIMARY KEY,
    stateId TEXT,
    stateName TEXT );
""";

  static const String tblDistrict = "tblDistrict";
  static const String _createTblDistrict = """CREATE TABLE $tblDistrict (
    commonID INTEGER PRIMARY KEY,
    stateId TEXT,
    districtId TEXT,
    districtName TEXT );
""";

  static const String tblBlockTown = "tblBlockTown";
  static const String _createTblBlockTown = """CREATE TABLE $tblBlockTown (
    commonID INTEGER PRIMARY KEY,
    blockTownId TEXT,
    blockTownName TEXT,
    AreaType TEXT,
    stateId TEXT,
    districtId TEXT );
""";

  static const String tblGramPanchayat = "tblGramPanchayat";
  static const String _createTblGramPanchayat =
      """CREATE TABLE $tblGramPanchayat (
    commonID INTEGER PRIMARY KEY,
    gramPanchayatId TEXT,
    gramPanchayatName TEXT,
    gramPanchayatCode TEXT,
    stateId TEXT,
    districtId TEXT,
    blockTownId TEXT );
""";

  static const String tblO10Post = "tblO10Post";
  static const String _createTblO10Post = """CREATE TABLE $tblO10Post (
    commonID INTEGER PRIMARY KEY,
    Post_Id TEXT,
    Post_Name TEXT );
""";

  static const String _tbl_yearData = "tbl_yearData";
  static const String AcademicYear_ID = "AcademicYear_ID";
  static const String AcademicYear_Text = "AcademicYear_Text";

  static const String create_tbl_yearData = """CREATE TABLE $_tbl_yearData (
    commonID INTEGER PRIMARY KEY,
    AcademicYear_ID TEXT,
    AcademicYear_Text TEXT );
""";

  static const String _tbl_school = "tbl_school";
  static const String SchoolId = "SchoolId";
  static const String SchoolName = "SchoolName";
  static const String SchoolLattitude = "SchoolLattitude";
  static const String SchoolLongitude = "SchoolLongitude";
  static const String UdiseCode = "UdiseCode";

  static const String create_tbl_school = """CREATE TABLE $_tbl_school (
    commonID INTEGER PRIMARY KEY,
    SchoolId TEXT,
    SchoolName TEXT,
    SchoolLattitude TEXT,
    UdiseCode TEXT,
    SchoolLongitude TEXT );
""";

  static const String _createTblAttendance = """CREATE TABLE $_tblAttendance (
    CommonId INTEGER PRIMARY KEY,
    Attendance_PersonID TEXT,
    Attendance_DistrictID TEXT,
    Attendance_BlockID TEXT,
    Attendance_PanchayatID TEXT,
    Attendance_Datetime TEXT,
    Attendance_AttendanceType TEXT,
    Attendance_Status TEXT,
    Attendance_AddedOn TEXT,
    Attendance_PresentAbscent TEXT,
    Attendance_AbscentReason TEXT,
    Attendance_Lattitude TEXT,
    Attendance_Longitude TEXT,
    LocalApp_Id TEXT,
    UniqueNo TEXT,
    TrainerMobileNo TEXT,
    Attendance_Type TEXT,
    Local TEXT,
    NTPServer TEXT,
    GPS TEXT,
    NITZ TEXT,
    TrainingSchedule_ID TEXT,
    ResultString TEXT,
    AppVersion TEXT,
    Attendance_MarkedBy TEXT,
    IsPolice TEXT,
    IsSynced TEXT
    );
""";

  static const String _createTblAttendancePhoto =
      """CREATE TABLE $_tblAttendancePhoto (
    CommonId INTEGER PRIMARY KEY,
    AttPhoto_AttendanceID TEXT,
    AttPhoto_Path TEXT,
    AttPhoto_Filenmae TEXT,
    AttPhoto_AddedON TEXT,
    AttPhoto_ClickedOn TEXT,
    AttPhoto_Lattitude TEXT,
    AttPhoto_Longitude TEXT
    );
""";

  static const String _tblPersonDetails = 'tblPersonDetails';
  static const String _createTblPersonDetails =
      """CREATE TABLE $_tblPersonDetails (
    id INTEGER PRIMARY KEY,
    Person_Id TEXT,
    Person_Name TEXT,
    MobileNo TEXT,
    Class_Name TEXT,
    Section_Name TEXT,
    IsProfileCreated TEXT,
    UserType TEXT,
    IsSynced TEXT
     );
""";

  static const String _tblPersonProfileDetails = 'tblPersonProfileDetails';
  static const String _createTblPersonProfileDetails =
      """CREATE TABLE $_tblPersonProfileDetails (
    id INTEGER PRIMARY KEY,
    Profile_PersonID TEXT,
    Profile_CreatedON TEXT,
    Profile_Status TEXT,
    IsSynced TEXT
    );
""";

  static const String _tblPersonProfilePhotoDetails =
      'tblPersonProfilePhotoDetails';
  static const String _createTblPersonProfilePhotoDetails =
      """CREATE TABLE $_tblPersonProfilePhotoDetails (
    id INTEGER PRIMARY KEY,
    Person_Id TEXT,
    Profile_FilePath TEXT,
    embeedings TEXT
    );
""";

  static const String _tbl_schoolList = "tbl_schoolList";
  static const String Office_Id = "Office_Id";
  static const String Office_Name = "Office_Name";
  static const String Office_Code = "Office_Code";
  static const String District_Name = "District_Name";
  static const String Block_Id = "Block_Id";
  static const String Block_Name = "Block_Name";
  static const String Panchayat_Id = "Panchayat_Id";
  static const String Panchayat_Name = "Panchayat_Name";
  static const String District_Id = "District_Id";

  static const String _create_tbl_schoolList =
      """CREATE TABLE $_tbl_schoolList (
    commonID INTEGER PRIMARY KEY,
    Office_Id TEXT,
    Office_Name TEXT,
    District_Name TEXT,
    Block_Id TEXT,
    Block_Name TEXT,
    Panchayat_Id TEXT,
    Panchayat_Name TEXT,
    District_Id TEXT,
    Office_Code TEXT );
""";

  //New App

  static const String _tblCampus = 'tblCampus';
  static const String _createTblCampus = """CREATE TABLE $_tblCampus (
    id INTEGER PRIMARY KEY,
    Campus_Name TEXT,
    Campus_No TEXT,
    Campus_Description TEXT,
    Campus_QRCode TEXT,
    Campus_Lattitude TEXT,
    Campus_Longitude TEXT,
    Campus_Geometory TEXT,
    Campus_Length TEXT,
    Campus_Breadth TEXT,
    Campus_Height TEXT,
    Campus_LandArea TEXT,
    Campus_ConstructedArea TEXT,
    Campus_TotalCoveredArea TEXT,
    Campus_Volume TEXT,
    Campus_North TEXT,
    Campus_South TEXT,
    Campus_East TEXT,
    Campus_West TEXT,
    UsageTypeId TEXT,
    GeneralCondition_Id TEXT,
    G02_Country_Id TEXT,
    G03_State_Id TEXT,
    G04_District_Id TEXT,
    G08_Tehsil_Id TEXT,
    G22_AreaClassification_Id TEXT,
    G09_Town_Id TEXT,
    G10_Ward_Id TEXT,
    G05_Block_Id TEXT,
    G32_NP_Id TEXT,
    G06_Panchayat_ID TEXT,
    G07_Village_Id TEXT,
    Campus_Address TEXT,
    Campus_AddressLine1 TEXT,
    Campus_AddressLine2 TEXT,
    Campus_ZipCode TEXT,
    O03_Organization_Id TEXT,
    O05_Office_Id TEXT,
    Campus_Remark TEXT,
    lstDocument TEXT,
    ResultString TEXT,
    IsSynced TEXT,
    LocalTime TEXT,
    NTPServerTime TEXT,
    GPSTime TEXT,
    AppVersion TEXT,
    NITZTime TEXT,
    LocalApp_Id TEXT,
    SA08_App_Id TEXT,
    SyncedOn TEXT,
    P02_AddedBy TEXT,
    O12_AddedBy TEXT,
    IsRemoved TEXT,
    Survey_Id TEXT,
    SurveyProgress_Id TEXT,
    RemoteServerId TEXT,
    AppInstance_Id TEXT
    );
""";

  static const String _tblBuilingInformation = 'tblBuilingInformation';
  static const String _createTblBuilingInformation =
      """CREATE TABLE $_tblBuilingInformation (
    id INTEGER PRIMARY KEY,
    Building_Id TEXT,
    Building_Name TEXT,
    Building_No TEXT,
    O23_Campus_Id TEXT,
    Building_Description TEXT,
    Building_TotalFloors TEXT,
    Building_QRCode TEXT,
    Building_Lattitude TEXT,
    Building_Longitude TEXT,
    Building_Geometory TEXT,
    Building_Length TEXT,
    Building_Breadth TEXT,
    Building_Height TEXT,
    Building_LandArea TEXT,
    Building_ConstructedArea TEXT,
    Building_TotalCoveredArea TEXT,
    Building_Volume TEXT,
    Building_North TEXT,
    Building_South TEXT,
    Building_East TEXT,
    Building_West TEXT,
    UsageTypeId TEXT,
    GeneralCondition_Id TEXT,
    G02_Country_Id TEXT,
    G03_State_Id TEXT,
    G04_District_Id TEXT,
    G08_Tehsil_Id TEXT,
    G22_AreaClassification_Id TEXT,
    G09_Town_Id TEXT,
    G10_Ward_Id TEXT,
    G05_Block_Id TEXT,
    G32_NP_Id TEXT,
    G06_Panchayat_ID TEXT,
    G07_Village_Id TEXT,
    Building_Address TEXT,
    Building_AddressLine1 TEXT,
    Building_AddressLine2 TEXT,
    Building_ZipCode TEXT,
    O03_Organization_Id TEXT,
    O05_Office_Id TEXT,
    P02_AddedBy TEXT,
    O12_AddedBy TEXT,
    Building_Remark TEXT,
    IsSynced TEXT, 
    LocalTime TEXT,
    NTPServerTime TEXT,
    GPSTime TEXT,
    AppVersion TEXT,
    NITZTime TEXT,
    LocalApp_Id TEXT,
    SA08_App_Id TEXT,
    SyncedOn TEXT,
    SurveyProgress_Id TEXT,
    RemoteServerId TEXT,
    AppInstance_Id TEXT
    );
""";

  static const String _tblCampusBuildingsFloor = 'tblCampusBuildingsFloor';
  static const String _createTblCampusBuildingsFloor =
      """CREATE TABLE $_tblCampusBuildingsFloor (
    id INTEGER PRIMARY KEY,
    Floor_Name TEXT,
    Floor_Number TEXT,
    O23_Campus_Id TEXT,
    O19_Building_Id TEXT,
    Floor_Description TEXT,
    Floor_QRCode TEXT,
    Floor_Lattitude TEXT,
    Floor_Longitude TEXT,
    Floor_Geometory TEXT,
    Floor_Length TEXT,
    Floor_Breadth TEXT,
    Floor_Height TEXT,
    Floor_LandArea TEXT,
    Floor_ConstructedArea TEXT,
    Floor_TotalCoveredArea TEXT,
    Floor_Volume TEXT,
    Floor_North TEXT,
    Floor_South TEXT,
    Floor_East TEXT,
    Floor_West TEXT,
    UsageTypeId TEXT,
    GeneralCondition_Id TEXT,
    G02_Country_Id TEXT,
    G03_State_Id TEXT,
    G04_District_Id TEXT,
    G08_Tehsil_Id TEXT,
    G22_AreaClassification_Id TEXT,
    G09_Town_Id TEXT,
    G10_Ward_Id TEXT,
    G05_Block_Id TEXT,
    G32_NP_Id TEXT,
    G06_Panchayat_ID TEXT,
    G07_Village_Id TEXT,
    Floor_Address TEXT,
    Floor_AddressLine1 TEXT,
    Floor_AddressLine2 TEXT,
    Floor_ZipCode TEXT,
    O03_Organization_Id TEXT,
    O05_Office_Id TEXT,
    AddedOn TEXT,
    P02_AddedBy TEXT,
    O12_AddedBy TEXT,
    Floor_IsActive TEXT,
    Floor_Remark TEXT,
    ResultString TEXT,
    IsSynced TEXT,
    LocalTime TEXT,
    NTPServerTime TEXT,
    GPSTime TEXT,
    AppVersion TEXT,
    NITZTime TEXT,
    LocalApp_Id TEXT,
    SA08_App_Id TEXT,
    SyncedOn TEXT,
    SurveyProgress_Id TEXT,
    RemoteServerId TEXT,
    AppInstance_Id TEXT
    );
""";

  static const String _tblBuildingComponents = 'tblBuildingComponents';
  static const String _createTblBuildingComponents =
      """CREATE TABLE $_tblBuildingComponents (
    id INTEGER PRIMARY KEY,
    BuildComponent_Name TEXT,
    BuildComponent_No TEXT,    
    BuildingCompType_Id TEXT,
    O23_Campus_Id TEXT,
    O19_Building_Id TEXT,
    Facility_Id TEXT,
    CampusBuildingsFloor_Id TEXT,
    BuildComponent_Description TEXT,
    BuildComponent_QRCode TEXT,
    BuildComponent_Lattitude TEXT,
    BuildComponent_Longitude TEXT,
    BuildComponent_Geometory TEXT,
    BuildComponent_Length TEXT,
    BuildComponent_Breadth TEXT,
    BuildComponent_Height TEXT,
    BuildComponent_LandArea TEXT,
    BuildComponent_ConstructedArea TEXT,
    BuildComponent_TotalCoveredArea TEXT,
    BuildComponent_Volume TEXT,
    BuildComponent_North TEXT,
    BuildComponent_South TEXT,
    BuildComponent_East TEXT,
    BuildComponent_West TEXT,
    UsageTypeId TEXT,
    BuildComponent_SeatingCapacity TEXT,
    BuildComponent_Class TEXT,
    BuildComponent_Section TEXT,
    GeneralCondition_Id TEXT,
    G02_Country_Id TEXT,
    G03_State_Id TEXT,
    G04_District_Id TEXT,
    G08_Tehsil_Id TEXT,
    G22_AreaClassification_Id TEXT,
    G09_Town_Id TEXT,
    G10_Ward_Id TEXT,
    G05_Block_Id TEXT,
    G32_NP_Id TEXT,
    G06_Panchayat_ID TEXT,
    G07_Village_Id TEXT,
    BuildComponent_Address TEXT,
    BuildComponent_AddressLine1 TEXT,
    BuildComponent_AddressLine2 TEXT,
    BuildComponent_ZipCode TEXT,
    O03_Organization_Id TEXT,
    O05_Office_Id TEXT,
    P02_AddedBy TEXT,
    O12_AddedBy TEXT,
    BuildComponent_Remark TEXT,
    ResultString TEXT,
    IsSynced TEXT,
    LocalTime TEXT,
    NTPServerTime TEXT,
    GPSTime TEXT,
    AppVersion TEXT,
    NITZTime TEXT,
    LocalApp_Id TEXT,
    SA08_App_Id TEXT,
    SyncedOn TEXT,
    Infra_ElementType_Id TEXT,
    SurveyProgress_Id TEXT,
    RemoteServerId TEXT,
    AppInstance_Id TEXT
    );
""";

  static const String _tblFacility = 'tblFacility';
  static const String _createTblFacility = """CREATE TABLE $_tblFacility (
    id INTEGER PRIMARY KEY,
    Facility_Name TEXT,
    Facility_No TEXT,
    O23_Campus_Id TEXT,
    O19_Building_Id TEXT,
    CampusBuildingsFloor_Id TEXT,
    Facility_Description TEXT,
    Facility_QRCode TEXT,
    Facility_Lattitude TEXT,
    Facility_Longitude TEXT,
    Facility_Geometory TEXT,
    Facility_Length TEXT,
    Facility_Breadth TEXT,
    Facility_Height TEXT,
    Facility_LandArea TEXT,
    Facility_ConstructedArea TEXT,
    Facility_TotalCoveredArea TEXT,
    Facility_Volume TEXT,
    Facility_North TEXT,
    Facility_South TEXT,
    Facility_East TEXT,
    Facility_West TEXT,
    UsageTypeId TEXT,
    GeneralCondition_Id TEXT,
    G02_Country_Id TEXT,
    G03_State_Id TEXT,
    G04_District_Id TEXT,
    G08_Tehsil_Id TEXT,
    G22_AreaClassification_Id TEXT,
    G09_Town_Id TEXT,
    G10_Ward_Id TEXT,
    G05_Block_Id TEXT,
    G32_NP_Id TEXT,
    G06_Panchayat_ID TEXT,
    G07_Village_Id TEXT,
    Facility_Address TEXT,
    Facility_AddressLine1 TEXT,
    Facility_AddressLine2 TEXT,
    Facility_ZipCode TEXT,
    O03_Organization_Id TEXT,
    O05_Office_Id TEXT,
    AddedOn TEXT,
    P02_AddedBy TEXT,
    O12_AddedBy TEXT,
    Facility_IsActive TEXT,
    Facility_Remark TEXT,
    LocalTime TEXT,
    NTPServerTime TEXT,
    GPSTime TEXT,
    NITZTime TEXT,
    AppVersion TEXT,
    LocalApp_Id TEXT,
    SA08_App_Id TEXT,
    SyncedOn TEXT,
    ResultString TEXT,
    IsSynced TEXT,
    Infra_ElementType_Id TEXT,
    SurveyProgress_Id TEXT,
    RemoteServerId TEXT,
    AppInstance_Id TEXT
    );
""";

  static const String _tblDocuments = 'tblDocuments';

  static const String _createtblDocuments = """CREATE TABLE $_tblDocuments (
    id INTEGER PRIMARY KEY,
    FileName TEXT,
    FilePath TEXT,
    ServerPath TEXT,
    Extension TEXT,
    FileSize TEXT,
    Infra_ElementType_Id TEXT,
    Infra_Element_Instance_Id TEXT,
    Lattitude TEXT,
    Longitude TEXT,
    P02_AddedBy TEXT,
    O12_AddedBy TEXT,
    SyncedOn TEXT,
    SA08_App_Id TEXT,
    LocalApp_Id TEXT,
    AppVersion TEXT,
    NITZTime TEXT,
    GPSTime TEXT,
    NTPServerTime TEXT,
    SurveyProgress_Id TEXT,
    RemoteServerId TEXT,
    AppInstance_Id TEXT,
    ItemStockLocationPhoto_Id TEXT,
    ItemStock_Id TEXT,
    ItemStockLocation_Id TEXT,
    AddedOn TEXT,
    UpdatedOn TEXT,
    P02_UpdatedBy TEXT,
    O12_UpdatedBy TEXT,
    Survey_Id TEXT,
    IsFeatured TEXT,
    IS_Synced TEXT,
    ResultString TEXT,
    LocalTime TEXT
    );
""";

  static const String _tblItemStockSpecificationDocuments =
      'tblItemStockSpecificationDocuments';

  static const String _createTblItemStockSpecificationDocuments =
      """CREATE TABLE $_tblItemStockSpecificationDocuments (
    id INTEGER PRIMARY KEY,
    FileName TEXT,
    FilePath TEXT,
    ServerPath TEXT,
    Extension TEXT,
    FileSize TEXT,
    Infra_ElementType_Id TEXT,
    Infra_Element_Instance_Id TEXT,
    Lattitude TEXT,
    Longitude TEXT,
    P02_AddedBy TEXT,
    O12_AddedBy TEXT,
    SyncedOn TEXT,
    SA08_App_Id TEXT,
    LocalApp_Id TEXT,
    AppVersion TEXT,
    NITZTime TEXT,
    GPSTime TEXT,
    NTPServerTime TEXT,
    SurveyProgress_Id TEXT,
    RemoteServerId TEXT,
    AppInstance_Id TEXT,
    ItemStockLocationPhoto_Id TEXT,
    ItemStock_Id TEXT,
    ItemStockLocation_Id TEXT,
    AddedOn TEXT,
    UpdatedOn TEXT,
    P02_UpdatedBy TEXT,
    O12_UpdatedBy TEXT,
    Survey_Id TEXT,
    IsFeatured TEXT,
    IS_Synced TEXT,
    ResultString TEXT,
    LocalTime TEXT
    );
""";

  static const String _tblGeneralConditionClass = 'tblGeneralConditionClass';
  static const String _createTblGeneralConditionClass =
      """CREATE TABLE $_tblGeneralConditionClass (
    GeneralCondition TEXT,
    GeneralCondition_Id TEXT,
    GeneralCondition_Hindi TEXT
    );
""";

  static const String _tblMainBuildingComponentType =
      'tblMainBuildingComponentType';
  static const String _createTblMainBuildingComponentType =
      """CREATE TABLE $_tblMainBuildingComponentType (
    BuildCompCat_Id TEXT,
    BuildCompType_Id TEXT,
    BuildCompType_Name TEXT,
    BuildCompType_Name_Hindi TEXT
    );
""";

  static const String _tblMainInfrastructuralElementType =
      'tblMainInfrastructuralElementType';
  static const String _createTblMainInfrastructuralElementType =
      """CREATE TABLE $_tblMainInfrastructuralElementType (
    Infra_ElementType TEXT,
    Infra_ElementType_Id TEXT,
    Infra_ElementType_Hindi TEXT
    );
""";

  static const String _tblMainBuildingComponentCategory =
      'tblMainBuildingComponentCategory';
  static const String _createTblMainBuildingComponentCategory =
      """CREATE TABLE $_tblMainBuildingComponentCategory (
    BuildCompCat_Id TEXT,
    BuildCompCategory TEXT,
    BuildCompCategory_Hindi TEXT
    );
""";

  static const String _tblMainUsageType = 'tblMainUsageType';
  static const String _createTblMainUsageType =
      """CREATE TABLE $_tblMainUsageType (
    Infra_ElementType_Id TEXT,
    UsageTypeId TEXT,
    UsageTypeText TEXT,
    UsageType_Hindi TEXT
    );
""";

  static const String _tblMainSurveyStatus = 'tblMainSurveyStatus';
  static const String _createTblMainSurveyStatus =
      """CREATE TABLE $_tblMainSurveyStatus (
    SurveyStatus_Id TEXT,
    SurveyStatus_Name TEXT,
    SurveyStatus_Name_Hindi TEXT
    );
""";

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'AmbulanceOnlineService.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static _onCreate(Database database, int version) async {
    await database.execute(_createTblUserDetails);
    await database.execute(create_tbl_yearData);
    await database.execute(create_tbl_school);

    await database.execute(_createTblAttendance);
    await database.execute(_createTblAttendancePhoto);
    await database.execute(_createTblPersonDetails);
    await database.execute(_createTblPersonProfileDetails);
    await database.execute(_createTblPersonProfilePhotoDetails);

    await database.execute(_create_tbl_schoolList);
    await database.execute(_createTblCampus);
    await database.execute(_createtblDocuments);

    await database.execute(_createTblBuilingInformation);
    await database.execute(_createTblCampusBuildingsFloor);

    await database.execute(_createTblBuildingComponents);
    await database.execute(_createTblFacility);

    await database.execute(_createTblGeneralConditionClass);
    await database.execute(_createTblMainBuildingComponentType);
    await database.execute(_createTblMainInfrastructuralElementType);
    await database.execute(_createTblMainBuildingComponentCategory);
    await database.execute(_createTblMainUsageType);
    await database.execute(_createTblMainSurveyStatus);

    //todo new for Digital Infrastructure
    await database.execute(_createTblItemStockSpecificationDocuments);
  }

  static Future<void> deleteTraineeUserDetails() async {
    final db = await database;
    await db.delete(_tblUserDetails);
  }

  // deletion of table
  static Future<void> deleteTable(String tableName) async {
    final db = await database;
    await db.delete(tableName);
  }

// insertion table
  static Future<int> insertUserDetails(UserDetails obj) async {
    final db = await database;
    return await db.insert(
      _tblUserDetails,
      obj.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteYearData() async {
    final db = await database;
    await db.delete(_tbl_yearData);
  }

  static Future<bool> insertYearData(List<dynamic> listYearData) async {
    final db = await database;
    try {
      final batch = db.batch();
      for (var yearData in listYearData) {
        await db.insert(
          _tbl_yearData,
          yearData.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      final result = await batch.commit();
      return result.every((res) => res != 0);
    } catch (e) {
      print("Exception : $e");
      return false;
    }
  }

  static Future<int?> countForIndicatorData() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('Select Count(*) From $_tbl_yearData'));
  }

  // selection table
  static Future<UserDetails?> getUserDetailsDetails() async {
    final db = await database;
    final List<Map<String, dynamic>> listData = await db.query(_tblUserDetails);
    if (listData.isNotEmpty) {
      return UserDetails.fromMap(listData[0]);
    } else {
      return UserDetails();
    }
  }

  static Future<void> deleteSchoolData() async {
    final db = await database;
    await db.delete(_tbl_school);
  }

  static Future<bool> insertSchoolData(List<dynamic> listSchoolData) async {
    final db = await database;
    try {
      final batch = db.batch();
      for (var schoolData in listSchoolData) {
        await db.insert(
          _tbl_school,
          schoolData.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      final result = await batch.commit();
      return result.every((res) => res != 0);
    } catch (e) {
      print("Exception : $e");
      return false;
    }
  }

  static Future<int?> countForSchoolData() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('Select Count(*) From $_tbl_school'));
  }

//===============Attendance======================================//

  static Future<dynamic> getPersonDetailsForAttendance(
      String modeForUser) async {
    String sql = "";
    if (modeForUser == "1") {
      sql =
          "select tblPersonDetails.Person_Id, tblPersonDetails.Person_Name, tblPersonDetails.MobileNo,tblPersonDetails.Class_Name,tblPersonDetails.Section_Name,tblPersonProfilePhotoDetails.Profile_FilePath  from tblPersonDetails inner join tblPersonProfileDetails on tblPersonDetails.Person_Id = tblPersonProfileDetails.Profile_PersonID inner join tblPersonProfilePhotoDetails on tblPersonProfileDetails.Profile_PersonID = tblPersonProfilePhotoDetails.Person_Id where COALESCE(tblPersonProfilePhotoDetails.embeedings, '') != '' and tblPersonDetails.UserType = '1' group by tblPersonProfilePhotoDetails.Person_Id";
    } else {
      sql =
          "select tblPersonDetails.Person_Id, tblPersonDetails.Person_Name, tblPersonDetails.MobileNo,tblPersonDetails.Class_Name,tblPersonDetails.Section_Name,tblPersonProfilePhotoDetails.Profile_FilePath  from tblPersonDetails inner join tblPersonProfileDetails on tblPersonDetails.Person_Id = tblPersonProfileDetails.Profile_PersonID inner join tblPersonProfilePhotoDetails on tblPersonProfileDetails.Profile_PersonID = tblPersonProfilePhotoDetails.Person_Id where COALESCE(tblPersonProfilePhotoDetails.embeedings, '') != '' and tblPersonDetails.UserType != '1' group by tblPersonProfilePhotoDetails.Person_Id";
    }
    final db = await database;
    final List<Map<String, dynamic>> listData = await db.rawQuery(sql);
    return listData;
  }

  static Future<dynamic> getPersonProfileDetails(String modeForUser) async {
    String sql = "";
    if (modeForUser == "1") {
      sql =
          "select data.Person_Id, data.Person_Name, data.MobileNo,data.Class_Name,data.Section_Name,data.Profile_FilePath  from ( select  * from tblPersonDetails left join tblPersonProfilePhotoDetails on tblPersonDetails.Person_Id = tblPersonProfilePhotoDetails.Person_Id ) data  where  COALESCE(data.id, '') != '' and data.UserType = '1' group by data.id";
    } else {
      sql =
          "select data.Person_Id, data.Person_Name, data.MobileNo,data.Class_Name,data.Section_Name,data.Profile_FilePath  from ( select  * from tblPersonDetails left join tblPersonProfilePhotoDetails on tblPersonDetails.Person_Id = tblPersonProfilePhotoDetails.Person_Id ) data  where  COALESCE(data.id, '') != '' and data.UserType != '1' group by data.id";
    }
    final db = await database;
    final List<Map<String, dynamic>> listData = await db.rawQuery(sql);
    return listData;
  }

  static Future<int?> countTblAttendanceForMorningNew(
      String maxSimilarityName, String takeAttendanceType) async {
    final db = await database;

    final now = DateTime.now();
    final currentDateTimeStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final currentDate = currentDateTimeStr.substring(0, 10);
    try {
      String query =
          "SELECT COUNT(*) FROM $_tblAttendance WHERE Attendance_PersonID = ? "
          "and Attendance_AttendanceType = ? "
          "and IsPolice != ? "
          "AND substr(Local, 1, 10) = ? "
          "AND (julianday(?) - julianday(Local)) * 24 < 8 ";
      final count = await db.rawQuery(query, [
        maxSimilarityName,
        takeAttendanceType,
        "1",
        currentDate,
        currentDateTimeStr
      ]);
      return Sqflite.firstIntValue(count);
    } catch (e) {
      print("Error ddddd: $e");
      return 0;
    }
  }

  static countPersionDetailsTrue(String forWhat) async {
    final db = await database;
    return await Sqflite.firstIntValue(await db.rawQuery(
        "Select Count(*) From $_tblPersonProfileDetails where IsSynced=$forWhat"));
  }

  static Future<void> deleteProfilePhotoDetailsAccordingCommonID(
      String commonID) async {
    final db = await database;
    await db.delete(_tblPersonProfileDetails,
        where: "ProfilePhoto_ProfileID=?", whereArgs: [commonID]);
  }

  static Future<dynamic>
      getPersonDetailsForShowAllPersonForProfileReport() async {
    final db = await database;
    String sql =
        "SELECT tbl_PD.Person_ID, tbl_PD.Person_Name, tbl_PD.Person_Mobile, tbl_PD.Designation, tbl_PD.Designation_ID, tbl_PD.Deparment_ID, tbl_PD.Department_Name, tbl_PD.IsProfileCreated, tblPPDFSAVING.CommonID AS id, tblPPDFSAVING.IsSynced, tbl_PPP_DFS.ProfilePhoto_ServerPath as IsProfileCreated  FROM tblPersonDetails AS tbl_PD INNER JOIN tblPersonProfileDetailsForSaving as tblPPDFSAVING ON tbl_PD.Person_ID = tblPPDFSAVING.Profile_PersonID INNER JOIN tblPersonProfilePhotoDetailsForSaving AS tbl_PPP_DFS ON tblPPDFSAVING.CommonID = tbl_PPP_DFS.ProfilePhoto_ProfileID WHERE COALESCE(tblPPDFSAVING.CommonID, 0) != 0 AND tblPPDFSAVING.Profile_PersonID IS NOT NULL AND tbl_PD.Person_ID IN ( SELECT DISTINCT tbl_PP_DFS.Profile_PersonID FROM tblPersonProfileDetailsForSaving AS tbl_PP_DFS INNER JOIN tblPersonProfilePhotoDetailsForSaving AS tbl_PPP_DFS ON tbl_PP_DFS.CommonID = tbl_PPP_DFS.ProfilePhoto_ProfileID ) group by tbl_PD.Person_ID";
    final List<Map<String, dynamic>> listData = await db.rawQuery(sql);
    return listData;
  }

  static Future<dynamic>
      getPersonDetailsForShowAllPersonForCreateProfile() async {
    final db = await database;
    String sql =
        "select * from tblPersonDetails  as tbl_PD where tbl_PD.Person_ID not in ( select distinct tbl_PP_DFS.Profile_PersonID  from tblPersonProfileDetailsForSaving as tbl_PP_DFS inner join tblPersonProfilePhotoDetailsForSaving as tbl_PPP_DFS on tbl_PP_DFS.CommonID = tbl_PPP_DFS.ProfilePhoto_ProfileID)";
    final List<Map<String, dynamic>> listData = await db.rawQuery(sql);
    return listData;
  }

  static Future<void> deletePersonDetails(String personID, String mode) async {
    final db = await database;
    if (mode == "D") {
      // delete
      await db.delete(_tblPersonDetails,
          where: 'Person_Id != ?', whereArgs: [personID]);
    } else {
      await db.delete(_tblPersonDetails);
    }
  }

  static Future<void> delete_tblPersonProfileDetails(
      String personID, String mode) async {
    final db = await database;
    if (mode == "D") {
      // delete
      await db.delete(_tblPersonProfileDetails,
          where: 'Profile_PersonID != ?', whereArgs: [personID]);
    } else {
      await db.delete(_tblPersonProfileDetails);
    }
  }

  static Future<void> delete_tblPersonProfilePhotoDetails(
      String personID, String mode) async {
    final db = await database;
    if (mode == "D") {
      // delete
      await db.delete(_tblPersonProfilePhotoDetails,
          where: 'Person_Id != ?', whereArgs: [personID]);
    } else {
      await db.delete(_tblPersonProfilePhotoDetails);
    }
  }

  static Future<void> insertPersionDetails(
      List<PersonDetails> personDetailsList, String userPersonID) async {
    userPersonID = "53";
    await deletePersonDetails(userPersonID, "D");
    await delete_tblPersonProfileDetails(userPersonID, "D");
    await delete_tblPersonProfilePhotoDetails(userPersonID, "D");
    final db = await database;
    for (PersonDetails personDetails in personDetailsList) {
      db.insert(_tblPersonDetails, personDetails.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      List<PersonProfilePhotoDetails> personProfilePhotoDetailsList =
          personDetails.lstProfile;
      if (personProfilePhotoDetailsList.isNotEmpty) {
        if (personProfilePhotoDetailsList[0].embeedings.isNotEmpty &&
            personProfilePhotoDetailsList[0].embeedings != "" &&
            !personProfilePhotoDetailsList[0].embeedings.contains("String")) {
          PersonProfileDetails personProfileDetails = PersonProfileDetails();
          personProfileDetails.Profile_PersonID =
              personProfilePhotoDetailsList[0].Person_Id;
          personProfileDetails.Profile_Status = "1";
          personProfileDetails.IsSynced = "true";
          int insertValue = await db.insert(
            _tblPersonProfileDetails,
            personProfileDetails.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          if (insertValue > 0) {
            for (PersonProfilePhotoDetails personProfilePhotoDetails
                in personProfilePhotoDetailsList) {
              db.insert(
                _tblPersonProfilePhotoDetails,
                personProfilePhotoDetails.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          }
        }
      }
    }
  }

  static Future<void> insertPersonDetailsTeacher(
      List<PersonProfilePhotoDetails> personProfilePhotoDetailsList,
      UserDetails? userDetails) async {
    await deletePersonDetails(userDetails?.TraineeID ?? "-1", "");
    await delete_tblPersonProfileDetails("", "");
    await delete_tblPersonProfilePhotoDetails("", "");
    final db = await database;
    PersonDetails personDetails = PersonDetails();
    personDetails.Person_Name = userDetails?.TaineeName ?? "N/A";
    personDetails.Person_ID = userDetails?.TraineeID ?? "-1";
    personDetails.MobileNo = userDetails?.MobileNo ?? "";
    personDetails.Class_Name = userDetails?.Class_Name ?? "N/A";
    personDetails.Section_Name = userDetails?.Section_Name ?? "";
    personDetails.UserType = "1";
    var insertValues = await db.insert(_tblPersonDetails, personDetails.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    if (insertValues > 0) {
      if (personProfilePhotoDetailsList.isNotEmpty) {
        if (personProfilePhotoDetailsList[0].embeedings.isNotEmpty &&
            personProfilePhotoDetailsList[0].embeedings != "" &&
            !personProfilePhotoDetailsList[0].embeedings.contains("String")) {
          PersonProfileDetails personProfileDetails = PersonProfileDetails();
          personProfileDetails.Profile_PersonID =
              userDetails?.TraineeID ?? "-1";
          personProfileDetails.Profile_Status = "1";
          personProfileDetails.IsSynced = "true";
          int insertValue = await db.insert(
            _tblPersonProfileDetails,
            personProfileDetails.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          if (insertValue > 0) {
            for (PersonProfilePhotoDetails personProfilePhotoDetails
                in personProfilePhotoDetailsList) {
              personProfilePhotoDetails.Person_Id =
                  await userDetails?.TraineeID ?? "-1";
              await db.insert(
                _tblPersonProfilePhotoDetails,
                personProfilePhotoDetails.toMapLogin(),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          }
        }
      }
    }
  }
}
