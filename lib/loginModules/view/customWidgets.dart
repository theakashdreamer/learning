import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../loginModules/res/appColors.dart';
import '../../loginModules/res/appStyles.dart';

class CustomWidgets {
  static Column sizeBoxWithCardImageAndTextNEw(
      String icon, String strValue, String values) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        showCulculerImage(icon, true),
        Container(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "$strValue",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppStyles.styleHintSmallSizeWithBlackColorBold,
              ),
              Text(
                values,
                textAlign: TextAlign.center,
                style: AppStyles.unsuccessfullyStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Column sizeBoxWithCardImageAndTextCard(
      String icon, String strValue, bool forIconBackgroundColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        showCulculerImage(icon, forIconBackgroundColor),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Text(
            strValue,
            textAlign: TextAlign.center,
            style: AppStyles.styleHintNormalSizeWithWhiteColor,
          ),
        ),
      ],
    );
  }

  static ListTile sizeBoxWithCardImageAndTextCardRow(
      String icon, String strValue, bool forIconBackgroundColor) {
    return ListTile(
      title: Text(
        strValue,
        style: AppStyles.styleHintNormalSizeWithTextColor,
      ),
      leading: showCulculerImageWithSize(icon, forIconBackgroundColor),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }

  static Widget showCulculerIcon(
      IconData icon, bool forIconBackgroundColor, Color colors) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color:
              forIconBackgroundColor ? AppColors.white : AppColors.lighterBlue,
          shape: BoxShape.circle),
      child: ClipOval(
        child: Icon(icon, size: 24, color: colors),
      ),
    );
  }

  static Widget showCulculerIconWithSize(
      IconData icon, bool forIconBackgroundColor, Color colors, double size) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color:
              forIconBackgroundColor ? AppColors.white : AppColors.lighterBlue,
          shape: BoxShape.circle),
      child: ClipOval(
        child: Icon(icon, size: size, color: colors),
      ),
    );
  }

  static Widget showCulculerImage(String icon, bool forIconBackgroundColor) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color:
              forIconBackgroundColor ? AppColors.white : AppColors.lighterBlue,
          shape: BoxShape.circle),
      child: ClipOval(
        child: Image.asset(
          icon,
          fit: BoxFit.fill,
          height: 40,
          width: 40,
        ),
      ),
    );
  }

  static Widget showCulculerImageWithSize(
      String icon, bool forIconBackgroundColor) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color:
              forIconBackgroundColor ? AppColors.white : AppColors.lighterBlue,
          shape: BoxShape.circle),
      child: ClipOval(
        child: Image.asset(
          icon,
          fit: BoxFit.fill,
          height: 50,
          width: 50,
        ),
      ),
    );
  }

  static SizedBox sizeBoxWithCardImageAndText(
      String imagePath, String strValue, BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 3,
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fill,
                ),
              ),
              Text(
                strValue,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              )
            ],
          ),
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
