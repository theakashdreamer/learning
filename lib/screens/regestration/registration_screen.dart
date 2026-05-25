import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../data/storage/hive_storage.dart';
import '../../loginModules/RegistrationModule/UserRegistration.dart';
import '../../loginModules/dailogbox/loading_dialog.dart';
import '../../loginModules/data/localStorage.dart';
import '../../loginModules/data/sharePreferencesKeys.dart';
import '../../loginModules/entity/UserDetails.dart';
import '../../loginModules/entity/otp.dart';
import '../../loginModules/globalClass/globalClass.dart';
import '../../loginModules/res/appStrings.dart';
import '../../loginModules/view/loginActivity.dart';
import '../../loginModules/view/otpScreenActivity.dart';
import '../../routes/routesname.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PersonDetailsRegistrationScreen extends StatefulWidget {
  const PersonDetailsRegistrationScreen({super.key});

  @override
  State<PersonDetailsRegistrationScreen> createState() =>
      _PersonDetailsRegistrationScreenState();
}

class _PersonDetailsRegistrationScreenState
    extends State<PersonDetailsRegistrationScreen> {
  // Controllers
  late final userRegistrationNameController = TextEditingController();
  late final userRegistrationMobNoController = TextEditingController();
  late final userRegistrationEmailController = TextEditingController();
  late final userRegistrationPinController = TextEditingController();
  late final userRegistrationConfirmPinController = TextEditingController();

  // Focus Nodes
  late final userRegistrationNameFocusNode = FocusNode();
  late final userRegistrationMobNoFocusNode = FocusNode();
  late final userRegistrationEmailFocusNode = FocusNode();
  late final userRegistrationPinFocusNode = FocusNode();
  late final userRegistrationConfirmPinFocusNode = FocusNode();

  // Form Key for validation
  final _formKey = GlobalKey<FormState>();

  // State variables
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    _disposeFocusNodes();
    super.dispose();
  }

  void _setupControllers() {
    // Setup any controller listeners if needed
  }

  void _disposeControllers() {
    userRegistrationNameController.dispose();
    userRegistrationMobNoController.dispose();
    userRegistrationEmailController.dispose();
    userRegistrationPinController.dispose();
    userRegistrationConfirmPinController.dispose();
  }

  void _disposeFocusNodes() {
    userRegistrationNameFocusNode.dispose();
    userRegistrationMobNoFocusNode.dispose();
    userRegistrationEmailFocusNode.dispose();
    userRegistrationPinFocusNode.dispose();
    userRegistrationConfirmPinFocusNode.dispose();
  }

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
          onPressed: () => _navigateToLogin(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.03),

                // Title Section
                _buildTitleSection(),

                SizedBox(height: size.height * 0.04),

                // Full Name Field
                _buildNameField(size),

                SizedBox(height: size.height * 0.02),

                // Mobile Field
                _buildMobileField(size),

                SizedBox(height: size.height * 0.02),

                // Email Field
                _buildEmailField(size),

                SizedBox(height: size.height * 0.02),

                // Password Field
                _buildPasswordField(size),

                SizedBox(height: size.height * 0.02),

                // Confirm Password Field
                _buildConfirmPasswordField(size),

                SizedBox(height: size.height * 0.03),

                // Create Account Button
                _buildRegisterButton(size),

                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Register",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 32,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Create your account",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(Size size) {
    return TextFormField(
      controller: userRegistrationNameController,
      focusNode: userRegistrationNameFocusNode,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r"[a-zA-Z\s]"),
        ),
      ],
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your full name';
        }
        if (RegExp(r'\d').hasMatch(value)) {
          return 'Name should not contain numbers';
        }
        return null;
      },

      decoration: _buildInputDecoration(
        label: "Full Name",
        prefixIcon: Icons.person,
      ),

      onFieldSubmitted: (_) =>
          userRegistrationMobNoFocusNode.requestFocus(),
    );
  }

  Widget _buildMobileField(Size size) {
    return TextFormField(
      controller: userRegistrationMobNoController,
      focusNode: userRegistrationMobNoFocusNode,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter mobile number';
        }
        if (value.length != 10) {
          return 'Mobile number must be 10 digits';
        }
        return null;
      },
      decoration: _buildInputDecoration(
        label: "Mobile No.",
        prefixIcon: Icons.phone,
      ),
      onFieldSubmitted: (_) => userRegistrationEmailFocusNode.requestFocus(),
    );
  }

  Widget _buildEmailField(Size size) {
    return TextFormField(
      controller: userRegistrationEmailController,
      focusNode: userRegistrationEmailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter email address';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      decoration: _buildInputDecoration(
        label: "Email",
        prefixIcon: Icons.mail_outline,
      ),
      onFieldSubmitted: (_) => userRegistrationPinFocusNode.requestFocus(),
    );
  }

  Widget _buildPasswordField(Size size) {
    return TextFormField(
      controller: userRegistrationPinController,
      focusNode: userRegistrationPinFocusNode,
      obscureText: !_isPasswordVisible,
      maxLength: 6,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        }
        if (value.length != 6) {
          return 'Password must be 6 digits';
        }
        return null;
      },
      decoration: _buildInputDecoration(
        label: "Password",
        prefixIcon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
      onFieldSubmitted: (_) => userRegistrationConfirmPinFocusNode.requestFocus(),
    );
  }

  Widget _buildConfirmPasswordField(Size size) {
    return TextFormField(
      controller: userRegistrationConfirmPinController,
      focusNode: userRegistrationConfirmPinFocusNode,
      obscureText: !_isConfirmPasswordVisible,
      maxLength: 6,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm password';
        }
        if (value != userRegistrationPinController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
      decoration: _buildInputDecoration(
        label: "Confirm Password",
        prefixIcon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
        ),
      ),
      onFieldSubmitted: (_) => _registerUser(),
    );
  }

  Widget _buildRegisterButton(Size size) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _registerUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Text(
          "Create Account",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: label,
      prefixIcon: Icon(prefixIcon),
      suffixIcon: suffixIcon,
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
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Future<void> _registerUser() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (userRegistrationPinController.text !=
        userRegistrationConfirmPinController.text) {
      GlobalClass.fetchToast(AppStrings.getString('mismatch')!);
      return;
    }

    setState(() => _isLoading = true);

    final lstUserRegistration = <UserRegistration>[];
    final userRegistration = UserRegistration()
      ..Person_FirstName = userRegistrationNameController.text
      ..Person_Mobile1 = userRegistrationMobNoController.text
      ..Person_Email_Personal = userRegistrationEmailController.text
      ..User_LoginName = userRegistrationMobNoController.text
      ..User_Password = userRegistrationPinController.text.trim();

    lstUserRegistration.add(userRegistration);

    if (await GlobalClass.checkConnectivity()) {
      await _savingRegistration(lstUserRegistration);
    } else {
      GlobalClass.fetchToastPosition(
        AppStrings.getString('no_internet_connection')!,
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _savingRegistration(
      List<UserRegistration> lstUserRegistration,
      ) async {
    CustomDialog.showLoadingDialog(
      context,
      AppStrings.getString("please_wait")!,
    );

    await HiveStorage.init();
    final bashUrl = await HiveStorage.fetchString(HiveStorage.keyURL);
    if (bashUrl == null || bashUrl.isEmpty) {
      CustomDialog.dismissLoadingDialog(context);
      GlobalClass.fetchToastPosition("Server URL not configured");
      return;
    }
    try {
      final queryParams = {'mode': "UserRegistration"};
      final controllerName = "UserRegistration";
      final urlString = "$bashUrl$controllerName";
      final uri = Uri.parse(urlString).replace(queryParameters: queryParams);
      final headers = {'Content-Type': 'application/json'};
      final data = UserRegistration.listOfToMap(lstUserRegistration);

      final response = await http.post(
        uri,
        body: jsonEncode(data),
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      CustomDialog.dismissLoadingDialog(context);

      if (response.statusCode == 200) {
        await _handleRegistrationResponse(response.body);
      } else {
        GlobalClass.fetchToastPosition(
          "Server error: ${response.statusCode}",
        );
      }
    } on http.ClientException catch (e) {
      CustomDialog.dismissLoadingDialog(context);
      GlobalClass.fetchToastPosition("Network error: ${e.message}");
    } catch (e) {
      CustomDialog.dismissLoadingDialog(context);
      GlobalClass.fetchToastPosition("Error: ${e.toString()}");
    }
  }
  Future<void> _handleRegistrationResponse(String responseBody) async {
    try {
      final listFromJson = jsonDecode(responseBody);
      if (listFromJson.isNotEmpty) {
        if (listFromJson[0]['ResultString'].toString().trim() == "Already Registered") {
          CustomDialog.dismissLoadingDialog(context);
          GlobalClass.fetchToast(AppStrings.getString('AlreadyRegister')!);
          UserDetails userDetails=UserDetails();
          userDetails.MobileNo=listFromJson[0]['Person_Mobile1'];
          userDetails.User_Pin=listFromJson[0]['User_Password'];
          _navigatorForOTP(userDetails);
        } else {
          if (listFromJson[0]['ResultString'].toString().trim() == "Success") {
            CustomDialog.dismissLoadingDialog(context);
            GlobalClass.fetchToastPosition("data_saved_successfully");
            UserDetails userDetails=UserDetails();
            userDetails.MobileNo=listFromJson[0]['Person_Mobile1'];
            userDetails.User_Pin=listFromJson[0]['User_Password'];
            _navigatorForOTP(userDetails);
          }
        }
      }
    } catch (e) {
      GlobalClass.fetchToastPosition("Error parsing response");
    }
  }
  Future<void> _navigatorForOTP(UserDetails userDetails) async {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.loginScreen,
      arguments: (userDetails, "Registration"),
          (route) => false,
    );
  }
  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginActivity()),
    );
  }

  Future<void> _loadOTPForServer(String userMobileNum) async {
    await HiveStorage.init();
    final otp = OTP()..User_Mobile = userMobileNum;
    final url = await HiveStorage.fetchString(HiveStorage.keyURL);

    if (url == null || url.isEmpty) {
      GlobalClass.fetchToastPosition("Server URL not configured");
      return;
    }

    try {
      final urlString = "$url${"SendOTP/"}";
      final response = await http.post(
        Uri.parse(urlString),
        body: jsonEncode(otp.toJsonUserMobileNumber()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 30));

      CustomDialog.dismissLoadingDialog(context);

      if (response.statusCode == 200) {
        await _handleOTPResponse(response.body);
      } else {
        GlobalClass.fetchToastPosition("Server error: ${response.statusCode}");
      }
    } catch (e) {
      GlobalClass.fetchToastPosition("Error: ${e.toString()}");
    }
  }

  Future<void> _handleOTPResponse(String responseBody) async {
    try {
      final responseBodyJson = jsonDecode(responseBody);
      final otp = OTP.fromMap(responseBodyJson);

      if (otp.ResultString.isNotEmpty && otp.ResultString == "Valid User") {
        await HiveStorage.saveString(HiveStorage.keyRideOtp, responseBody);

        if (otp.OTP_Number != null) {
          final userDetails = UserDetails()
            ..OTP = otp.OTP_Number.toString()
            ..MobileNo = otp.User_Mobile;
          _navigatorForOTP(userDetails);
        }
      } else {
        GlobalClass.fetchToastPosition(otp.ResultString);
      }
    } catch (e) {
      GlobalClass.fetchToastPosition("Error parsing OTP response");
    }
  }
}
