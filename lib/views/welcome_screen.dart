import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/services/google_login_service.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/authentication_screens/login_page.dart';
import 'package:travelguide/views/authentication_screens/signup_page.dart';
import 'package:travelguide/views/home_screens/home_page.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final googleController = Get.put(GoogleLoginService());
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = true;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.2),
              child: const Text(
                "Gezi Rehberi",
                style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                  GestureDetector(
                    onTap: () async {
                      await googleController.login();
                      setState(() {
                        print(
                            googleController.googleAccont.value?.displayName ??
                                'Kullanıcı');
                        print(googleController.googleAccont.value?.email ??
                            'email');
                        print(googleController.googleAccont.value?.id ?? 'id');
                        print(googleController.googleAccont.value?.serverAuthCode ??
                            '?');
                      });
                      // if (_formKey.currentState!.validate()) {
                      //   try {
                      //     await authViewModel.signInWithEmail(
                      //       _emailController.text,
                      //       _passwordController.text,
                      //     );
                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const HomePage()),
                      //     );
                      //   } catch (e) {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text(e.toString()),
                      //       ),
                      //     );
                      //   }
                      // }
                    },
                    child: Image.asset(
                      'assets/images/google_logo.webp',
                      height: screenHeight * 0.09,
                    ),
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
