import 'package:flutter/material.dart';
import 'dart:io';

class DropDownWidget extends StatefulWidget {
  void Function(String?)? onPress;
  List<dynamic> dynamicList = [];
  late FocusNode? focusNode;

  DropDownWidget(
      {super.key,
        required this.onPress,
        required this.dynamicList,
        this.focusNode});

  @override
  State<DropDownWidget> createState() => DropDownWidgetState();
}

class DropDownWidgetState extends State<DropDownWidget> {
  String? selectItem;
  static bool forEnable = true;

  @override
  Widget build(BuildContext context) {
    if (selectItem != null && !widget.dynamicList.contains(selectItem)) {
      selectItem = null;
    }
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: Platform.isIOS
          ? const EdgeInsets.symmetric(horizontal: 8.0)
          : const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.blue, width: 1.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectItem,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          onChanged: forEnable
              ? (String? value) {
            setState(() {
              selectItem = value;
              print(widget.dynamicList.length);
            });
            widget.onPress?.call(value);
          }
              : null,

          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text("--select--"),
            ),
            ...(widget.dynamicList.map<DropdownMenuItem<String>>((dynamic value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }
}