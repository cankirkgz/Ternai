import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool enabled;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final void Function()? onTap; // Burayı ekleyin

  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.style,
    this.decoration,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onTap, // Burayı ekleyin
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Burayı ekleyin
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          decoration: decoration ?? InputDecoration(
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
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      suffixIcon,
                      color: Colors.black26,
                      size: 20.0,
                    ),
                  )
                : null,
          ),
          validator: validator,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
