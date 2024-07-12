// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';

import 'package:travelguide/views/authentication_screens/login_page.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // File _image;
  // final picker = ImagePicker();

  //   Future<void> _pickImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     }
  //   });
  // }

  // Future<void> _uploadImage() async {
  //   if (_image == null) return;

  //   try {
  //     final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${_image.path.split('/').last}');
  //     await storageRef.putFile(_image);
  //     String downloadURL = await storageRef.getDownloadURL();
  //     // Bu URL'yi kullanıcı veritabanınızda saklayabilirsiniz
  //   } catch (e) {
  //     print('Error occurred while uploading the image: $e');
  //   }
  // }

  final _usernameController = TextEditingController();

  final _userBirtController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _confirmPasswordController = TextEditingController();

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 128),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/profile_background.png'),
            opacity: 0.7,
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            CircleAvatar(
              radius: 60,
            ),
            SizedBox(
              height: 50,
            ),
            //       _image == null ? Text('No image selected.') : Image.file(_image),
            //       Row(
            //         children: [
            //             ElevatedButton(
            //   onPressed: _pickImage,
            //   child: Text('Pick Image'),
            // ),
            // ElevatedButton(
            //   onPressed: _uploadImage,
            //   child: Text('Upload Image'),
            // ),
            //         ],
            //       ),
            CustomTextField(
              controller: _usernameController,
              labelText: "Kullanıcı Adı",
              hintText: "getUser",
              suffixIcon: CupertinoIcons.person,
              validator: _usernameValidator,
            ),
            CustomTextField(
              controller: _userBirtController,
              labelText: "Doğum Tarihi",
              hintText: "getUser/BithDay",
              suffixIcon: CupertinoIcons.calendar_today,
              validator: _usernameValidator,
            ),
            CustomTextField(
              controller: _usernameController,
              labelText: "İrtibat",
              hintText: "E164 getUser Number ",
              suffixIcon: CupertinoIcons.person,
              validator: _usernameValidator,
            ),
            CustomTextField(
              controller: _emailController,
              labelText: "E-mail",
              hintText: "getUser@E-mail",
              suffixIcon: CupertinoIcons.envelope,
              validator: _emailValidator,
            ),
            CustomTextField(
              controller: _passwordController,
              labelText: "Şifre",
              hintText: "Şifre",
              obscureText: true,
              suffixIcon: CupertinoIcons.lock,
              validator: _passwordValidator,
            ),
            // CustomTextField(
            //   controller: _confirmPasswordController,
            //   labelText: "Şifreyi Onayla",
            //   hintText: "Şifrenizi Onaylayınız",
            //   obscureText: true,
            //   suffixIcon: CupertinoIcons.lock,
            //   validator: _confirmPasswordValidator,
            // ),
            CustomButton(
              text: "Profili Güncelle",
              color: AppColors.primaryColor,
              onPressed: () async {},
              //  onPressed: (){},
            )
          ]),
        ),
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

// class ProfilePage extends StatelessWidget {
//   final String profileImageUrl;

//   ProfilePage({this.profileImageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Profile Page')),
//       body: Center(
//         child: profileImageUrl == null
//             ? Text('No profile image.')
//             : Image.network(profileImageUrl),
//       ),
//     );
//   }
// }
