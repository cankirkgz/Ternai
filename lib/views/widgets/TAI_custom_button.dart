import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelguide/theme/dimensions.dart';
import 'package:travelguide/theme/theme.dart';

class TaiCustomButton extends StatelessWidget {
  final Color color;
  final String text;
  final bool isActive;
  final Color textColor;
  final VoidCallback onPressed;

  const TaiCustomButton({
    super.key,
    this.color = AppColors.primary,
    required this.text,
    required this.onPressed,
    required this.isActive,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: isActive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.radiusMedium,
            ),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: textColor,
            fontSize: AppDimensions.fontTitle,
            fontWeight: AppDimensions.fontMedium,
          ),
        ),
      ),
    );
  }
}
