import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/services/auth_service.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/authentication_screens/login_page.dart';
import 'package:travelguide/views/authentication_screens/signup_page.dart';
import 'package:travelguide/views/home_screens/home_page.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/images/welcome_page.jpeg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.65), BlendMode.dstATop),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter, // Üstte ortalar
            child: Padding(
              padding:
                  EdgeInsets.only(top: screenHeight * 0.2), // Üstten boşluk ver
              child: SvgPicture.asset(
                'assets/logo/ternai-company_title_final.svg',
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.25,
                  horizontal: screenWidth * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    text: "Giriş Yap",
                    color: AppColors.primaryColor,
                    width: screenWidth * 0.8,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: "Kayıt ol",
                    color: AppColors.primaryColor,
                    width: screenWidth * 0.8,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomButton(
                    text: "Üye Olmadan Devam Et",
                    color: Colors.white,
                    textColor: AppColors.primaryColor,
                    borderColor: AppColors.primaryColor,
                    width: screenWidth * 0.8,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        bool isSuccess =
                            await authViewModel.signInWithAnonymously();
                        if (isSuccess) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          _showErrorDialog(
                              'Anonim Giriş Hatası', 'Lütfen Tekrar Deneyin.');
                        }
                      } catch (e) {
                        _showErrorDialog('Error', e.toString());
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
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

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
