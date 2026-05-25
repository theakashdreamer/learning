import 'package:flutter/material.dart';
import 'color.dart';

class AppTheme {
  static const colors = AppColors();

  const AppTheme._();

  static ThemeData define() {
    return ThemeData(
        fontFamily: "",
        primaryColor: Color(AppColors.grayDark as int),
        focusColor: Color(AppColors.grayLight as int));
  }
}
