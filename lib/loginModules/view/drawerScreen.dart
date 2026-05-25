import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../data/storage/hive_storage.dart';
import '../../routes/routesname.dart';
import '../data/dataSources/dataBaseHelper.dart';
import '../data/localStorage.dart';
import '../globalClass/globalClass.dart';
import '../res/appColors.dart';
import '../res/appStrings.dart';
import '../res/appStyles.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
           /*       Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.redAccent),
                    child: CircleAvatar(
                      backgroundColor: AppColors.textColor,
                      radius: 50,
                      child:  Consumer<AttendanceViewModel>(
                        builder: (BuildContext context, attendanceViewModel,
                            Widget? child) {
                         String? values =  attendanceViewModel.userDetails != null
                              ? attendanceViewModel.userDetails!.TaineeName.isEmpty
                              ? "U"
                              : attendanceViewModel.userDetails?.TaineeName.substring(0, 1)
                              : 'U';

                          return AppStyles.textStyleForNormalWithBoldColor(
                            values.toString(),
                            AppColors.white,
                            45,
                          );
                        },
                      ),
                    ),
                  ),
                  Consumer<AttendanceViewModel>(
                    builder: (BuildContext context, attendanceViewModel,
                        Widget? child) {
                      return Expanded(
                          child: AppStyles.textStyleForNormalWithBoldColor(
                        "Student Name: ${attendanceViewModel.userDetails?.TaineeName}",
                        AppColors.black,
                        16,
                      ));
                    },
                  ),
                  Consumer<AttendanceViewModel>(
                    builder: (BuildContext context, attendanceViewModel,
                        Widget? child) {
                      return Expanded(
                          child: AppStyles.textStyleForNormalWithBoldColor(
                        "Mobile Number: ${attendanceViewModel.userDetails?.MobileNo}",
                        AppColors.black,
                        16,
                      ));
                    },
                  ),*/
                  const SizedBox(
                    height: 3,
                  ),
                ],
              )),
          InkWell(
            onTap: () {
              _showDialog(context, Icons.logout,
                  AppStrings.getString('doYouWantExitApp')!, "logout");
            },
            child: ListTile(
              leading: CircleAvatar(
                //backgroundImage: AssetImage(ImagePaths.switchUser),
                child: Icon(Icons.logout),
              ),
              title: Text(
                AppStrings.getString('switchUser')!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutesName.aboutAppScreen);
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                //child: Image.asset(ImagePaths.logo),
                child: Icon(Icons.info),
              ),
              title: Text(
                AppStrings.getString('aboutApp')!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.pushNamed(context, RoutesName.aboutUsForAppScreen);
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.info_outline_rounded),
              ),
              title: Text(AppStrings.getString('institutionAboutUs')!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(
      BuildContext context, IconData icon, String hint, String forWhat) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 50,
                      color: Colors.red.shade900,
                    ),
                    AppStyles.textStyleForHintCenter(hint),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: AppStyles.btnAlertBoxDecoration(
                                    Colors.red.shade900),
                                child: Center(
                                  child: AppStyles.textStyleCenterWithOutSize(
                                      AppStrings.getString('no')!),
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () async {
                            switch (forWhat) {
                              case 'logout':
                                {
                                  Navigator.pop(context);
                                  clearSqliteDataAndSharePreferences(context);
                                }
                              case 'savedData':
                                {
                                  Navigator.pop(context);
                                  if (await GlobalClass.checkConnectivity()) {
                                    // await _SavingForServerInspectionData();
                                  } else {
                                    GlobalClass.fetchToast(AppStrings.getString(
                                        'no_internet_connection')!);
                                  }
                                }
                            }
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: AppStyles.btnAlertBoxDecoration(
                                    Colors.green.shade900),
                                child: Center(
                                  child: AppStyles.textStyleCenterWithOutSize(
                                      AppStrings.getString('yes')!),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  void clearSqliteDataAndSharePreferences(BuildContext context) async {
    await HiveStorage.init();
    await HiveStorage.clearAll();
    await DataBaseHelper.deleteTraineeUserDetails();
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName.loginScreen, (route) => false);
  }
}
