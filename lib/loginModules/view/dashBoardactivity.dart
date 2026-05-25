import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../data/newtwork/base_api_services.dart';
import '../../data/newtwork/network_api_services.dart';
import '../../data/storage/hive_storage.dart';
import '../../loginModules/data/dataSources/dataBaseHelper.dart';
import '../../loginModules/data/localStorage.dart';
import '../../loginModules/data/sharePreferencesKeys.dart';
import '../../loginModules/entity/loginDetails.dart';
import '../../loginModules/entity/updateActivity.dart';
import '../../loginModules/globalClass/globalClass.dart';
import '../../loginModules/res/appColors.dart';
import '../../loginModules/res/appStrings.dart';
import '../../loginModules/res/appStyles.dart';
import '../../routes/routesname.dart';
import '../entity/dashboardUiModel.dart';
import '../res/imagePaths.dart';
import '../view/customWidgets.dart';
import 'drawerScreen.dart';

class DashBoardActivity extends StatefulWidget {
  const DashBoardActivity({super.key});

  @override
  _DashboardScreen createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashBoardActivity>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  String? _versionCode;
  LoginDetails? _login;
  var height, width;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BaseApiService networkApiService = NetworkApiService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserDetails();
    });
  }

  void getUserDetails() {
  //  final itemSpecVM = context.read<MasterDataItemClassificationAndSpecificationViewModel>();
 //   final entityVM = context.read<MasterPMShreeEntityViewModel>();
   // final qrDetailsVM = context.read<Qrdetailsviewmodel>();
   /* itemSpecVM.loadData();
    entityVM.loadData();
    qrDetailsVM.loadData();*/
  }

  Future<void> getVersionCode() async {
    String code = await GlobalClass.getAppVersion();
    setState(() {
      _versionCode = code;
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 4 - 20;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 🔹 Make background transparent
        elevation: 0,
        title: Text("Dashboard"),
        actions: [
          Visibility(
            visible: true,
            child: InkWell(
              onTap: () {
              //  saveData();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: const Icon(Icons.sync, color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerScreen(),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              ImagePaths.background,
              fit: BoxFit.cover,
            ),
          ),

/*          SafeArea(
            child: Column(
              children: [
                SizedBox(width: double.infinity, child: ProfileScreen()),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Consumer<MasterDataItemClassificationAndSpecificationViewModel>(
                          builder: (BuildContext context,
                              masterDataItemClassificationAndSpecificationViewModel,
                              Widget? child) {
                            if (masterDataItemClassificationAndSpecificationViewModel
                                .progress) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return _teacherDashBoard(
                                masterDataItemClassificationAndSpecificationViewModel);
                          },
                        ),
                        Consumer<InfrastructureViewModel>(
                          builder: (BuildContext context, infrastructureViewModel, Widget? child) {
                            if (infrastructureViewModel.progress) {
                              return Center(child: CircularProgressIndicator());
                            } else if (infrastructureViewModel
                                .errorMessage.isNotEmpty) {
                              return SizedBox();
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  Widget widgetText(String text, TextStyle style) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10),
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }

/*  Widget widgetGridView(
      List<DashboardUiModel> dataList,
      int crossAxisCount,
      double childAspectRatio,
      MasterDataItemClassificationAndSpecificationViewModel masterDataViewModel) {
    List<SurveyCountStatusWise> masterPMShreeEntityViewModelList =
        masterDataViewModel.surveyCountStatusWiseList;
    Map<String, SurveyCountStatusWise> masterPMShreeEntityViewModelListMap = {
      for (var item in masterPMShreeEntityViewModelList) item.Status_ID: item
    };

    for (var data in dataList) {
      if (masterPMShreeEntityViewModelListMap.containsKey(data.ID)) {
        data.Values =
            masterPMShreeEntityViewModelListMap[data.ID]?.Status_Values ?? "0";
      } else {
        data.Values = "0";
      }
    }
    return GridView.builder(
      itemCount: dataList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: childAspectRatio),
      itemBuilder: (context, index) {
        final item = dataList[index];
        return GestureDetector(
            child: Container(
          decoration: AppStyles.btnBoxDecorationWithOutShadow(
              AppColors.lightBlue,
              AppColors.lighterBlue,
              AppColors.veryLighterBlue),
          child: GestureDetector(
            onTap: () {
              _navigator(context, item.WhichTypeUI);
            },
            child: Container(
              height: 150,
              width: 150,
              child: CustomWidgets.sizeBoxWithCardImageAndTextNEw(
                  item.ImagePath, item.Text, item.Values ?? "0"),
            ),
          ),
        ));
      },
    );
  }*/

  Widget widgetCardImageAndTextCard(List<DashboardUiModel> dataList,
      bool forCard, int crossAxisCount, double childAspectRatio) {
    return GridView.builder(
      itemCount: dataList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: childAspectRatio),
      itemBuilder: (context, index) {
        final item = dataList[index];
        return GestureDetector(
            child: Container(
          decoration: AppStyles.btnBoxDecorationWithOutShadow(
              AppColors.lightBlue,
              AppColors.lighterBlue,
              AppColors.veryLighterBlue),
          child: GestureDetector(
            onTap: () {
              _navigator(context, item.WhichTypeUI);
            },
            child: Container(
              height: 150,
              width: 150,
              child: CustomWidgets.sizeBoxWithCardImageAndTextCard(
                  item.ImagePath, item.Text, true),
            ),
          ),
        ));
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigator(BuildContext context, String forWhat) async {
    await HiveStorage.init();
    String routes;
    if (forWhat == "survey") {
      forWhat = "survey";
      routes = RoutesName.schoolListDetailsScreen;
    } else if (forWhat == "surveyReport") {
      forWhat = "surveyReport";
      routes = RoutesName.schoolListDetailsScreen;
    } else if (forWhat == "schoolsAssigned") {
      forWhat = "-1";
      routes = RoutesName.schoolListDetailsScreen;
    } else if (forWhat == "pendingForSurvey") {
      forWhat = "1";
      routes = RoutesName.schoolListDetailsScreen;
    } else if (forWhat == "inProgress") {
      forWhat = "2";
      routes = RoutesName.schoolListDetailsScreen;
    } else if (forWhat == "interruptedSurveys") {
      forWhat = "3";
      routes = RoutesName.schoolListDetailsScreen;
    } else if (forWhat == "surveysOnHold") {
      forWhat = "4";
      routes = RoutesName.schoolListDetailsScreen;
    } else if (forWhat == "completedSurveys") {
      forWhat = "5";
      routes = RoutesName.schoolListDetailsScreen;
    } else if (forWhat == "generateQR") {
      forWhat = "generateQR";
      routes = RoutesName.qrScanPage;
    } else if (forWhat == "requestQRCode") {
      forWhat = "requestQRCode";
      routes = RoutesName.requestForQRData;
    } else if (forWhat == "walkingTrack") {
      forWhat = "walkingTrack";
      routes = RoutesName.walkingTrack;
    } else {
      forWhat = "survey";
      routes = RoutesName.schoolListDetailsScreen;
    }

    Navigator.pushNamed(context, routes, arguments: forWhat);
  }

  void clearSqliteDataAndSharePreferences() async {
    await HiveStorage.init();
    await HiveStorage.clearAll();
    await DataBaseHelper.deleteTraineeUserDetails();
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName.loginScreen, (route) => false);
  }

  Future<void> initPlatformState() async {
    if (await GlobalClass.checkConnectivity()) {
      // await isAppOutdated();
      await countSurveyDataOnServer("");
    } else {
      GlobalClass.fetchToastPosition(
          AppStrings.getString('no_internet_connection')!);
    }
  }

  Future<void> countSurveyDataOnServer(String forWhat) async {
    int countPersonDetails =
        0; //await DataBaseHelper.countSTMSInspectionDetailsTrue("'false'");
    if (countPersonDetails > 0) {
      _showDialog(
          Icons.info, AppStrings.getString('savedDataOnServer')!, "savedData");
    } else {
      if (forWhat.isNotEmpty) {
        GlobalClass.fetchToastPosition(
            AppStrings.getString('alreadySavedDataOnServer')!);
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  Future<List<UpdateActivity>> loadValuesForUpdate() async {
    List<UpdateActivity> listAppInfo = [];
    try {
      UpdateActivity updateActivity = UpdateActivity();
      updateActivity.apkFileName = await GlobalClass.getAppName();
      updateActivity.apkUrl = "";
      updateActivity.appDescription = "";
      updateActivity.appName = await GlobalClass.getAppName();
      updateActivity.autoUpdate = "";
      updateActivity.deviceUpdateRequestID = "";
      updateActivity.forceUpdate = "";
      updateActivity.isUpdateAvailable = "";
      updateActivity.packageName = await GlobalClass.getPackageName();
      updateActivity.updateMessage = "";
      updateActivity.versionCode = await GlobalClass.getAppBuildNumber();
      updateActivity.versionName = await GlobalClass.getAppVersion();
      updateActivity.appDeviceID = "";
      updateActivity.appUserID = "";
      updateActivity.SA05_UserID = "";
      if (Platform.isAndroid) {
        updateActivity.AppID = "4";
      } else {
        //android = 4 and  AOS =3
        updateActivity.AppID = "3";
      }
      listAppInfo.add(updateActivity);
    } catch (e) {
      e.toString();
    }
    return listAppInfo;
  }

  Future<UpdateActivity> loadValuesForUpdateNew() async {
    UpdateActivity updateActivity = UpdateActivity();
    try {
      updateActivity.apkFileName = await GlobalClass.getAppName();
      updateActivity.apkUrl = "";
      updateActivity.appDescription = "";
      updateActivity.appName = await GlobalClass.getAppName();
      updateActivity.autoUpdate = "";
      updateActivity.deviceUpdateRequestID = "";
      updateActivity.forceUpdate = "";
      updateActivity.isUpdateAvailable = "";
      updateActivity.packageName = await GlobalClass.getPackageName();
      updateActivity.updateMessage = "";
      updateActivity.versionCode = await GlobalClass.getAppVersion();
      updateActivity.versionName = await GlobalClass.getAppBuildNumber();
      updateActivity.appDeviceID = "";
      updateActivity.appUserID = "";
      updateActivity.SA05_UserID = "";
      updateActivity.AppID = "3";
    } catch (e) {
      e.toString();
    }
    return updateActivity;
  }

  // update modules
  Future<void> isAppOutdated() async {
    if (Platform.isAndroid) {
      String version = await GlobalClass.getAppVersion();
      String latestAppVersion = '1.0.1';
      if (version != latestAppVersion) {
        if (await GlobalClass.checkConnectivity()) {
          await isAppUpdateAvailableAndroid();
        }
      }
    } else if (Platform.isIOS) {
      String version = await GlobalClass.getAppVersion();
      String latestAppVersion = '1.0.2'; // on appstore
      if (version != latestAppVersion) {
        if (await GlobalClass.checkConnectivity()) {
          await isAppUpdateAvailable();
        }
      }
    } else {
      String version = await GlobalClass.getAppVersion();
      String latestAppVersion = '1.0.0';
      if (version != latestAppVersion) {
        if (await GlobalClass.checkConnectivity()) {
          await isAppUpdateAvailable();
        }
      }
    }
  }

  Future<void> isAppUpdateAvailable() async {
    await HiveStorage.init();
    String urlMain =
        await HiveStorage.fetchString(HiveStorage.keyURL) ?? "";
    List<UpdateActivity> updateActivity = await loadValuesForUpdate();
    String controller = "CheckRequestForAppsUpdate";
    String urlString = "$urlMain$controller";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept-Encoding': 'gzip',
    };
    final Uri uri = Uri.parse(urlString);
    String encodedData = jsonEncode(UpdateActivity.listToMap(updateActivity));
    final response = await http.post(uri, headers: headers, body: encodedData);
    if (response.statusCode == 200) {
      String resData = response.body;
      if (resData.isNotEmpty) {
        if (!GlobalClass.equalsIgnoreCase(resData, "null")) {
          List<UpdateActivity> appsUpdateInfoList =
              (jsonDecode(resData) as List)
                  .map((data) => UpdateActivity.fromMap(data))
                  .toList();
          if (appsUpdateInfoList.isNotEmpty) {
            if (appsUpdateInfoList[0].isUpdateAvailable.isNotEmpty &&
                GlobalClass.equalsIgnoreCase(
                    appsUpdateInfoList[0].isUpdateAvailable, "yes")) {
              showAppUpdateAlertDialog(context);
            }
          }
        }
      }
    }
  }

  Future<void> isAppUpdateAvailableAndroid() async {
    await HiveStorage.init();
    String urlMain =
        await HiveStorage.fetchString(HiveStorage.keyURL) ?? "";
    List<UpdateActivity> updateActivity = await loadValuesForUpdate();
    String controller = "CheckRequestForAppsUpdate";
    String urlString = "$urlMain$controller";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept-Encoding': 'gzip',
    };
    final Uri uri = Uri.parse(urlString);
    String encodedData = jsonEncode(UpdateActivity.listToMap(updateActivity));
    final response = await http.post(uri, headers: headers, body: encodedData);
    if (response.statusCode == 200) {
      String resData = response.body;
      if (resData.isNotEmpty) {
        if (!GlobalClass.equalsIgnoreCase(resData, "null")) {
          List<UpdateActivity> appsUpdateInfoList =
              (jsonDecode(resData) as List)
                  .map((data) => UpdateActivity.fromMap(data))
                  .toList();
          if (appsUpdateInfoList.isNotEmpty) {
            if (appsUpdateInfoList[0].isUpdateAvailable.isNotEmpty &&
                GlobalClass.equalsIgnoreCase(
                    appsUpdateInfoList[0].isUpdateAvailable, "yes")) {
              showAppUpdateAlertDialogAndroid(context);
            }
          }
        }
      }
    }
  }

  void showAppUpdateAlertDialog(BuildContext context) async {
    String appName = await GlobalClass.getAppName();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appName,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black)),
          content: Text(AppStrings.getString('yourAppNotUpdated')!,
              style: TextStyle(fontSize: 16, color: AppColors.black)),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Update'),
              onPressed: () async {
                String appStoreUrlForIOS =
                    'https://apps.apple.com/in/app/samajkalyan-inspection/id6496284456';
                // String appStoreUrlForAndroid = 'https://apps.apple.com/in/app/samajkalyan-inspection/id6496284456';
                if (await canLaunch(appStoreUrlForIOS)) {
                  await launch(appStoreUrlForIOS);
                  setState(() {
                    Navigator.of(context).pop();
                  });
                } else {
                  throw 'Could not launch $appStoreUrlForIOS';
                }
              },
            ),
          ],
        );
      },
    );
  }

  void showAppUpdateAlertDialogAndroid(BuildContext context) async {
    String appName = await GlobalClass.getAppName();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appName,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black)),
          content: Text(AppStrings.getString('yourAppNotUpdated')!,
              style: TextStyle(fontSize: 16, color: AppColors.black)),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Update'),
              onPressed: () async {
                String appStoreUrlForAndroid =
                    'https://play.google.com/store/apps/details?id=com.technosysservices.samajkalyaninspectionandroid&hl=en';
                if (await canLaunch(appStoreUrlForAndroid)) {
                  await launch(appStoreUrlForAndroid);
                  //Navigator.of(context).pop(); // Pop the AlertDialog
                } else {
                  throw 'Could not launch $appStoreUrlForAndroid';
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(IconData icon, String hint, String forWhat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                                  clearSqliteDataAndSharePreferences();
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

/*  Widget _teacherDashBoard(
      MasterDataItemClassificationAndSpecificationViewModel
          masterDataViewModel) {
    double width = MediaQuery.of(context).size.width / 3;
    double childAspectRatio = width / 100;
    return Column(
      children: [
        // Grid 1
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          child: widgetGridView(DashboardUiModel.totalList, 2, childAspectRatio,
              masterDataViewModel),
        ),

        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: widgetCardImageAndTextCard(
                  DashboardUiModel.surveyList, false, 2, 1.5),
            ),
          ),
        ),
      ],
    );
  }*/

 /* saveData() async {
    await context.read<InfrastructureViewModel>().loadData();
    await context.read<InfrastructureViewModel>().syncedItemStock();
    await context.read<InfrastructureViewModel>().syncedIndividualItemStock();
  }*/
}
