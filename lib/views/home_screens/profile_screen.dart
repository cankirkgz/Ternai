import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/viewmodels/home_screens_viewmodels/profile_screen_viewmodels/profile_screen_viewmodel.dart';
import 'package:travelguide/views/authentication_screens/login_page.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
        final profileScreenViewModel = Provider.of<ProfileScreenViewModel>(context);
      var db = profileScreenViewModel.dbUser.toString();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: const [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('Çıkış Yap'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Column(children: [
          CustomTextField(
            controller: _usernameController,
            labelText:     db,
            hintText:   db,
            suffixIcon: CupertinoIcons.person,
            validator: _usernameValidator,
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
            text: "Profili Güncelle",
            color: AppColors.primaryColor,
            onPressed: () async {
             print(db);
            },
            //  onPressed: (){},
          )
        ]),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}

