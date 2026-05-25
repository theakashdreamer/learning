import 'package:flutter/material.dart';

class ReusableText {
  static Text setQuestionText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
      ),
    );
  }

  static Text setText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
      ),
    );
  }

  static Text setDropdownHintText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  static Text setAppBarText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20),
    );
  }

  static Text setButtonText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
