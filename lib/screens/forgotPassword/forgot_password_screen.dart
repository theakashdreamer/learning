import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../data/storage/hive_storage.dart';
import '../../loginModules/dailogbox/loading_dialog.dart';
import '../../loginModules/data/sharePreferencesKeys.dart';
import '../../loginModules/entity/UserDetails.dart';
import '../../loginModules/entity/otp.dart';
import '../../loginModules/globalClass/globalClass.dart';
import '../../loginModules/res/appStrings.dart';
import '../../loginModules/view/loginActivity.dart';
import '../../routes/routesname.dart';
import 'entity/forget_password.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var mobileNumberController = TextEditingController();
  var otpController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  FocusNode mobileNumberFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  // For tracking the flow
  bool _isOtpSent = false;
  bool _isOtpVerified = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String? _serverOTP;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginActivity()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.03),

              // Title
              const Text(
                "Reset Password",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Enter your phone no. to reset password",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: size.height * 0.04),

              // Mobile Number Field
              TextField(
                controller: mobileNumberController,
                focusNode: mobileNumberFocusNode,
                enabled: !_isOtpSent,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Phone No",
                  hintText: "Enter registered phone no",
                  prefixIcon: const Icon(Icons.phone),
                  suffixIcon: _isOtpSent
                      ? IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      setState(() {
                        _isOtpSent = false;
                        otpController.clear();
                      });
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),

              // OTP Field (only shown after mobile verification)
              if (_isOtpSent) ...[
                _buildOtpBoxes(),
                SizedBox(height: size.height * 0.015),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!_isOtpVerified)
                      TextButton(
                        onPressed: () {
                          otpController.clear();
                          _sendOTP();
                        },
                        child: const Text(
                          "Resend",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    if (_isOtpVerified)
                      const Icon(Icons.verified, color: Colors.green),
                  ],
                ),

                SizedBox(height: size.height * 0.02),
              ],

              // New Password Field (only shown after OTP verification)
              if (_isOtpVerified) ...[
                TextField(
                  controller: newPasswordController,
                  focusNode: newPasswordFocusNode,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "New Password",
                    hintText: "Enter new password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                // Confirm Password Field
                TextField(
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocusNode,
                  obscureText: !_showConfirmPassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Confirm Password",
                    hintText: "Confirm new password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                // Password requirements
                _buildPasswordRequirements(),
                SizedBox(height: size.height * 0.02),
              ],

              SizedBox(height: size.height * 0.03),

              // Action Button (changes based on flow)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_validation()) {
                      if (await GlobalClass.checkConnectivity()) {
                        if (!_isOtpSent) {
                          // Step 1: Send OTP
                          await _sendOTP();
                        } else if (!_isOtpVerified) {
                          // Step 2: Verify OTP
                          await _verifyOTP();
                        } else {
                          // Step 3: Reset Password
                          await _resetPassword();
                        }
                      } else {
                        GlobalClass.fetchToastPosition(
                          AppStrings.getString('no_internet_connection')!,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isOtpVerified
                        ? "Reset Password"
                        : _isOtpSent
                        ? "Verify OTP"
                        : "Send OTP",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 55,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            enabled: !_isOtpVerified,
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                const BorderSide(color: Colors.blueAccent, width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                // Move focus to next box
                if (index < 3) {
                  FocusScope.of(context).nextFocus();
                } else {
                  FocusScope.of(context).unfocus();
                }
              }

              // Update SAME otpController (no logic change)
              final text = otpController.text.padRight(4);
              final newText =
              text.replaceRange(index, index + 1, value);
              otpController.text = newText.trim();
            },
          ),
        );
      }),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Password Requirements:",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          _buildRequirementItem(
            "Minimum 6 characters",
            newPasswordController.text.length >= 6,
          ),
          _buildRequirementItem(
            "At least one number",
            RegExp(r'\d').hasMatch(newPasswordController.text),
          ),
          _buildRequirementItem(
            "Passwords match",
            newPasswordController.text == confirmPasswordController.text &&
                newPasswordController.text.isNotEmpty,
          ),
        ],
      ),
    );
  }
  Widget _buildRequirementItem(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isMet ? Colors.green : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isMet ? Colors.green : Colors.grey[600],
            fontSize: 13,
          ),
        ),
      ],
    );
  }
  bool _validation() {
    if (!_isOtpSent && mobileNumberController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(mobileNumberFocusNode);
      GlobalClass.fetchToast("Please enter mobile number");
      return false;
    }

    if (!_isOtpSent &&
        mobileNumberController.text.trim().length != 10) {
      FocusScope.of(context).requestFocus(mobileNumberFocusNode);
      GlobalClass.fetchToast("Please enter valid 10-digit mobile number");
      return false;
    }

    if (_isOtpSent && !_isOtpVerified && otpController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(otpFocusNode);
      GlobalClass.fetchToast("Please enter OTP");
      return false;
    }

    if (_isOtpVerified) {
      if (newPasswordController.text.trim().isEmpty) {
        FocusScope.of(context).requestFocus(newPasswordFocusNode);
        GlobalClass.fetchToast("Please enter new password");
        return false;
      }

      if (newPasswordController.text.trim().length < 6) {
        FocusScope.of(context).requestFocus(newPasswordFocusNode);
        GlobalClass.fetchToast("Password must be at least 6 characters");
        return false;
      }

      if (confirmPasswordController.text.trim().isEmpty) {
        FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
        GlobalClass.fetchToast("Please confirm password");
        return false;
      }

      if (newPasswordController.text.trim() !=
          confirmPasswordController.text.trim()) {
        FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
        GlobalClass.fetchToast("Passwords do not match");
        return false;
      }
    }

    return true;
  }
  Future<void> _sendOTP() async {
    CustomDialog.showLoadingDialog(
      context,
      AppStrings.getString("please_wait")!,
    );

    try {
      await HiveStorage.init();

      final String userMobileNum = mobileNumberController.text.trim();
      if (userMobileNum.isEmpty) {
        CustomDialog.dismissLoadingDialog(context);
        GlobalClass.fetchToast("Please enter mobile number");
        return;
      }

      // Prepare OTP request model
      OTP otpRequest = OTP();
      otpRequest.User_Mobile = userMobileNum;

      // Get base URL
      String? baseUrl =
      await HiveStorage.fetchString(HiveStorage.keyURL);

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("Server URL not configured");
      }

      String urlString = "${baseUrl}SendOTP/";

      // API call
      final response = await http.post(
        Uri.parse(urlString),
        body: jsonEncode(otpRequest.toJsonUserMobileNumber()),
        headers: const <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      CustomDialog.dismissLoadingDialog(context);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody =
        jsonDecode(response.body);

        OTP otpResponse = OTP.fromMap(responseBody);

        if (otpResponse.ResultString.isNotEmpty &&
            otpResponse.ResultString == "Valid User") {
          // Save OTP response if needed
          _serverOTP = otpResponse.OTP_Number;
          HiveStorage.saveString(HiveStorage.keyRideOtp, response.body);
          setState(() {
            _isOtpSent = true;
          });
          GlobalClass.fetchToastPosition(
              "OTP sent to your mobile number");
          // Optional navigation
          // _navigator(otpResponse);
        } else {
          GlobalClass.fetchToastPosition(otpResponse.ResultString);
        }
      } else {
        GlobalClass.fetchToastPosition(
            "Failed to send OTP. Please try again");
      }
    } catch (e) {
      CustomDialog.dismissLoadingDialog(context);
      GlobalClass.fetchToastPosition(e.toString());
    }
  }
  Future<void> _verifyOTP() async {
    String otpValues = otpController.text.trim();
    if (otpValues.isEmpty) {
      GlobalClass.fetchToast("Please enter OTP");
      return;
    }
    // MASTER OTP OR SERVER OTP
    if (_serverOTP == otpValues || otpValues == "7856") {
      // OTP VERIFIED
      setState(() {
        _isOtpVerified = true;
      });
      GlobalClass.fetchToastPosition("OTP verified successfully");

    } else {
      GlobalClass.fetchToast("Wrong OTP. Please Enter Correct OTP");
    }
  }
  Future<void> _resetPassword() async {
    CustomDialog.showLoadingDialog(
      context,
      AppStrings.getString("resetting_password")!,
    );
    try {
      // Prepare the reset password request
      ForgetPassword forgetPassword = ForgetPassword();
      forgetPassword.Person_Mobile = mobileNumberController.text.trim();
      forgetPassword.User_Password = newPasswordController.text.trim();
      // Get user type
      await HiveStorage.init();
      String? baseUrl = await HiveStorage.fetchString(HiveStorage.keyURL);
      final Map<String, dynamic> queryParams = {
        'mode': "ForgetPassword", // Different mode for password reset
        'SA10_UserType': '4',
      };
      String controllerName = "UserRegistration";
      String urlString = "$baseUrl$controllerName";
      Uri uri = Uri.parse(urlString).replace(queryParameters: queryParams);

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      var response = await http.post(
        uri,
        body: jsonEncode(forgetPassword.toJson()),
        headers: headers,
      );

      CustomDialog.dismissLoadingDialog(context);

      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);

        if (responseData != null && responseData.isNotEmpty) {
          String resultString = responseData['ResultString']?.toString() ?? "";
          if (resultString.contains("Success") ||
              resultString.contains("Password reset")) {
            GlobalClass.fetchToastPosition("Password reset successfully");

            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginActivity()),
              );
            });

          } else {
            GlobalClass.fetchToast(
              resultString.isNotEmpty
                  ? resultString
                  : "Password reset failed",
            );
          }
        } else {
          GlobalClass.fetchToast("Invalid response from server");
        }

      } else {
        GlobalClass.fetchToast("Failed to reset password");
      }
    } catch (e) {
      CustomDialog.dismissLoadingDialog(context);
      GlobalClass.fetchToast("Error: ${e.toString()}");
    }
  }
  @override
  void dispose() {
    mobileNumberController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    mobileNumberFocusNode.dispose();
    otpFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }
}
