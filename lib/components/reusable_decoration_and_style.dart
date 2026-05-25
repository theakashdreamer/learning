import 'package:flutter/material.dart';

import '../loginModules/res/appColors.dart';


class ReusableDecorationAndStyle {
  List<dynamic> dynamicList = [];
  static dynamic selectedGender;

  static InputDecoration inputDecoration(String text) {
    return InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(
          fontSize: 14,
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.yellow)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.red)),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.yellow)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        fillColor: Colors.grey.shade100,
        filled: true,
        border: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(0.0),
            borderSide: const BorderSide(
          color: Colors.orange,
          width: 1,
        )));
  }

  static InputDecoration inputDecorationWithPhoneSuffixIcon(String text) {
    return InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(
          fontSize: 14,
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange)),
        focusedBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        fillColor: Colors.grey.shade100,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        suffixIcon: Icon(Icons.phone_android_outlined, color: Colors.orange),
        border: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(0.0),
            borderSide: const BorderSide(
          color: Colors.orange,
          width: 1,
        )));
  }

  static InputDecoration inputDecorationWithSuffixIcon(
      String text, Icon iconData) {
    return InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(
          fontSize: 14,
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange)),
        fillColor: Colors.grey.shade100,
        filled: true,
        focusedBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        suffixIcon: iconData,
        border: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(0.0),
            borderSide: const BorderSide(
          color: Colors.orange,
          width: 1,
        )));
  }

  static TextStyle textStyle() {
    return const TextStyle(fontSize: 14);
  }
}
