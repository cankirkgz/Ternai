import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/home_screens/profile_screen.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/widgets/custom_text_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _birthDateController;
  late TextEditingController _emailController;
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    _usernameController = TextEditingController(
      text: authViewModel.user?.name ?? '',
    );
    _birthDateController = TextEditingController(
      text: authViewModel.user?.birthDate.toString() ?? '',
    );
    _emailController = TextEditingController(
      text: authViewModel.user?.email ?? '',
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userName = authViewModel.user?.name ?? 'Kullanıcı';
    final userMail = authViewModel.user?.email ?? 'Kullanıcı';
    final userId = authViewModel.user?.userId ?? 'Kullanıcı';

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        height: screenHeight * 0.97,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 230),
                  CustomTextField(
                    controller: _usernameController,
                    labelText: ' Kullanıcı Adı',
                    suffixIcon: CupertinoIcons.person,
                    validator: _usernameValidator,
                  ),
                  CustomTextField(
                    controller: _birthDateController,
                    labelText: 'Doğum Tarihi',
                    suffixIcon: CupertinoIcons.calendar_today,
                    validator: _usernameValidator,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    labelText: "E-mail",
                    suffixIcon: CupertinoIcons.envelope,
                    validator: _emailValidator,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: "Şifre",
                    obscureText: true,
                    suffixIcon: CupertinoIcons.lock,
                    validator: _passwordValidator,
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: "Profili güncelle",
                    color: AppColors.primaryColor,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_usernameController.text != userName) {
                          Map<String, dynamic> data = {
                            'name': _usernameController.text,
                          };
                          await authViewModel.updateUserField(userId, data);
                        }
                        if (_emailController.text != userMail) {
                          try {
                            await authViewModel.updateEmail(
                              userId,
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('E-posta adresi güncellendi.'),
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
                      }
                    },
                    width: screenWidth * 0.7,
                  ),
                  SizedBox(height: 20),
                  if (!authViewModel.user!.emailVerified)
                    CustomButton(
                      text: "Doğrulama E-postası Gönder",
                      color: Colors.orange,
                      onPressed: () async {
                        try {
                          await authViewModel.sendEmailVerification();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Doğrulama e-postası gönderildi.'),
                            ),
                          );

                          // Bir süre bekledikten sonra kullanıcı bilgilerini yeniden yükle
                          await Future.delayed(Duration(seconds: 5));
                          await authViewModel.reloadUser();

                          // Eğer doğrulandıysa, kullanıcıyı bilgilendir
                          if (authViewModel.user!.emailVerified) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('E-posta adresiniz doğrulandı.'),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'E-posta gönderilirken bir hata oluştu.'),
                            ),
                          );
                        }
                      },
                      width: screenWidth * 0.7,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
