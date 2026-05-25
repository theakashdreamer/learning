import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/storage/hive_storage.dart';
import '../dailogbox/loading_dialog.dart';
import '../data/dataSources/dataBaseHelper.dart';
import '../data/localStorage.dart';
import '../data/sharePreferencesKeys.dart';
import '../res/appColors.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../res/appStrings.dart';

class GlobalClass {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

  static DateFormat get dateFormat => _dateFormat;

  static const platform =
      MethodChannel('com.technosysservices.eattendancekumbh/nitz_time');

  static const platformForLoc =
      MethodChannel('com.technosysservices.eattendancekumbh/location');

  static Future<bool> isMockLocationEnabled() async {
    try {
      final bool isMock = await platform.invokeMethod('isMockLocationEnabled');
      return isMock;
    } on PlatformException catch (e) {
      print("Failed to get mock location status: '${e.message}'.");
      return false;
    }
  }

  static void fetchToast(String toastValue) {
    Fluttertoast.showToast(
      msg: toastValue,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Future<bool> checkDateAndTime() async {
    Duration tolerance = Duration(seconds: 20);
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    DateTime localTime = dateFormat.parse(await GlobalClass.getDateAndTime());
    DateTime ntpTime =
        dateFormat.parse(await GlobalClass.getFormattedNtpTime());
    return isTimeWithinTolerance(localTime, ntpTime, tolerance);
  }

  static bool isTimeWithinTolerance(
      DateTime time1, DateTime time2, Duration tolerance) {
    return time1.difference(time2).abs() <= tolerance;
  }

  static void showTimeErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Incorrect Date & Time"),
          content: Text(
              "Your phone time is incorrect. Would you like to go to the Date & Time settings?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                _showSettingsInstructionDialog(context);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  static void _showSettingsInstructionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Instructions'),
          content: Text(
            'Unable to open date/time settings automatically. Please navigate to: '
            'Settings > System > Date & Time.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static const platformDateTimeSettings =
      MethodChannel('com.technosysservices.eattendancekumbh/settings');

  static Future<void> openDateTimeSettings() async {
    try {
      await platformDateTimeSettings.invokeMethod('openDateTimeSettings');
    } on PlatformException catch (e) {
      print("Failed to open date/time settings: '${e.message}'.");
    }
  }

  static void fetchToastPosition(String toastValue) {
    Fluttertoast.showToast(
      msg: "⚠️ $toastValue",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Future<String> getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    return packageName;
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  static Future<String> getLocalApp_ID(String peronID) async {
    DateTime parsedNitzTime = DateTime.now();
    if (peronID.isNotEmpty) {
      peronID = '0'; // peronID;
    } else {
      peronID = '0';
    }
    try {
      return "$peronID";
    } catch (e) {
      return "$peronID";
    }
  }

  static Future<String> getLocalApp_InstanceID(String peronID) async {
    DateTime parsedNitzTime = DateTime.now();
    if (peronID.isNotEmpty) {
      peronID = peronID;
    } else {
      var random = Random();
      peronID = random.nextDouble().toString();
    }
    try {
      return "$peronID${parsedNitzTime.millisecond}";
    } catch (e) {
      return "$peronID${parsedNitzTime.millisecond}";
    }
  }

  static Future<String> getAppBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.buildNumber;
    return version;
  }

  static Future<String> getAppName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    return appName;
  }

  static bool equalsIgnoreCase(String? string1, String? string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  static Uint8List decodeFromBase64(String base64String) {
    return base64Decode(base64String);
  }

  static String encodeDataToBase64ForAccessToken(String data) {
    List<int> bytes = utf8.encode(data); // Encode the data to UTF-8 bytes
    String encodedText = base64.encode(bytes); // Encode bytes to Base64 string
    return 'Basic ${encodedText.trim()}'; // Adjusting substring to match Java logic
  }

  static String encodeDataToBase64(String data) {
    List<int> bytes = utf8.encode(data); // Encode the data to UTF-8 bytes
    String encodedText = base64.encode(bytes); // Encode bytes to Base64 string
    return encodedText.trim(); // Adjusting substring to match Java logic\\
  }

  static String decodeDataToBase64(String data) {
    List<int> bytes = base64.decode(data); // Decode Base64 string to bytes
    String decodedText = utf8.decode(bytes); // Decode bytes to UTF-8 string
    return decodedText.trim(); // Adjusting substring to match Java logic
  }

  static String getDateAndTime() {
    var now = DateTime.now();
    String formattedDate = _dateFormat.format(now);
    return formattedDate;
  }

  static String getDateAndTimeDDMMYYYY() {
    var now = DateTime.now();
    var formatter = DateFormat('ddMMyyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  static DateTime parseCustomDate(String date) {
    var formatter = DateFormat('MM/dd/yyyy');
    return formatter.parse(date);
  }

  static String getDateAndTimeDDMMYYYYFormat() {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  static String getDateAndTimeForAppID() {
    var now = DateTime.now();
    var formatter = now.microsecondsSinceEpoch;
    return formatter.toString();
  }

  static Future<bool> checkConnectivity() async {
    List<ConnectivityResult> connectivityResults =
        await Connectivity().checkConnectivity();
    if (connectivityResults.isEmpty ||
        connectivityResults.contains(ConnectivityResult.none)) {
      return false;
    }
    return connectivityResults.contains(ConnectivityResult.wifi) ||
        connectivityResults.contains(ConnectivityResult.mobile) ||
        connectivityResults.contains(ConnectivityResult.ethernet);
  }

  static Future<File> compressDeleteAndSave(File originalFile) async {
    final compressedBytes = await FlutterImageCompress.compressWithFile(
      originalFile.path,
      minWidth: 1024,
      minHeight: 1024,
      quality: 40, // 40% quality (60% compression)
    );
    await originalFile.delete();
    final currentTime = DateTime.now();
    final fileName = 'compressed_${currentTime.microsecondsSinceEpoch}.jpg';
    final directory = await getApplicationSupportDirectory();
    final String writablePath = directory.path;
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final compressedFilePath = '$writablePath/$fileName';
    final compressedFile = File(compressedFilePath);
    if (compressedBytes != null) {
      await compressedFile.writeAsBytes(compressedBytes);
    }
    return compressedFile;
  }

  static Future<File?> compressDeleteAndSaveNew(File originalFile) async {
    try {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        originalFile.path,
        minWidth: 1024,
        minHeight: 1024,
        quality: 40, // 40% quality (60% compression)
      );

      if (compressedBytes == null) {
        throw Exception('Compression failed.');
      }

      final currentTime = DateTime.now();
      final fileName = 'compressed_${currentTime.microsecondsSinceEpoch}.jpg';
      final directory = await getApplicationSupportDirectory();
      final compressedFilePath = '${directory.path}/$fileName';

      final compressedFile = File(compressedFilePath);
      await compressedFile.writeAsBytes(compressedBytes);

      await originalFile.delete();

      return compressedFile;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static void setOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static Future<File> savedPhotoInLocalFormArray(var photoData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = '${directory.path}/EKhumb';
      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }
      final uuid = Uuid();
      final fileName = 'photo_${uuid.v4()}.png';
      final filePath = '$folderPath/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(photoData);
      return file;
    } catch (e) {
      print('Error saving photo: $e');
      rethrow;
    }
  }

  static Future<DateTime> getNtpTime() async {
    try {
      final ntpTime = await NTP.now();
      return ntpTime;
    } catch (e) {
      print('Error fetching NTP time: $e');
      return DateTime.now();
    }
  }

  static Future<String> getFormattedNtpTime() async {
    try {
      final ntpTime = await NTP.now();
      final formattedTime = _dateFormat.format(ntpTime);
      return formattedTime;
    } catch (e) {
      print('Error fetching NTP time: $e');
      return _dateFormat.format(DateTime.now());
    }
  }

  static final DateTime _gpsEpoch = DateTime.utc(1980, 1, 6);

  static var formatForDateOnly = DateFormat('HH:mm:ss');

  // Compute GPS time from current UTC time
  static Future<String> getGpsTime() async {
    try {
      final now = DateTime.now().toUtc();
      final difference = now.difference(_gpsEpoch);
      final gpsTimeInSeconds = difference.inSeconds;
      final gpsTimeDateTime =
          _gpsEpoch.add(Duration(seconds: gpsTimeInSeconds));
      final formattedGpsTime = _dateFormat.format(gpsTimeDateTime);
      return formattedGpsTime;
    } catch (e) {
      print('Error computing GPS time: $e');
      return _dateFormat.format(DateTime.now());
    }
  }

  static Future<String> getNITZTime() async {
    try {
      final String nitzTime = await platform.invokeMethod('getNitzTime');
      DateTime parsedNitzTime = DateTime.parse(nitzTime);
      return _dateFormat.format(parsedNitzTime);
    } catch (e) {
      print("Failed to get NITZ time: '${e}'.");
      return _dateFormat.format(DateTime.now());
    }
  }

  static Widget MethodForHeadingText(String s) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      child: Text(
        s,
        style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            decoration: TextDecoration.underline),
      ),
    );
  }

  static int getColorCode(int index) {
    List<int> colorIntegers = [
      /*4294967295, 4278190080, */
      4294901760,
      4278255360,
      4278190335,
      // White, Black, Red, Green, Blue
      4294967040,
      4294967040,
      4294934528,
      4294956800,
      4286611584,
      // Yellow, Orange, Dark Orange, Gold, Brown
      4289379272,
      4294944000,
      4289200128,
      4291546440,
      4288089680,
      // Coral, Deep Orange, Olive, Lime, Forest Green
      4293848814,
      4284782061,
      4294967091,
      4283215696,
      4287681600,
      // Violet, Teal, Cyan, Dark Blue, Navy Blue
      4291952895,
      4282339765,
      4287100926,
      4289336836,
      4290885376,
      // Pink, Magenta, Medium Purple, Lavender, Orchid
      4292935672,
      4287980912,
      4293925061,
      4288461018,
      4289421531,
      // Light Salmon, Peach, Rose, Chocolate, Sienna
      4291559424,
      4288501651,
      4282811060,
      4284379961,
      4290408192,
      // Light Green, Olive Drab, Mint, Slate Gray, Azure
      4286554111,
      4290414457,
      4288474442,
      4291649652,
      4292562052,
      // Aquamarine, Light Blue, Powder Blue, Beige, Antique White
      4289565087,
      4288585374,
      4292732169,
      4292731378,
      4285887861,
      // Silver, Gainsboro, Dark Cyan, Cyan, Midnight Blue
      4290445820,
      4289761612,
      4291745919,
      4287390585,
      4290910398,
      // Alice Blue, Pale Turquoise, Deep Sky Blue, Plum, Wheat
      4293842957,
      4294935268,
      4289600578,
      4292280769,
      4285593151,
      // Seashell, Linen, Misty Rose, Moccasin, Old Lace
      4291745417,
      4290764800,
      4289763839,
      4289416820,
      4293322490,
      // Sand, Sky Blue, Snow, Spring Green, Thistle
      4291572480,
      4292053248,
      4294571296,
      4287532826,
      4286057860,
      // Ivory, Lavender Blush, Peach Puff, Navajo White, Papaya Whip
      4294696000,
      4293053248,
      4291731324,
      4294307076,
      4294960400,
      // Pale Goldenrod, Pale Green, Pale Yellow, Tomato, White Smoke
      4289870712,
      4288059030,
      4291993805,
      4292811068,
      4289364431,
      // Slate Blue, Steel Blue, Powder Blue, Lemon Chiffon, Khaki
      4293971480,
      4288899642,
      4294908435,
      4293398269,
      4289638450,
      // Honeydew, Cornsilk, Goldenrod, Medium Aquamarine, Burlywood
      4287195300,
      4292730591,
      4294963440,
      4289843484,
      4290462565,
      // Medium Orchid, Medium Purple, Dark Khaki, Rosy Brown, Saddle Brown
      4288775677,
      4292347640,
      4290802176,
      4286780243,
      4293524640,
      // Blanched Almond, Hot Pink, Deep Pink, Dodger Blue, Fuchsia
      4294762464,
      4293784320,
      4289242931,
      4286630892,
      4286719103,
      // Orange Red, Dark Salmon, Medium Violet Red, Medium Sea Green, Medium Slate Blue
      4288600421,
      4290772993,
      4286360561,
      4294045031,
      4287868476,
      // Peach Puff, Peru, Rebecca Purple, Saddle Brown, Sandy Brown
      4289648972,
      4292028521,
      4290452055,
      4288599842,
      4289360191,
      // Tan, Tomato, Turquoise, Violet, Wheat
    ];

    return colorIntegers[index];
  }

  static Future<String> getVersionCode() async {
    return await GlobalClass.getAppVersion();
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  static String getDay(int weekday) {
    String day = "";
    if (weekday == 1) {
      day = "Monday";
    } else if (weekday == 2) {
      day = "Tuesday";
    } else if (weekday == 3) {
      day = "Wednesday";
    } else if (weekday == 4) {
      day = "Thursday";
    } else if (weekday == 5) {
      day = "Friday";
    } else if (weekday == 6) {
      day = "Saturday";
    } else if (weekday == 7) {
      day = "Sunday";
    } else {
      day = "Sunday";
    }
    return day;
  }

  static Future<void> getMasterData(BuildContext context) async {
    await HiveStorage.init();
    String? url = await HiveStorage.fetchString(HiveStorage.keyURL);
    final Map<String, dynamic> queryParams = {
      'mode': "GetGeoFenceMaster",
    };
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    String attendanceController = "Attendance";
    String urlString = "$url$attendanceController";
    CustomDialog.showLoadingDialog(context, "Alert...");
    final Uri uri = Uri.parse(urlString).replace(queryParameters: queryParams);
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        var data = response.body;
        Map<String, dynamic>? responseBody = jsonDecode(data);
        if (responseBody != null) {
         // GeofenceMaster geofenceMaster = GeofenceMaster.fromMap(responseBody);
        } else {
          GlobalClass.fetchToastPosition(AppStrings.getString(
              'something_went_to_wrong_please_try_again')!);
        }
        CustomDialog.dismissLoadingDialog(context);
      } else {
        GlobalClass.fetchToastPosition(response.body.toString());
        CustomDialog.dismissLoadingDialog(context);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static void showLocationErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Location Required'),
          content: Text('Location services are disabled or permission is denied. '
              'Please enable them in settings to proceed.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton(
              child: Text('Open Settings'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog
                AppSettings.openAppSettings(type: AppSettingsType.location);
              },
            ),
          ],
        );
      },
    );
  }
}
