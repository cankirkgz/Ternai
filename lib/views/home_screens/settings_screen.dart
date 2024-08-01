import 'dart:async'; // Timer sınıfı için gerekli import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
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
  late TextEditingController _passwordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    _initializeControllers(authViewModel);
  }

  void _initializeControllers(AuthViewModel authViewModel) {
    _usernameController = TextEditingController(
      text: authViewModel.user?.name ?? '',
    );
    _birthDateController = TextEditingController(
      text: authViewModel.user?.birthDate != null
          ? "${authViewModel.user!.birthDate!.day}/${authViewModel.user!.birthDate!.month}/${authViewModel.user!.birthDate!.year}"
          : '',
    );
    _emailController = TextEditingController(
      text: authViewModel.user?.email ?? '',
    );
    _passwordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _usernameController.addListener(() {
      setState(() {
        final currentUserName = authViewModel.user?.name ?? '';
        _isChanged = _usernameController.text != currentUserName;
      });
    });
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen isminizi ve soyisminizi giriniz';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi giriniz';
    }
    return null;
  }

  Future<void> _changePassword(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Şifre Değiştir'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _passwordController,
                labelText: 'Mevcut Şifre',
                obscureText: true,
                suffixIcon: CupertinoIcons.lock,
                validator: _passwordValidator,
              ),
              CustomTextField(
                controller: _newPasswordController,
                labelText: 'Yeni Şifre',
                obscureText: true,
                suffixIcon: CupertinoIcons.lock,
                validator: _passwordValidator,
              ),
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'Yeni Şifreyi Tekrar Girin',
                obscureText: true,
                suffixIcon: CupertinoIcons.lock,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen şifrenizi tekrar giriniz';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Şifreler eşleşmiyor';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                if (_newPasswordController.text ==
                    _confirmPasswordController.text) {
                  try {
                    await Provider.of<AuthViewModel>(context, listen: false)
                        .reauthenticateAndChangePassword(
                      _passwordController.text,
                      _newPasswordController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Şifreniz başarıyla değiştirildi'),
                      ),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                }
              },
              child: const Text('Değiştir'),
            ),
          ],
        );
      },
    );
  }

  void _startVerificationPolling() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await authViewModel.reloadUser();
      if (authViewModel.user?.emailVerified ?? false) {
        await authViewModel.updateUserField(authViewModel.user!.userId, {
          'email_verified': true,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-posta adresiniz doğrulandı.'),
          ),
        );
        timer.cancel();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userId = authViewModel.user?.userId ?? 'Kullanıcı';
    final emailVerified = authViewModel.user?.emailVerified ?? false;

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ayarlar',
          style: TextStyle(color: AppColors.textColor),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.backgroundColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 230),
                CustomTextField(
                  controller: _usernameController,
                  labelText: 'Kullanıcı Adı',
                  suffixIcon: CupertinoIcons.person,
                  validator: _usernameValidator,
                ),
                CustomTextField(
                  controller: _birthDateController,
                  labelText: 'Doğum Tarihi',
                  suffixIcon: CupertinoIcons.calendar_today,
                  validator: null,
                  enabled: false,
                ),
                CustomTextField(
                  controller: _emailController,
                  labelText: "E-mail",
                  suffixIcon: CupertinoIcons.envelope,
                  validator: null,
                  enabled: false,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Profili Güncelle",
                  color: AppColors.primaryColor,
                  onPressed: _isChanged
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            final currentUserName =
                                authViewModel.user?.name ?? '';
                            if (_usernameController.text != currentUserName) {
                              Map<String, dynamic> data = {
                                'name': _usernameController.text,
                              };
                              await authViewModel.updateUserField(userId, data);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kullanıcı adı güncellendi.'),
                                ),
                              );
                              setState(() {
                                _isChanged = false;
                              });
                            }
                          }
                        }
                      : null,
                  width: screenWidth * 0.8,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Şifreyi Değiştir",
                  color: AppColors.primaryColor,
                  onPressed: () {
                    _changePassword(context);
                  },
                  width: screenWidth * 0.8,
                ),
                const SizedBox(height: 20),
                if (!emailVerified)
                  CustomButton(
                    text: "Doğrulama E-postası Gönder",
                    color: Colors.orange,
                    onPressed: () async {
                      try {
                        await authViewModel.sendEmailVerification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Doğrulama e-postası gönderildi.'),
                          ),
                        );
                        _startVerificationPolling();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('E-posta gönderilirken bir hata oluştu.'),
                          ),
                        );
                      }
                    },
                    width: screenWidth * 0.8,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
