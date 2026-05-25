
import 'package:flutter/material.dart';
import 'package:schoolmanagementsystem/components/reusable_text_widgets.dart';

import '../loginModules/res/appStrings.dart';

class GlobalButton extends StatelessWidget {
  final String? buttonText;
  final VoidCallback onPress;

  const GlobalButton(
      {super.key, required this.onPress, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    bool isResetPasswordButton = AppStrings.getString(buttonText!)!.toString()=='पासवर्ड रीसेट करें';
    return ElevatedButton(
      onPressed: onPress,
      style:  ButtonStyle(
              backgroundColor: MaterialStateProperty.all(isResetPasswordButton ? Colors.red : Colors.blueGrey,),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.0),
                ),
              ),
        overlayColor: MaterialStateProperty.all(isResetPasswordButton ? Colors.green : Colors.green,),

            ),
      child: ReusableText.setButtonText(AppStrings.getString(buttonText!)!),
    );
  }
}
