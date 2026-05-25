import '../res/imagePaths.dart';

class DashboardUiModel {
  String? _ID;
  String? _Text;
  String? _ImagePath;
  String? _IsActive;
  String? _WhichTypeUI;
  String? _Values;

  DashboardUiModel(this._ID, this._Text, this._ImagePath, this._IsActive, this._WhichTypeUI, this._Values);

  static List<DashboardUiModel> totalList = [
    DashboardUiModel("-1", "Assigned\nSchools", ImagePaths.attendance, "-1", "schoolsAssigned", '0'),
    DashboardUiModel("1", "Pending for\nSurvey", ImagePaths.attendance, "1", "pendingForSurvey", '0'),
    DashboardUiModel("2", "In Progress", ImagePaths.attendance, "2", "inProgress", '0'),
    DashboardUiModel("3", "Interrupted\nSurveys", ImagePaths.syllabus, "3", "interruptedSurveys", '0'),
    DashboardUiModel("4", "Surveys\nOn Hold", ImagePaths.syllabus, "4", "surveysOnHold", '0'),
    DashboardUiModel("5", "Completed\nSurveys", ImagePaths.syllabus, "5", "completedSurveys", '0'),
  ];

  static List<DashboardUiModel> surveyList = [
    DashboardUiModel("2", "Manage Item", ImagePaths.attendance, "2", "surveyReport", '0'),
    DashboardUiModel("3", "Print QR Code", ImagePaths.attendance, "3", "generateQR", '0'),
    DashboardUiModel("4", "Request For QR Code", ImagePaths.attendance, "3", "requestQRCode", '0'),

    DashboardUiModel("5", "Walking Track", ImagePaths.attendance, "3", "walkingTrack", '0'),
  ];

  String get ID => _ID ?? "";

  set ID(String value) {
    _ID = value ?? "";
  }

  String get Text => _Text ?? "";

  set Text(String value) {
    _Text = value ?? "";
  }

  String get WhichTypeUI => _WhichTypeUI ?? "";

  set WhichTypeUI(String value) {
    _WhichTypeUI = value ?? "";
  }

  String get IsActive => _IsActive ?? "";

  set IsActive(String value) {
    _IsActive = value ?? "";
  }

  String get ImagePath => _ImagePath ?? "";

  set ImagePath(String value) {
    _ImagePath = value ?? "";
  }

  String? get Values => _Values ?? "0";

  set Values(String? value) {
    _Values = value ?? "0";
  }
}
