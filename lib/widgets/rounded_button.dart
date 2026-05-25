import 'package:flutter/material.dart';

import 'ease_in_widget.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final IconData? iconData;
  final VoidCallback onTap;  // Use VoidCallback instead of Function()

  const RoundedButton({
    Key? key,
    this.text,
    this.iconData,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EaseInWidget(
      onTap: onTap,
      child: Container(
        padding: text != null
            ? EdgeInsets.symmetric(vertical: 22.0, horizontal: 16.0)
            : EdgeInsets.symmetric(vertical: 19.0, horizontal: 22.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 12.0,
              spreadRadius: 0.1,
            ),
          ],
        ),
        child: text != null
            ? Text(
          "$text",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(  // Replaced `title` with `headline6`
            color: Colors.white,
          ),
        )
            : Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }
}
