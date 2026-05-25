import 'package:flutter/material.dart';

import '../res/appStrings.dart';
import '../res/appStyles.dart';


class RadioButtonAlertDialog extends StatelessWidget {
  final Function(String) onOptionSelected; // Callback function

  RadioButtonAlertDialog({Key? key, required this.onOptionSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _selectedOption = '';

    return AlertDialog(
      title: AppStyles.textStyleForNormalWithBold(
          AppStrings.getString('select_location')!),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: InkWell(
                onTap: () {
                  onOptionSelected('1');
                },
                child: AppStyles.textStyleForNormalWithBold(
                    AppStrings.getString('locationWithVerified')!)),
          ),
          ListTile(
            title: InkWell(
              onTap: () {
                onOptionSelected('2');
              },
              child: AppStyles.textStyleForNormalWithBold(
                  AppStrings.getString('withoutLocationWithVerified')!),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAlertDialog {
  static void showLoadingDialog(
      BuildContext context, Function(String) onOptionSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RadioButtonAlertDialog(
          onOptionSelected: onOptionSelected,
        );
      },
    );
  }

  static void dismissLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
