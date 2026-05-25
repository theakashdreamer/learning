import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../data/storage/hive_storage.dart';
import '../../routes/routesname.dart';
import '../data/localStorage.dart';
import '../data/sharePreferencesKeys.dart';
import '../entity/otp.dart';
import '../globalClass/globalClass.dart';
import '../res/appColors.dart';
import '../res/appStrings.dart';
import '../res/appStyles.dart';
import '../res/customDialog/customDialog.dart';
import '../res/imagePaths.dart';

class RegisterWithMobileNumberActivity extends StatefulWidget {
  const RegisterWithMobileNumberActivity({super.key});

  @override
  State<RegisterWithMobileNumberActivity> createState() => RegistrationMobileNumber();
}

class RegistrationMobileNumber extends State<RegisterWithMobileNumberActivity> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  var userMobileNumber = TextEditingController();
  var userPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColors.white,
            ),
            Column(
              children: [
                Container(
                    height: 230,
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 30),
                    child: Image.asset(ImagePaths.logo, fit: BoxFit.cover)),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: AppStyles.btnBoxDecorationWithCurve(
                        AppColors.pureWhite,
                        AppColors.lightGreyWhite,
                        AppColors.softShadowWhite),
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 40, bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 40, bottom: 0),
                              child: Text(
                                  AppStrings.getString(
                                      'registerYourMobileNumber')!,
                                  style: AppStyles
                                      .styleHintExtraLargeSizeWithYellow)),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            child: TextField(
                              maxLines: 1,
                              maxLength: 10,
                              controller: userMobileNumber,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: AppStyles.inputEditTextBorder(
                                  AppStrings.getString('enterNumber')!,
                                  const Icon(Icons.phone,
                                      color: AppColors.black)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Hero(
                                    tag: 'Next',
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        validation();
                                        //_navigator();
                                      },
                                      style: AppStyles.primaryButtonStyle,
                                      child: Text(AppStrings.getString('next')!,
                                          style: AppStyles.buttonTextStyle),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

//AppStyles
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigator(OTP otp) {
    Navigator.pushNamed(context, RoutesName.otpScreenActivity,arguments: otp);
  }

  void loadOTPForServer(String userMobileNum) async {
    await HiveStorage.init();
    OTP otp = OTP();
    otp.User_Mobile = userMobileNum;
    String? url = await HiveStorage.fetchString(HiveStorage.keyURL);
    String sendOTP = "SendOTP/";
    String urlString = "$url$sendOTP";
    try {
      if (url != null || (url ?? "").isNotEmpty) {
        final response = await http.post(
          Uri.parse(urlString),
          body: jsonEncode(otp.toJsonUserMobileNumber()),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        CustomDialog.dismissLoadingDialog(context);
        if (response.statusCode == 200) {
          String resData = response.body;
          Map<String, dynamic> responseBody = jsonDecode(resData);
          OTP otp = OTP.fromMap(responseBody);
          if (otp.ResultString.isNotEmpty && otp.ResultString == "Valid User") {
            HiveStorage.saveString(HiveStorage.keyRideOtp, resData);
            _navigator(otp);
          } else {
            GlobalClass.fetchToastPosition(otp.ResultString);
          }
        } else {
          GlobalClass.fetchToastPosition(response.toString());
        }
      } else {
        GlobalClass.fetchToastPosition(
            "Something Went To Wrong. Please Try Again");
      }
    } catch (e) {
      GlobalClass.fetchToastPosition(e.toString());
      e.toString();
    }
  }

  void showDialog() {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Please Wait~');
  }

  void validation() async {
    var userMobileNum = userMobileNumber.text.toString();
    if (userMobileNum.isNotEmpty) {
      if (userMobileNum.length == 10) {
        if (await GlobalClass.checkConnectivity()) {
          CustomDialog.showLoadingDialog(
              context, AppStrings.getString("please_wait")!);
          loadOTPForServer(userMobileNum);
          // _navigator();
        } else {
          GlobalClass.fetchToastPosition(
              AppStrings.getString('no_internet_connection')!);
        }
      } else {
        GlobalClass.fetchToastPosition("Please Fill Current Mobile Number");
      }
    } else {
      GlobalClass.fetchToastPosition("Please Fill User Mobile Number");
    }
  }
}
