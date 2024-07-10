import 'package:flutter/material.dart';

class CustomDropDownButton extends StatelessWidget {
  final String text;
  final Color color;
  final double? width;
  final VoidCallback? onPressed;

  CustomDropDownButton(
      {required this.text,
      required this.color,
      this.width,
      this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(""),
    );
  }
}
