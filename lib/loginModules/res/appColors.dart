import 'package:flutter/material.dart';

@immutable
class AppColors {
  static const Map<int, Color> darkBlueSwatch = {
    50: Color(0xFFF1A4B5),
    100: Color(0xFFEF899F),
    200: Color(0xFFF36F8C),
    300: Color(0xFFF8718E),
    400: Color(0xFFEF607F),
    500: Color(0xFFF5577A),
    600: Color(0xFFF56383),
    700: Color(0xFFF85E80),
    800: Color(0xFFFA476D),
    900: Color(0xFFFF3964),
  };
  static const grayDark = Color(0xFF404E57);
  static const grayLight = Color(0xFF8D8D94);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const gray = Color(0xFFA4A4A4);
  static const red = Color(0xFFB40303);
  static const transparent = Color(0x00000000);
  static const btnStartColor = Color(0xFF54546E);
  static const btnEndColor = Color(0xFFA8A8C5);
  static const btnCenterColor = Color(0xFF8F7B7B);
  static const green = Color(0xC515A40E);

  static const lightGreen = Color(0xC55BF154);
  static const veryLightGreen = Color(0xC58DFF88);

  static const transparentForImage = Color(0x9ED6DBDD);
  static const yellow = Color(0xFFE7CA0F);
  static const lightYellow = Color(0xFFFDEA7B);
  static const primary = Color(0xFFFF3964);
  static const lightbackground = Color(0xFFF3E8EA);

  static const backgroundColorPrimary = Color(0xFFFAF8F8);
  static const btnColor = Color(0xFF0E1635);
  static const grayLightForBC = Color(0xFFF1F6FE);
  static const textColor = Color(0xFF0E1635);

  static const Color lightBlue = Color(0xFFB8DEEC); // Light Blue
  static const Color lighterBlue = Color(0xFFDCE9EE); // lighter blue
  static const Color veryLighterBlue = Color(0xFFF6F7F8); // very lighter color

  static const Color pureWhite = Color(0xFFFDA906); // pure white
  static const Color lightGreyWhite = Color(0xFFF66E21); // Light grey-white
  static const Color softShadowWhite = Color(0xFFFF3964); // soft shadow white

  static const Color darkLightBlue = Color(0xFF49C1EE); // Light Blue
  static const Color darkLighterBlue = Color(0xFFA2DCF1); // lighter blue
  static const Color darkVeryLighterBlue =
      Color(0xFFD3E6EE); // very lighter color

  static const Color blue = Color(0xFF67A4FD); // Blue
  static const Color darkBlue = Color(0xFF1C64CC); // Dark Blue
  static const Color darkNavy = Color(0xFF0E1635); // Dark Navy
  static const MaterialColor darkBlueMaterialColor =
      MaterialColor(0xFF0E1635, darkBlueSwatch);

  static const refreshTextColor = Color(0xFFFF3964);

  const AppColors();
}
