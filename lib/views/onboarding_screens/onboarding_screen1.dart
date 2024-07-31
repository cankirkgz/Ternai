import 'package:flutter/material.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class OnboardingScreen1 extends StatelessWidget {
  final PageController controller;

  const OnboardingScreen1({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/onboarding_page_1.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.65),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 35.0),
            width: screenWidth * 0.6,
            alignment: const Alignment(0, -0.6),
            child: const Text(
              "Yapay zeka destekli bütçe planlamasıyla Zekice Seyahat Edin!",
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            alignment: const Alignment(0, 0.6),
            child: CustomButton(
              text: "Yolculuğa Başla",
              color: AppColors.primaryColor,
              onPressed: () {
                controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
