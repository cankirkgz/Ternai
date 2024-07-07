import 'package:flutter/material.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class OnboardingScreen2 extends StatelessWidget {
  final PageController controller;

  const OnboardingScreen2({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/onboarding_page_2.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.65),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.15,
                  horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Anlık fiyat güncellemeleri ile tatilinizi planlayın ve bütçenizi yönetin!",
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Atla",
                    color: AppColors.primaryColor,
                    onPressed: () {
                      controller.animateToPage(
                        5, // Son indikatörün olduğu sayfa
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
