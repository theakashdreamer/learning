import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../data/storage/hive_storage.dart';
import '../../routes/routesname.dart';
import '../../screens/forgotPassword/forgot_password_screen.dart';
import '../../screens/regestration/registration_screen.dart';
import '../data/sharePreferencesKeys.dart';
import '../entity/UserDetails.dart';
import '../entity/otp.dart';
import '../entity/pinUserRegister.dart';
import '../globalClass/globalClass.dart';
import '../res/appStrings.dart';

class LoginActivity extends StatefulWidget {
  const LoginActivity({super.key});

  @override
  State<LoginActivity> createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  var userNameController = TextEditingController();
  var userPinController = TextEditingController();
  bool isUserNameControllerEnabled = true;
  PinUserRegister? userRegister;
  FocusNode userNameFocusNode = FocusNode();
  FocusNode userPinFocusNode = FocusNode();
  bool isPasswordVisible = false;

  // Add these variables for login state
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;

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
    getDataForLocalStorage();
    _loadSavedCredentials();
  }

  void getDataForLocalStorage() async {
    await HiveStorage.init();
    String? otpSharePreferencesValues =
        await HiveStorage.fetchString(HiveStorage.keyCreatePin);
    if (otpSharePreferencesValues != null) {
      Map<String, dynamic> responseBody = jsonDecode(otpSharePreferencesValues);
      userRegister = PinUserRegister.fromMap(responseBody);
      if (userRegister!.User_Mobile.isNotEmpty &&
          userRegister!.User_Mobile.length == 10) {
        userNameController.text = userRegister!.User_Mobile;
        isUserNameControllerEnabled = false;
      }
    }
  }

  Future<void> _loadSavedCredentials() async {
    await HiveStorage.init();

    // Load remember me preference
    bool? rememberMe =
        await HiveStorage.fetchBool(SharePreferencesKeys.rememberMe);
    setState(() {
      _rememberMe = rememberMe ?? false;
    });

    // Load saved credentials if remember me is true
    if (_rememberMe) {
      String? savedUsername =
          await HiveStorage.fetchString(HiveStorage.keySavedUsername);
      String? savedPassword =
          await HiveStorage.fetchString(HiveStorage.keySavedPassword);

      if (savedUsername != null && savedUsername.isNotEmpty) {
        setState(() {
          userNameController.text = savedUsername;
          if (savedPassword != null && savedPassword.isNotEmpty) {
            userPinController.text = savedPassword;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.05),

              // Welcome back message
              SlideTransition(
                position: _animation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back!",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 32,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Login to continue",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.06),

              // Error message if any
              if (_errorMessage != null && _errorMessage!.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[100]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 16),
                        onPressed: () {
                          setState(() {
                            _errorMessage = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),

              // Phone Number TextField
              TextField(
                controller: userNameController,
                enabled: isUserNameControllerEnabled,
                focusNode: userNameFocusNode,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Phone Number",
                  hintText: "Enter your 10-digit mobile number",
                  prefixIcon: Icon(Icons.phone),
                  prefixText: "+91 ",
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                onChanged: (value) {
                  if (_errorMessage != null) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
              ),
              SizedBox(height: size.height * 0.025),

              // Password TextField
              TextField(
                controller: userPinController,
                focusNode: userPinFocusNode,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Password",
                  hintText: "Enter your password",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                onChanged: (value) {
                  if (_errorMessage != null) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
              ),
              SizedBox(height: size.height * 0.015),

              // Remember me and Forgot Password row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Remember Me Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                          _saveRememberMePreference(_rememberMe);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Text(
                        "Remember me",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),

                  // Forgot Password
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            _navigateToForgotPassword();
                          },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: _isLoading
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _performLogin();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.2),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: size.height * 0.025),

              // OR Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.025),

              // Register Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () {
                            _navigateToRegistration();
                          },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    userPinController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _navigateToForgotPassword() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const ForgotPasswordScreen(),
      ),
    );
  }

  void _navigateToRegistration() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const PersonDetailsRegistrationScreen(),
      ),
    );
  }

  void _navigateToOTPScreen(OTP otp) async {
    await HiveStorage.init();
    HiveStorage.saveBool(HiveStorage.keyLoginScreenStatus, true);
    Navigator.pushNamed(
      context,
      RoutesName.otpScreenActivity,
      arguments: otp,
    );
  }

  void _navigator(UserDetails userDetails) async {
    await HiveStorage.init();
    HiveStorage.saveBool(HiveStorage.keyLoginScreenStatus, true);

    // Save credentials if remember me is checked
    if (_rememberMe) {
      await HiveStorage.saveString(
        HiveStorage.keySavedUsername,
        userDetails.MobileNo ?? userNameController.text.trim(),
      );
      await HiveStorage.saveString(
        HiveStorage.keySavedPassword,
        userPinController.text.trim(),
      );
    } else {
      // Clear saved credentials
      await HiveStorage.saveString(HiveStorage.keySavedUsername, "");
      await HiveStorage.saveString(HiveStorage.keySavedPassword, "");
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.otpScreenActivity,
      arguments: userDetails,
      (route) => false,
    );
  }

  Future<void> _saveRememberMePreference(bool value) async {
    await HiveStorage.init();
    await HiveStorage.saveBool(HiveStorage.keyRememberMe, value);
  }

  void _performLogin() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Validate inputs
    final validationResult = _validateInputs();
    if (!validationResult.isValid) {
      setState(() {
        _errorMessage = validationResult.errorMessage;
      });

      // Focus on the field with error
      if (validationResult.focusNode != null) {
        FocusScope.of(context).requestFocus(validationResult.focusNode);
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (await GlobalClass.checkConnectivity()) {
        await _authenticateUser();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = AppStrings.getString('no_internet_connection');
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "An error occurred. Please try again.";
      });
    }
  }

  ValidationResult _validateInputs() {
    var userName = userNameController.text.trim();
    var userPin = userPinController.text.trim();

    if (userName.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: "Please enter mobile number",
        focusNode: userNameFocusNode,
      );
    }

    if (userName.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(userName)) {
      return ValidationResult(
        isValid: false,
        errorMessage: "Please enter a valid 10-digit mobile number",
        focusNode: userNameFocusNode,
      );
    }

    if (userPin.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: "Please enter password",
        focusNode: userPinFocusNode,
      );
    }
