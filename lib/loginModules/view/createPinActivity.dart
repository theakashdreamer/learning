import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../data/storage/hive_storage.dart';
import '../entity/otp.dart';
import '../entity/pinUserRegister.dart';
import '../globalClass/globalClass.dart';
import '../res/appColors.dart';
import '../res/appStrings.dart';
import '../res/appStyles.dart';
import '../res/customDialog/customDialog.dart';
import '../res/imagePaths.dart';
import 'loginActivity.dart';

class CreatePinActivity extends StatefulWidget {
  const CreatePinActivity({super.key});

  @override
  State<CreatePinActivity> createState() => _CreatePinActivityState();
}

class _CreatePinActivityState extends State<CreatePinActivity>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  var userNameController = TextEditingController();
  var userPinController = TextEditingController();
  var userConfirmPinController = TextEditingController();
  bool isUserNameControllerEnabled = true;
  late OTP? oTP;
  FocusNode userNameFocusNode = FocusNode();
  FocusNode userPinFocusNode = FocusNode();
  FocusNode userConfirmPinFocusNode = FocusNode();
  var userMobileNumber = TextEditingController();
  var userPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataForHiveStorage();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  void getDataForHiveStorage() async {
    await HiveStorage.init();
    String? otpSharePreferencesValues =
        await HiveStorage.fetchString(HiveStorage.keyOtp);
    if (otpSharePreferencesValues != null) {
      Map<String, dynamic> responseBody = jsonDecode(otpSharePreferencesValues);
      oTP = OTP.fromMap(responseBody);
      if (oTP!.User_Mobile.isNotEmpty && oTP!.User_Mobile.length == 10) {
        userNameController.text = oTP!.User_Mobile;
        isUserNameControllerEnabled = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(ImagePaths.background, fit: BoxFit.cover)),
          Column(children: [
            SafeArea(
              child: Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Image.asset(ImagePaths.logo, fit: BoxFit.fill)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                    child: Text(
                        AppStrings.getString('please_create_four_digit_pin')!,
                        style: AppStyles.styleHintExtraLargeSizeWithYellow)),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: FocusScope(
                    node: FocusScopeNode(),
                    child: TextField(
                      maxLines: 1,
                      maxLength: 10,
                      focusNode: userNameFocusNode,
                      keyboardType: TextInputType.number,
                      controller: userNameController,
                      enabled: isUserNameControllerEnabled,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: AppStyles.inputEditTextBorder("User Number",
                          const Icon(Icons.phone, color: AppColors.grayDark)),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: FocusScope(
                    node: FocusScopeNode(),
                    child: TextField(
                      maxLines: 1,
                      maxLength: 4,
                      focusNode: userPinFocusNode,
                      controller: userPinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: AppStyles.inputEditTextBorderWithOutIcon(
                          AppStrings.getString('enter_pin_here')!),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: FocusScope(
                    node: FocusScopeNode(),
                    child: TextField(
                      maxLines: 1,
                      maxLength: 4,
                      focusNode: userConfirmPinFocusNode,
                      controller: userConfirmPinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: AppStyles.inputEditTextBorderWithOutIcon(
                          AppStrings.getString('enter_confirm_pin_here')!),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: (MediaQuery.of(context).size).width * 0.5,
                          height: 45,
                          child: Hero(
                            tag: 'Log',
                            child: ElevatedButton(
                              onPressed: () async {
                                validation();
                                //_navigator();
                              },
                              style: AppStyles.primaryButtonStyle,
                              child: Text(AppStrings.getString('create_pin')!,
                                  style: AppStyles.buttonTextStyle),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }

  void _navigator() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => const LoginActivity()));
  }

  @override
  void dispose() {
    userNameController.dispose();
    userPinController.dispose();
    userConfirmPinController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void loadDataOnServerForCreatePin(String userName, String userPin) async {
    await HiveStorage.init();
    String? url = await HiveStorage.fetchString(HiveStorage.keyURL);
    String? otpSharePreferencesValues =
        await HiveStorage.fetchString(HiveStorage.keyRideOtp);
    Map<String, dynamic> responseBody = jsonDecode(otpSharePreferencesValues!);
    OTP otp = OTP.fromMap(responseBody);
    String sendOTP = "Register/";

    PinUserRegister pinUserRegister = PinUserRegister();
    pinUserRegister.User_Mobile = userName;
    pinUserRegister.Pin = userPin;
    pinUserRegister.Post_Id = otp.Post_Id.toString();
    String urlString = "$url$sendOTP";
    try {
      if (url != null || url!.isNotEmpty) {
        final response = await http.post(
          Uri.parse(urlString),
          body: jsonEncode(pinUserRegister.toMap()),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        CustomDialog.dismissLoadingDialog(context);
        if (response.statusCode == 200) {
          String resData = response.body;
          Map<String, dynamic> responseBody = jsonDecode(resData);
          pinUserRegister = PinUserRegister.fromMap(responseBody);
          if (pinUserRegister.ResultString.isNotEmpty &&
              GlobalClass.equalsIgnoreCase(
                  pinUserRegister.ResultString, "success")) {
            HiveStorage.saveString(HiveStorage.keyCreatePin, resData);
            HiveStorage.saveBool(HiveStorage.keyCreatePinScreenStatus, true);
            _navigator();
          } else {
            GlobalClass.fetchToastPosition(
                "Something Went To Wrong. Please Try Again");
          }
        } else {
          GlobalClass.fetchToastPosition(response.toString());
        }
      } else {
        GlobalClass.fetchToastPosition(
            "Something Went To Wrong. Please Try Again");
      }
    } catch (e) {
      e.toString();
    }
  }

  void validation() async {
    var userName = userNameController.text.toString();
    var userPin = userPinController.text.toString();
    var userConfirmPin = userConfirmPinController.text.toString();
    if (userPin.isNotEmpty) {
      if (userConfirmPin.isNotEmpty) {
        if (userPin == userConfirmPin) {
          if (await GlobalClass.checkConnectivity()) {
            CustomDialog.showLoadingDialog(
                context, AppStrings.getString("please_wait")!);
            loadDataOnServerForCreatePin(userName, userPin);
          } else {
            GlobalClass.fetchToastPosition(
                AppStrings.getString('no_internet_connection')!);
          }
        } else {
          GlobalClass.fetchToastPosition(
              AppStrings.getString("please_enter_correct_pin") ?? "");
        }
      } else {
        FocusScope.of(context).requestFocus(userConfirmPinFocusNode);
      }
    } else {
      FocusScope.of(context).requestFocus(userPinFocusNode);
    }
  }
}
