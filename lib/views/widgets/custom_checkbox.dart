import 'package:flutter/material.dart';
import 'package:travelguide/theme/theme.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;

  const CustomCheckbox({
    required this.value,
    required this.onChanged,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.secondaryColor,
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
