import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/views/onboarding_screens/onboarding_screen1.dart';
import 'package:travelguide/views/onboarding_screens/onboarding_screen2.dart';
import 'package:travelguide/views/onboarding_screens/onboarding_screen3.dart';
import 'package:travelguide/views/onboarding_screens/onboarding_screen4.dart';
import 'package:travelguide/views/onboarding_screens/onboarding_screen5.dart';
import 'package:travelguide/views/welcome_screen.dart';

class OnboardingView extends StatelessWidget {
  OnboardingView({super.key});
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _controller,
          children: [
            OnboardingScreen1(controller: _controller),
            OnboardingScreen2(controller: _controller),
            const OnboardingScreen3(),
            const OnboardingScreen4(),
            const OnboardingScreen5(),
            const WelcomeScreen()
          ],
        ),
        Container(
          alignment: const Alignment(0, -0.85),
          child: SmoothPageIndicator(
            controller: _controller,
            count: 6,
            effect: const WormEffect(
              activeDotColor: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    ));
  }
}
