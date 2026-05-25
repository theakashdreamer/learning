import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../data/storage/hive_storage.dart';
import '../../loginModules/dailogbox/loading_dialog.dart';
import '../../loginModules/data/localStorage.dart';
import '../../loginModules/data/sharePreferencesKeys.dart';
import '../../loginModules/entity/AmountOfCharges.dart';
import '../../loginModules/entity/MasterDataEntity.dart';
import '../../loginModules/globalClass/globalClass.dart';
import '../../loginModules/res/appStrings.dart';
import '../home_screen.dart';

class RegistrationDoneScreen extends StatefulWidget {
  const RegistrationDoneScreen({super.key});

  @override
  State<RegistrationDoneScreen> createState() => _RegistrationDoneScreenState();
}

class _RegistrationDoneScreenState extends State<RegistrationDoneScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.2),
                Image.asset("assets/images/Frame (4).png"),
                SizedBox(height: size.height * 0.025),
                Column(
                  children: const [
                    Text(
                      "Verified Successfully",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Your account has been verified successfully. You can now use our app to book the cabs. Have a great day!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.2),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      getMasterData();
                      getDataAccorTypeOfAmbulance();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      "Got It!",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getMasterData() async {
    CustomDialog.showLoadingDialog(
        context, AppStrings.getString("please_wait")!);
    await HiveStorage.init();
    String? bashUrl = await HiveStorage.fetchString(HiveStorage.keyURL);
    String? token = await HiveStorage.fetchString(HiveStorage.keyToken);
    final Map<String, dynamic> queryParams = {
      'mode': "GetMasterData",
    };
    // Define headers
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
        var data = response.body;
        Map<String, dynamic>? responseBody = jsonDecode(data);
        if (responseBody != null) {
          MasterDataEntity masterDataEntity =
              MasterDataEntity.fromMap(responseBody);
          List<dynamic> lstTypeofAmbulance = masterDataEntity.lstTypeofAmbulance;
          if (lstTypeofAmbulance.isNotEmpty) {}
        } else {
          GlobalClass.fetchToastPosition(response.body.toString());
          CustomDialog.dismissLoadingDialog(context);
        }
      } else {
        CustomDialog.dismissLoadingDialog(context);
        GlobalClass.fetchToastPosition(response.statusCode.toString());
      }
    } catch (e) {
      CustomDialog.dismissLoadingDialog(context);
      print('Error: $e');
    }
  }

  Future<void> getDataAccorTypeOfAmbulance() async {
    CustomDialog.showLoadingDialog(
        context, AppStrings.getString("please_wait")!);
    await HiveStorage.init();
    String? bashUrl = await HiveStorage.fetchString(HiveStorage.keyURL);
    String? token = await HiveStorage.fetchString(HiveStorage.keyToken);
    final Map<String, dynamic> queryParams = {
      'mode': "GetAmbulanceAmountOfCharges",
      'AM_TypeId': "1"
    };
    // Define headers
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
        var data = response.body;
        Map<String, dynamic>? responseBody = jsonDecode(data);
        if (responseBody != null) {
          AmountOfCharges amountOfCharges =
              AmountOfCharges.fromMap(responseBody);
          //  List<dynamic> lstTypeofAmbulance = masterDataEntity.lstTypeofAmbulance;
          if (amountOfCharges != null) {}
        } else {
          GlobalClass.fetchToastPosition(response.body.toString());
          CustomDialog.dismissLoadingDialog(context);
        }
      } else {
        CustomDialog.dismissLoadingDialog(context);
        GlobalClass.fetchToastPosition(response.statusCode.toString());
      }
    } catch (e) {
      CustomDialog.dismissLoadingDialog(context);
      print('Error: $e');
    }
  }
}
