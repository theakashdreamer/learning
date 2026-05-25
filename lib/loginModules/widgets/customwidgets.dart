import 'package:flutter/material.dart';
import '../theme/color.dart';

class CustomWidgets {
  static SizedBox sizeBoxWithCardImageAndText(
      String imagePath, String strValue) {
    return SizedBox(
      height: 156,
      width: 156,
      child: Card(
        elevation: 3,
        shadowColor: AppColors.grayLight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 65,
              height: 65,
              child: Image.asset(
                imagePath,
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: FittedBox(
                child: Text(
                  strValue,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static SizedBox sizeBoxWithCardImageAndText1(
      String imagePath, String strValue) {
    return SizedBox(
      height: 156,
      width: 156,
      child: Card(
        elevation: 3,
        shadowColor: AppColors.grayLight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 65,
                height: 65,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fill,
                )),
            const SizedBox(
              height: 5,
            ),
            Text(
              strValue,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  static SizedBox sizeBoxWithCardImageAndTextForReport(
      String imagePath, String strValue) {
    return SizedBox(
      height: 156,
      width: 156,
      child: Card(
        elevation: 3,
        shadowColor: AppColors.grayLight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 65,
                height: 65,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fill,
                )),
            Center(
              child: FittedBox(
                child: Text(
                  strValue,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static ElevatedButton btnElevatedButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.transparent,
        shadowColor: AppColors.gray,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            "Next",
            style: TextStyle(
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
