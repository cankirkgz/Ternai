import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final double? width;
  final VoidCallback? onPressed;

  CustomButton(
      {required this.text,
      required this.color,
      this.width,
      this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Butonun arka plan rengi
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}