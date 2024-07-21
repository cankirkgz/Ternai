import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final IconData suffixIcon;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool enabled;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    required this.suffixIcon,
    this.validator,
    this.style,
    this.decoration,
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        obscureText: obscureText,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black26),
            gapPadding: 10,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black26),
            gapPadding: 10,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              suffixIcon,
              color: Colors.black26,
              size: 20.0,
            ),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
