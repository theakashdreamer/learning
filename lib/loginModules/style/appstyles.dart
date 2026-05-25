import 'package:flutter/material.dart';

import '../strings/appstrings.dart';
import '../theme/color.dart';

class AppStyles {
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static InputDecoration inputEditTextBorder(String hintText, Icon icon) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.black),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.grayLight, width: 2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.grayDark, width: 2)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.grayLight, width: 2)),
      prefixIcon: icon,
    );
  }

  static InputDecoration inputDecorationForSearchbar(String hintText) {
    return InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.grayLight, width: 2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(vertical: 10));
  }

  static InputDecoration inputEditTextBorderWithOutIcon(String? hintText1) {
    return InputDecoration(
      hintText: hintText1 ?? "",
      hintStyle: const TextStyle(color: AppColors.black),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.grayLight, width: 2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.grayDark, width: 2)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.grayLight, width: 2)),
    );
  }

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.white,
  );

  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.grayDark,
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static Text textStyleForHint(String strValue) {
    return (Text(strValue,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.black)));
  }

  static Text textStyleForHintCenter(String strValue) {
    return (Text(strValue,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.black)));
  }

  static Text textStyleForNormalWithBold(String strValue) {
    return (Text(
      strValue,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.start,
      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.black),
    ));
  }

  static Text textStyleForNormalWithBoldRedColorText(String strValue) {
    return (Text(
      strValue,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.start,
      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.red),
    ));
  }

  static Text textStyleForNormalWithBoldColor(String strValue, Color color) {
    return (Text(
      strValue,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.start,
      style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
    ));
  }

  static Text textStyleForNormalWithBoldSize18(String strValue) {
    return (Text(
      strValue,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.start,
      style: const TextStyle(
          fontWeight: FontWeight.bold, color: AppColors.black, fontSize: 16),
    ));
  }

  static Text textStyleForVersionCode(String strValue) {
    return (Text(
      strValue,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.start,
      style: const TextStyle(
          fontWeight: FontWeight.bold, color: AppColors.white, fontSize: 18),
    ));
  }

  static Text textStyleForVersionCodeBlack(String strValue) {
    return (Text(
      strValue,
      overflow: TextOverflow.visible,
      textAlign: TextAlign.start,
      style: const TextStyle(
          fontWeight: FontWeight.bold, color: AppColors.black, fontSize: 18),
    ));
  }

  static Text textStyleForNormalCenter(String? strValue) {
    return (Text(
      strValue ?? "N/A",
      overflow: TextOverflow.visible,
      style: const TextStyle(
          fontWeight: FontWeight.normal, color: AppColors.black),
    ));
  }

  static Text questionText(String? strValue) {
    return (Text(
      strValue ?? "N/A",
      overflow: TextOverflow.visible,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ));
  }

  static Text dynamicQuestionText(String? strValue) {
    return (Text(
      strValue ?? "N/A",
      overflow: TextOverflow.visible,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ));
  }

  static Text textStyleCenterWithOutSize(String? strValue) {
    return (Text(
      strValue ?? "N/A",
      textAlign: TextAlign.center,
      overflow: TextOverflow.visible,
      style: const TextStyle(
          fontWeight: FontWeight.bold, color: AppColors.white, fontSize: 16),
    ));
  }

  static Text textStyleCenterTextWithColor(
      String? strValue, Color color, double fontSize) {
    return (Text(
      strValue ?? "N/A",
      textAlign: TextAlign.start,
      overflow: TextOverflow.visible,
      style: TextStyle(
          fontWeight: FontWeight.normal, color: color, fontSize: fontSize),
    ));
  }

  static BoxDecoration btnBoxDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.btnStartColor,
          AppColors.btnCenterColor,
          AppColors.btnEndColor
        ],
      ),
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: AppColors.transparent,
        width: 1,
      ),
    );
  }

  static BoxDecoration btnAlertBoxDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: AppColors.transparent,
        width: 1,
      ),
    );
  }

  static InputDecoration inputEditTextWithOutBorderRadiusAndIcon(
      String? hintText1) {
    return InputDecoration(
      hintText: hintText1 ?? "",
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(color: AppColors.grayLight, width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(color: AppColors.grayDark, width: 1)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(color: AppColors.grayLight, width: 1)),
    );
  }

  static InputDecoration inputEditTextWithOutBorderRadiusAndIconOutSideFrom(
      String? hintText1) {
    return InputDecoration(
        hintText: hintText1 ?? "",
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: const BorderSide(color: AppColors.black, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: const BorderSide(color: AppColors.red, width: 1)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: const BorderSide(color: AppColors.grayLight, width: 1)),
        border: const OutlineInputBorder(borderSide: BorderSide(width: 1)));
  }

  static ButtonStyle elevatedButtonStyleForm() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.transparent,
      shadowColor: AppColors.gray,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  static InputDecoration inputEditTextBorderOnlyBottomLine(String? hintText1) {
    return InputDecoration(
      hintText: hintText1 ?? "",
      hintStyle:
          const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(color: AppColors.red, width: 1)),
    );
  }
}
