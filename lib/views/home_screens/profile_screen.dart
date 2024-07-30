import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/services/auth_service.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/authentication_screens/login_page.dart';
import 'package:travelguide/views/home_screens/settings_screen.dart';
import 'package:travelguide/models/post_model.dart';

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
  List<PostModel> _posts = [];
  int _vacationCount = 0;
  int _postCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUserPosts();
    _loadUserVacationCount();
  }

  Future<void> _loadProfileImage() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authViewModel.user?.userId;

    if (userId != null) {
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

  Future<void> _loadUserPosts() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authViewModel.user?.userId;

    if (userId != null) {
      QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('user.userId', isEqualTo: userId)
          .get();

      if (postsSnapshot.docs.isNotEmpty) {
        setState(() {
          _posts = postsSnapshot.docs
              .map((doc) =>
                  PostModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
          _postCount = _posts.length;
        });
      }
    }
  }

  Future<void> _loadUserVacationCount() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authViewModel.user?.userId;

    if (userId != null) {
      QuerySnapshot vacationsSnapshot = await FirebaseFirestore.instance
          .collection('vacations')
          .where('user.userId', isEqualTo: userId)
          .get();

      if (vacationsSnapshot.docs.isNotEmpty) {
        setState(() {
          _vacationCount = vacationsSnapshot.docs.length;
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
      String fileName = 'profile_pics/${userId}.png';
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Profil Fotoğrafını Güncelle'),
          content: const Text('Bir kaynak seçin'),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Fotoğrafı Onayla'),
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
              child: const Text('İptal'),
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
        automaticallyImplyLeading: false,
        title: Text(
          userName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                    children: <Widget>[
                      Icon(Icons.settings),
                      SizedBox(width: 8),
                      Text('Ayarlar'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: <Widget>[
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
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryColor,
                Colors.white,
              ],
            ),
          )),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: keyboardHeight),
              child: Column(
                children: [
                  const SizedBox(height: 120),
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : _profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!)
                              : const AssetImage(
                                      "assets/images/default_profile.png")
                                  as ImageProvider,
                      child: _image == null && _profileImageUrl == null
                          ? const Icon(Icons.camera_alt,
                              size: 80, color: Colors.black)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatisticCard('Vacations', _vacationCount),
                      const SizedBox(width: 20),
                      _buildStatisticCard('Posts', _postCount),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Gönderiler',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _posts.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: _posts.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _posts[index].photoUrls.first,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              'Henüz bir gönderi yok',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
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

  Widget _buildStatisticCard(String title, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
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
