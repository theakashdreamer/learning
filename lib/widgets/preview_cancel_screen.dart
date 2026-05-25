import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../loginModules/data/dataSources/dataBaseHelper.dart';
import '../../loginModules/globalClass/globalClass.dart';
import '../../loginModules/res/appColors.dart';
import '../../loginModules/res/appStrings.dart';
import '../../loginModules/res/appStyles.dart';

class PreviewCancelScreen extends StatefulWidget {
  final  draftDetails;
  PreviewCancelScreen({super.key, required this.draftDetails});

  @override
  State<PreviewCancelScreen> createState() => _PreviewCancelScreenState();
}

class _PreviewCancelScreenState extends State<PreviewCancelScreen> {

  @override
  void initState() {
    super.initState();
    _init();

  }
  Future<void> _init() async {

  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0), // Remove border radius
      ),
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [

            ],
          ),
        ),
      ),
    );
  }

}


