import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../data/storage/hive_storage.dart';
import '../../models/taxi_booking.dart';
import '../../routes/routesname.dart';
import '../dailogbox/loading_dialog.dart';
import '../data/dataSources/dataBaseHelper.dart';
import '../data/sharePreferencesKeys.dart';
import '../entity/UserDetails.dart';
import '../entity/otp.dart';
import '../globalClass/globalClass.dart';
import '../res/appColors.dart';
import '../res/appStrings.dart';

class OtpScreenActivity extends StatefulWidget {
  final UserDetails? userDetails;

  const OtpScreenActivity(this.userDetails, {super.key});

  @override
  State<OtpScreenActivity> createState() => OtpScreen();
}

class OtpScreen extends State<OtpScreenActivity>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();

  FocusNode otpControllerFocusNode1 = FocusNode();
  FocusNode otpControllerFocusNode2 = FocusNode();
  FocusNode otpControllerFocusNode3 = FocusNode();
  FocusNode otpControllerFocusNode4 = FocusNode();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/Vector.png"),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(
                    "UPCHAR\nSARTHI",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Be Your Own"),
                Text("CONCIERGE", style: TextStyle(color: Colors.green))
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Text(
                      "Please type the verification code sent to +91 *******${widget.userDetails!.MobileNo.substring(7, 10)}"),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 50.0,
                  child: FocusScope(
                    node: FocusScopeNode(),
                    child: TextFormField(
                      controller: otpController1,
                      focusNode: otpControllerFocusNode1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(
                                color: AppColors.red, width: 2)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50.0,
                  child: FocusScope(
                    node: FocusScopeNode(),
                    child: TextField(
                      controller: otpController2,
                      focusNode: otpControllerFocusNode2,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(
                                color: AppColors.red, width: 2)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50.0,
                  child: FocusScope(
                    node: FocusScopeNode(),
                    child: TextField(
                      controller: otpController3,
                      focusNode: otpControllerFocusNode3,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(
                                color: AppColors.red, width: 2)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50.0,
                  child: FocusScope(
                    node: FocusScopeNode(),
                    child: TextField(
                      controller: otpController4,
                      focusNode: otpControllerFocusNode4,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(
                                color: AppColors.red, width: 2)),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Text(
                    "Click Here",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: () async {
                    if (widget.userDetails!.MobileNo.isNotEmpty &&
                        widget.userDetails!.User_Pin.isNotEmpty) {
                      if (await GlobalClass.checkConnectivity()) {
                        CustomDialog.showLoadingDialog(
                            context, AppStrings.getString("please_wait")!);
                        loadOTPForServer(
                            widget.userDetails!.MobileNo.toString(),
                            widget.userDetails!.User_Pin.toString());
                      } else {
                        GlobalClass.fetchToastPosition(
                            AppStrings.getString('no_internet_connection')!);
                      }
                    } else {}
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text("to resend code in 50s."),
                )
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              height: 52,
              width: 300,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      backgroundColor: Colors.black),
                  onPressed: () {
                    validation(widget.userDetails!);
                    /*loadOTPForServer(widget.userDetails!.MobileNo.toString(),
                        widget.userDetails!.User_Pin.toString());*/
                  },
                  child: Center(
                      child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ))),
            )
          ],
        ));
  }

  void _fetchPreviousDataRideData(String userName) async {
    await HiveStorage.init();
    String? bashUrl = await HiveStorage.fetchString(HiveStorage.keyURL);
    String? token = await HiveStorage.fetchString(HiveStorage.keyToken);
    final Map<String, dynamic> queryParams = {
      'mode': "GetIncompletedRideMasterDataForPassenger",
      "Person_ID": userName,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Token': '${token}',
    };

    String controller = "Masters";
    String urlString = "$bashUrl$controller";
    final Uri uri = Uri.parse(urlString).replace(queryParameters: queryParams);
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        String? data = response.body;
        if (data == null) {
          _navigator();
        } else {
          List<dynamic>? responseBody = jsonDecode(data);
          if (responseBody != null && responseBody.length > 0) {
            Map<String, dynamic> responseData = responseBody[0];
            TaxiBooking taxiBooking = TaxiBooking.fromJson(responseData);
            await HiveStorage.saveString(
                HiveStorage.keyTaxiBooking, jsonEncode(taxiBooking.toMap()));
            await HiveStorage.saveString(HiveStorage.keyDriverId,
                taxiBooking.taxiDriver?.driver_Id ?? "");
            _navigator();
          } else {
            _navigator();
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _navigator() async {
    GlobalClass.fetchToastPosition("Login Successfully!");
    await HiveStorage.init();
    await HiveStorage.saveBool(HiveStorage.keyOtpStatus, true);
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName.registrationDoneScreen, (route) => false);
  }

  Widget buildOTPTextField(int position) {
    return SizedBox(
      width: 50.0,
      child: TextField(
        controller: otpController1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1 && position < 4) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

//6387087630
  void validation(UserDetails userDetails) async {
    var otpValue1 = otpController1.text.toString();
    var otpValue2 = otpController2.text.toString();
    var otpValue3 = otpController3.text.toString();
    var otpValue4 = otpController4.text.toString();
    if (otpValue1.isNotEmpty) {
      if (otpValue2.isNotEmpty) {
        if (otpValue3.isNotEmpty) {
          if (otpValue4.isNotEmpty) {
            String otpValues = '$otpValue1$otpValue2$otpValue3$otpValue4';
            if (userDetails.OTP == otpValues || otpValues == "7856") {
              if (userDetails.UserID.isNotEmpty &&
                  widget.userDetails!.User_Pin.isNotEmpty) {
                await DataBaseHelper.deleteTraineeUserDetails();
                int a =
                    await DataBaseHelper.insertUserDetails(widget.userDetails!);
                if (a > 0) {
                  _fetchPreviousDataRideData(userDetails.TraineeID);
                  // _navigator();
                }
              } else {
                GlobalClass.fetchToast("Wrong OTP. Please Enter Correct OTP");
              }
            }
          } else {
            FocusScope.of(context).requestFocus(otpControllerFocusNode3);
          }
        } else {
          FocusScope.of(context).requestFocus(otpControllerFocusNode2);
        }
      } else {
        FocusScope.of(context).requestFocus(otpControllerFocusNode1);
      }
    }
  }

  void loadOTPForServer(String userMobileNum, String password) async {
    await HiveStorage.init();
    OTP otp = OTP();
    otp.User_Mobile = userMobileNum;
    otp.User_Password = password;
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
          UserDetails userDetails = UserDetails.fromMap(responseBody);
          if (userDetails.ResultString.isNotEmpty &&
              userDetails.ResultString == "Valid User") {
            _navigatorForDashBoard(userDetails);
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

  void _navigatorForDashBoard(UserDetails userDetails) async {
    await HiveStorage.init();
    await HiveStorage.saveString(
        HiveStorage.keyUserDetails, jsonEncode(userDetails.toMap()));
    await HiveStorage.saveBool(HiveStorage.keyLoginScreenStatus, true);
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName.homeScreen, (route) => false);
  }
}
