import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 128),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.png'),
            opacity: 0.35,
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline_rounded,
                    size: 96, color: Color(0xF12fa4cf)),
                const Text(
                  'Şifremi Unuttum',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xF12fa4cf)),
                ),
                const SizedBox(height: 50),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'E-mail',
                  hintText: 'E-mail giriniz',
                  suffixIcon: CupertinoIcons.envelope,
                  validator: _emailValidator,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Gönder",
                  color: AppColors.primaryColor,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await authViewModel.sendPasswordResetEmail(
                          _emailController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Password reset email sent to ${_emailController.text.trim()}'),
                          ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