/*

    if (userPin.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(userPin)) {
      return ValidationResult(
        isValid: false,
        errorMessage: "Please enter a valid 6-digit PIN",
        focusNode: userPinFocusNode,
      );
    }
*/

    return ValidationResult(isValid: true);
  }

  Future<void> _authenticateUser() async {
    var userName = userNameController.text.trim();
    var userPin = userPinController.text.trim();

    try {
      // First try to get access token
      await getUserDetailsData(userName, userPin);

      // If successful, getUserDetailsData will be called from getAccessToken
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Login failed. Please check your credentials.";
      });
    }
  }

  Future<void> getAccessToken(String userName, String userPin) async {
    await HiveStorage.init();
    String? bashUrl = await HiveStorage.fetchString(HiveStorage.keyURL);

    if (bashUrl == null || bashUrl.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Server URL not configured";
      });
      return;
    }

    String controller = "Authenticate";
    String urlString = "$bashUrl$controller";
    String token = "$userName:$userPin";

    List<int> bt = utf8.encode(token);
    String encodedText = base64Encode(bt);
    String authToken = "Basic $encodedText";

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': authToken,
    };

    try {
      final response = await http
          .post(
            Uri.parse(urlString),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        if (data != null && data.toString() == "Authorized") {
          await HiveStorage.init();
          String? tokenFromHeader = response.headers["token"];
          if (tokenFromHeader != null) {
            await HiveStorage.saveString(
              HiveStorage.keyToken,
              tokenFromHeader,
            );
          }
          await getUserDetailsData(userName, userPin);
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = "Invalid username or password";
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Invalid credentials. Please try again.";
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "Server error (${response.statusCode})";
        });
      }
    } on http.ClientException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Network error. Please check your connection.";
      });
    } on TimeoutException {
      setState(() {
        _isLoading = false;
        _errorMessage = "Connection timeout. Please try again.";
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "An error occurred. Please try again.";
      });
    }
  }

  Future<void> getUserDetailsData(String userName, String userPin) async {
    await HiveStorage.init();
    String? bashUrl = await HiveStorage.fetchString(HiveStorage.keyURL);
    String? token = await HiveStorage.fetchString(HiveStorage.keyToken);

    final Map<String, dynamic> queryParams = {
      'mode': "LogIn",
      'un': userName,
      'pwd': userPin,
      "dvcId": "-1",
      'SA10_UserType': "4",
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Token': token ?? '',
    };

    String controller = "Login";
    String urlString = "$bashUrl$controller";
    final Uri uri = Uri.parse(urlString).replace(queryParameters: queryParams);

    try {
      final response = await http
          .get(
            uri,
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        var data = response.body;
        Map<String, dynamic>? responseBody = jsonDecode(data);

        if (responseBody != null) {
          UserDetails userDetails = UserDetails.fromMap(responseBody);

          if (userDetails.UserID.isNotEmpty &&
              userDetails.User_Pin.isNotEmpty) {
            setState(() {
              _isLoading = false;
            });

            // Navigate to OTP screen or main screen based on your flow
            _navigator(userDetails);
          } else {
            setState(() {
              _isLoading = false;
              _errorMessage = "Invalid user details received";
            });
          }
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = "Invalid response from server";
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "Server error (${response.statusCode})";
        });
      }
    } on TimeoutException {
      setState(() {
        _isLoading = false;
        _errorMessage = "Connection timeout. Please try again.";
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "An error occurred. Please try again.";
      });
    }
  }
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final FocusNode? focusNode;

  ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.focusNode,
  });
}

// Add these to your SharePreferencesKeys class
