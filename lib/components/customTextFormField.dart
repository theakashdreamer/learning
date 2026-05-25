import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefFixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onSuffixIconTap;
  final int? maxLength;
  final TextStyle? textStyle;
  final TextAlign textAlign;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefFixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSuffixIconTap,
    this.maxLength,
    this.textStyle,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText:  obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLength: maxLength,
      style: textStyle,
      textAlign: textAlign,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefFixIcon!=null ? Icon(prefFixIcon) : null,
        suffixIcon: prefFixIcon !=null ?
        GestureDetector(
          onTap: onSuffixIconTap,
          child: Icon(suffixIcon),
        ):null,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10)
          )
        )
      ),
    );
  }
}
