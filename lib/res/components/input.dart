import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import '../fonts/app_fonts.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String fieldType;
  final Color? inputColor;
  final Icon? prefixIcon;
  final bool? requiredField; // <-- Add kiya

  const CustomInputField({
    super.key,
    required this.controller,
    required this.fieldType,
    required this.hintText,
    this.inputColor,
    this.prefixIcon,
    this.requiredField,
    required String Function(dynamic value) validator,
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
    bool isPassword = widget.fieldType == "password";

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
      default:
        keyboardType = TextInputType.text;
    }

    return TextFormField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      controller: widget.controller,
      validator: (value) {
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
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(10),
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
