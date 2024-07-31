import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/services/auth_service.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/authentication_screens/birth_date_select_page.dart';
import 'package:travelguide/views/authentication_screens/login_page.dart';
import 'package:travelguide/views/home_screens/home_page.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/widgets/custom_or_divider.dart';
import 'package:travelguide/views/widgets/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;
  bool _hasMinLength = false;

  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen isiminizi ve soyisminizi giriniz';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen e-mailinizi giriniz';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir e-mail giriniz';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi giriniz';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi onaylayınız';
    }
    if (value != _passwordController.text) {
      return 'Şifreler eşleşmiyor';
    }
    return null;
  }

  void _validatePassword(String value) {
    setState(() {
      _hasUpperCase = value.contains(RegExp(r'[A-Z]'));
      _hasLowerCase = value.contains(RegExp(r'[a-z]'));
      _hasDigit = value.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      _hasMinLength = value.length >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/login_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 60),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Kayıt Ol",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          "Hoş Geldiniz",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              height: screenHeight * 0.7,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _usernameController,
                          labelText: "İsim Soyisim",
                          hintText: "İsim Soyisim",
                          suffixIcon: CupertinoIcons.person,
                          validator: _usernameValidator,
                        ),
                        CustomTextField(
                          controller: _emailController,
                          labelText: "E-mail",
                          hintText: "E-mail",
                          suffixIcon: CupertinoIcons.envelope,
                          validator: _emailValidator,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        CustomTextField(
                          controller: _passwordController,
                          labelText: "Şifre",
                          hintText: "Şifre",
                          obscureText: true,
                          suffixIcon: CupertinoIcons.lock,
                          validator: _passwordValidator,
                          onChanged: _validatePassword,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Şifre Şartları:',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            _buildPasswordCondition(
                                'En az 8 karakter', _hasMinLength),
                            _buildPasswordCondition(
                                'Bir büyük harf', _hasUpperCase),
                            _buildPasswordCondition(
                                'Bir küçük harf', _hasLowerCase),
                            _buildPasswordCondition('Bir rakam', _hasDigit),
                            _buildPasswordCondition(
                                'Bir özel karakter', _hasSpecialChar),
                          ],
                        ),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          labelText: "Şifreyi Onayla",
                          hintText: "Şifrenizi Onaylayınız",
                          obscureText: true,
                          suffixIcon: CupertinoIcons.lock,
                          validator: _confirmPasswordValidator,
                        ),
                        CustomButton(
                          text: "Kayıt Ol",
                          color: AppColors.primaryColor,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await authViewModel.signUpWithEmail(
                                  _emailController.text,
                                  _passwordController.text,
                                  _usernameController.text,
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BirthDateSelectPage()),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                  ),
                                );
                              }
                            }
                          },
                          width: screenWidth * 0.7,
                        ),
                        const SizedBox(height: 10),
                        const CustomOrDivider(),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          icon: Image.asset(
                            'assets/logo/google-logo.png',
                            height: screenHeight * 0.05,
                          ),
                          label: const Text(
                            "Google ile Giriş Yap",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          onPressed: () async {
                            try {
                              User? user =
                                  await AuthService().signInWithGoogle();
                              if (user != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Zaten bir hesabın var mı? ',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                    );
                                  },
                                  child: const Text(
                                    'Giriş Yap',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCondition(String condition, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isValid ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            condition,
            style: TextStyle(
              color: isValid ? Colors.green : Colors.red, // Değişiklik yapıldı
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
