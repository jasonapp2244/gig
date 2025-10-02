import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../colors/app_color.dart';
import '../fonts/app_fonts.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? fieldType;
  final Color? inputColor;
  final Icon? prefixIcon;
  final bool? requiredField;
  final String? Function(String?)? validator;
  Function()? onTap;
  bool? isEdit;

  CustomInputField({
    super.key,
    required this.controller,
this.fieldType,
    required this.hintText,
    this.inputColor,
    this.prefixIcon,
    this.requiredField,
    this.validator,
    this.isEdit,
    this.onTap
  });

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    bool isPassword =
        widget.fieldType == "password" ||
        widget.fieldType == "confirm password";

    switch (widget.fieldType) {
      case "email":
        keyboardType = TextInputType.emailAddress;
        break;
      case "number":
        keyboardType = TextInputType.number;
        break;
      case "password":
        keyboardType = TextInputType.text;
        break;
      case "confirm password":
        keyboardType = TextInputType.text;
        break;
      default:
        keyboardType = TextInputType.text;
    }

    return TextFormField(
      
      onTap :widget.onTap,
      enabled: widget.isEdit ?? true,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      controller: widget.controller,
      validator:
          widget.validator ??
          (value) {
            if (widget.requiredField == true) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
            }
            return null;
          },
      obscureText: isPassword ? _obscureText : false,
      obscuringCharacter: '*',
      keyboardType: keyboardType,

      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        iconColor: AppColor.textColor,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.white60,
          fontFamily: AppFonts.appFont,
        ),
        filled: true,
        fillColor: widget.inputColor ?? AppColor.grayColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 17,
        ),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColor.primeColor,
                ),
                onPressed: _togglePasswordVisibility,
              )
            : null,
      ),
    );
  }
}
