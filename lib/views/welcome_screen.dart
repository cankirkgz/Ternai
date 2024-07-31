import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/authentication_screens/birth_date_select_page.dart';
import 'package:travelguide/views/authentication_screens/login_page.dart';
import 'package:travelguide/views/authentication_screens/signup_page.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/home_screens/home_page.dart'; // HomePage'i import et

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Image.asset(
                                'assets/logo/google-logo.png',
                                height: screenHeight * 0.07,
                              ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            bool isSuccess =
                                await authViewModel.signInWithAnonymously();
                            if (isSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const HomePage(), // HomePage'e yönlendirme
                                ),
                              );
                            } else {
                              _showErrorDialog('Anonim Giriş Hatası',
                                  'Lütfen Tekrar Deneyin.');
                            }
                          } catch (e) {
                            _showErrorDialog('Error', e.toString());
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Image.asset(
                                'assets/logo/user-logo.png',
                                height: screenHeight * 0.07,
                              ),
                      ),
                    ],
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
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
