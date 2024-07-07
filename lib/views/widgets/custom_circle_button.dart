import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCircleButton extends StatelessWidget {
  final IconData icon;

  const CustomCircleButton({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30.0,
      backgroundColor: const Color(0xFFD18C3A),
      child: Icon(
        icon,
        color: Colors.white,
        size: 30.0,
      ),
    );
  }
}
