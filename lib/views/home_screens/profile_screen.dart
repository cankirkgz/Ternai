import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/services/auth_service.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/authentication_screens/login_page.dart';
import 'package:travelguide/views/home_screens/settings_screen.dart';

final AuthService _authService = AuthService();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authViewModel.user?.userId;

    if (userId != null) {
      // Veritabanından profil resmi yüklemesi
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists && userDoc['profile_image_url'] != null) {
        setState(() {
          _profileImageUrl = userDoc['profile_image_url'];
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _showConfirmationDialog();
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authViewModel.user?.userId;
    if (_image == null || userId == null) return;

    try {
      String fileName = 'profile_pics/$userId.png';
      await _storage.ref(fileName).putFile(_image!);

      String downloadURL = await _storage.ref(fileName).getDownloadURL();
      print('Download URL: $downloadURL');

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profile_image_url': downloadURL,
      });

      setState(() {
        _profileImageUrl = downloadURL;
        _image = null; // Resim yüklendikten sonra local değişkeni temizle
      });

      authViewModel.updateUserField(userId, {'profile_image_url': downloadURL});
    } catch (e) {
      print('Upload error: $e');
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profil fotoğrafını güncelle'),
          content: const Text('Kaynak seçin'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
              child: const Text('Kamera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
              child: const Text('Galeri'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fotoğrafı onayla'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _image != null ? Image.file(_image!) : Container(),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _uploadImage(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userName = authViewModel.user?.name ?? 'Kullanıcı Adı';
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(userName),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context);
              } else if (value == 'settings') {
                _settings(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8),
                      Text('Ayarlar'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
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
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/profile_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 200,
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Her satırda 3 kutucuk
              ),
              itemCount: 25,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    color: Colors.primaries[index %
                        Colors.primaries.length], // Her kutucuğa renk atayın
                    child: Center(
                      child: Text('Memento $index'),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            top: 0,
            left: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - keyboardHeight,
              child: Column(
                children: [
                  const SizedBox(height: 120),
                  InkWell(
                    onTap: _showImageSourceDialog,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: _profileImageUrl != null
                          ? NetworkImage(_profileImageUrl!)
                          : const AssetImage(
                                  "assets/images/default_profile.png")
                              as ImageProvider,
                      child: _image == null && _profileImageUrl == null
                          ? const Icon(Icons.camera_alt, size: 80)
                          : null,
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

  void _settings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
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
