import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:schoolmanagementsystem/loginModules/data/dataSources/dataBaseHelper.dart';
import 'package:schoolmanagementsystem/loginModules/entity/UserDetails.dart';
import '../../data/storage/hive_storage.dart';
import '../../models/firebaseToken/fire_base_device_token.dart';
import '../../screens/home_screen.dart';
import '../../screens/onboarding/Onboardinghome.dart';
import '../../screens/select_city/select_mode.dart';
import '../../screens/select_city/selectcity.dart';
import '../data/localStorage.dart';
import '../data/sharePreferencesKeys.dart';
import '../globalClass/globalClass.dart';
import '../res/appStrings.dart';
import '../res/appStyles.dart';
import '../res/imagePaths.dart';
import 'loginActivity.dart';

class SplashActivity extends StatefulWidget {
  const SplashActivity({super.key});

  @override
  State<SplashActivity> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashActivity> {
  String data = "";
  late LocalStorage prefs;
  String? versionCode;
  UserDetails userDetails=UserDetails();

   String _baseUrl = "http://atmsapi.technosysservicesdemos.com/api/";
   String _registerPath = "FireBasePushNotification?mode=FireBaseDeviceTokenSave";
   String _verifyPath = "Auth/VerifyToken";
  LocalStorage localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    getLocalData();
    GlobalClass.setOrientation();
    initHiveStorage();
    getVersionCode();
  }

  void initHiveStorage() async {
    await HiveStorage.init();
    String? url = HiveStorage.fetchString(SharePreferencesKeys.URL);
    if (url == null || url.isEmpty) {
      if (await GlobalClass.checkConnectivity()) {
        fetchUrlFromServer();
      } else {
        GlobalClass.fetchToast(AppStrings.getString('no_internet_connection')!);
      }
    } else {
      // Call to the new combined token registration and verification method
      await initRegisterAndVerifyToken();
      gotoToNext();
    }
  }

  fetchUrlFromServer() async {
    final response =
    await http.get(Uri.parse(AppStrings.getString('baseUrl')!));
    if (response.statusCode == 200) {
      String result = json.decode(response.body)['Result'];
      if (result.isNotEmpty && result == "success") {
        String url = json.decode(response.body)['APIURL'];
        HiveStorage.saveString(HiveStorage.keyURL, url);
        // Call to the new combined token registration and verification method
        await initRegisterAndVerifyToken();
        gotoToNext();
      }
    } else {
      throw Exception('Failed to load posts');
    }
  }

  void getVersionCode() async {
    String code = await GlobalClass.getAppVersion();
    setState(() {
      versionCode = code;
    });
  }

  // Combined token registration and verification method
  Future<void> initRegisterAndVerifyToken() async {
    final messaging = FirebaseMessaging.instance;
    // Request notification permissions
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    // Get the initial token
    final token = await messaging.getToken();
    if (token == null) return;
    // Register the token and verify the user after successful registration
    if (userDetails.TraineeID.isNotEmpty && userDetails.TraineeID != "") {
      FireBaseDeviceToken fireBaseDeviceToken = FireBaseDeviceToken();
      fireBaseDeviceToken.deviceTokenCode = token;
      fireBaseDeviceToken.appId = 0;
      fireBaseDeviceToken.p02AddedBy = int.tryParse(userDetails.TraineeID.toString());
      fireBaseDeviceToken.o12AddedBy = int.tryParse(userDetails.Designation_ID.toString());
      fireBaseDeviceToken.SA10_UserType_Id = 4;
      // Register the token
      await _registerToken(fireBaseDeviceToken);
    }

    // Listen for token refresh to handle token expiration
    messaging.onTokenRefresh.listen((String refreshedToken) async {
      print("Token has been refreshed: $refreshedToken");
      // Handle the new token
      await _registerTokenWithNewToken(refreshedToken);
    });
  }

// Register the new token with the server
  Future<void> _registerTokenWithNewToken(String refreshedToken) async {
    if (userDetails.TraineeID.isNotEmpty && userDetails.TraineeID != "") {
      FireBaseDeviceToken fireBaseDeviceToken = FireBaseDeviceToken();
      fireBaseDeviceToken.deviceTokenCode = refreshedToken;
      fireBaseDeviceToken.appId = 0;
      fireBaseDeviceToken.p02AddedBy = int.tryParse(userDetails.TraineeID.toString());
      fireBaseDeviceToken.o12AddedBy = int.tryParse(userDetails.Designation_ID.toString());
      fireBaseDeviceToken.SA10_UserType_Id = 3;

      // Register the new token with the server
      await _registerToken(fireBaseDeviceToken);
    }
  }
  Future<void> _registerToken(FireBaseDeviceToken token) async {
    try {
      final res = await http.post(
        Uri.parse("$_baseUrl$_registerPath"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(token),
      );
      debugPrint("TOKEN REGISTER → ${res.statusCode}");
    } catch (e) {
      debugPrint("TOKEN REGISTER ERROR → $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(ImagePaths.splashScreen, fit: BoxFit.cover),
        ),
        Center(
            child: Container(
                child: Image.asset(
                  ImagePaths.splashScreenMidDesign,
                  width: 250,
                  height: 250,
                ))),
        Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: 0,
            right: 0,
            child: Center(
              child: AppStyles.textStyleForVersionCode(versionCode != null
                  ? 'Version $versionCode'
                  : 'Version 1.0.0'),
            ))
      ]),
    );
  }

  void gotoToNext() async {
    await HiveStorage.init();
    bool onBoardingStatus = await HiveStorage.fetchBool(HiveStorage.keyOnBoarding) ?? false;
    bool selectCity = await HiveStorage.fetchBool(HiveStorage.keySelectCity) ?? false;
    bool selectmode = await HiveStorage.fetchBool(HiveStorage.keySelectMode) ?? false;
    bool loginScreenStatus = await HiveStorage.fetchBool(HiveStorage.keyLoginScreenStatus) ?? false;
    bool otpStatus =
        await HiveStorage.fetchBool(HiveStorage.keyOtpStatus) ?? false;
    bool createPinScreenStatus =
        await HiveStorage.fetchBool(HiveStorage.keyCreatePinScreenStatus) ??
            false;
    bool masterScreenStatus =
        await HiveStorage.fetchBool(HiveStorage.keyMasterScreenStatus) ?? false;

    if (onBoardingStatus) {
      if (selectCity) {
        if (selectmode) {
          if (loginScreenStatus) {
            if (otpStatus) {
              Timer(
                  const Duration(seconds: 3),
                      () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen())));
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const LoginActivity()));
            }
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const LoginActivity()));
          }
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => Selectmode()));
        }
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const SelectCity()));
      }
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const Onboardinghome()));
    }
  }

  void getLocalData() async{
    userDetails=(await DataBaseHelper.getUserDetailsDetails())!;
  }
}
