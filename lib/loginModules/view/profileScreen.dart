import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/appColors.dart';
import '../res/appStyles.dart';
import 'customWidgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceViewModel>(context, listen: false).loadData();
    });*/
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10,bottom: 10),
      color: AppColors.transparent, // 🔹 Make background transparent
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: CustomWidgets.showCulculerIconWithSize(
                Icons.person, false, AppColors.red, 60),
          ),
          SizedBox(width: 10,),
 /*         Consumer<AttendanceViewModel>(
            builder: (BuildContext context, attendanceViewModel, Widget? child) {
              return Expanded(
                child: AppStyles.textStyleForNormalWithBoldColor(
                  "User Name: ${attendanceViewModel.userDetails?.TaineeName}\nUser Designation: "
                      "${attendanceViewModel.userDetails?.TraineeDesignation}\nMobile Number: ${attendanceViewModel.userDetails?.MobileNo}",
                  AppColors.black,
                  16,
                ),);
            },
          ),*/
        ],
      ),
    );
  }
}
