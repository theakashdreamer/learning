import 'package:flutter/material.dart';

class LoadingDialogWidget extends StatelessWidget {
  final String? message;

  const LoadingDialogWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 10),
            child: const CircularProgressIndicator(),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "$message",
          )
        ],
      ),
    );
  }
}

class CustomDialog {
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialogWidget(message);
      },
    );
  }

  static void dismissLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(); // Dismiss the dialog
  }
}
