import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travelguide/services/auth_service.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/models/post_model.dart';
import 'package:travelguide/views/authentication_screens/login_page.dart';
import 'package:travelguide/views/authentication_screens/signup_page.dart';
import 'package:travelguide/views/home_screens/post_screen.dart';
import 'package:travelguide/views/home_screens/settings_screen.dart';
import 'package:travelguide/views/welcome_screen.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/widgets/post_card.dart';

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
  int _postCount = 0;
  int _vacationCount = 0;
  bool _isLoadingProfile = true; // Profil verilerinin yüklenme durumu
  bool _isLoadingPosts = true; // Postların yüklenme durumu

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProfileData(); // Profil sayfasına her dönüldüğünde verileri yeniden yükle
  }

  Future<void> _loadProfileData() async {
    _loadProfileImage();
    _loadUserPosts();
    _loadVacationCount();
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
          _isLoadingProfile = false; // Profil verileri yüklendi
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
          .where('userId', isEqualTo: userId)
          .get();

      setState(() {
        _posts = postsSnapshot.docs
            .map(
                (doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        _postCount = _posts.length;
        _isLoadingPosts = false;
      });
    }
  }

  Future<void> _loadVacationCount() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    setState(() {
      _vacationCount = authViewModel.user?.vacationPlanCount ?? 0;
    });
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
        _image = null;
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
    final user = authViewModel.user;

    if (user == null || user.isAnonymous) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[200],
                  child:
                      const Icon(Icons.person, size: 80, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Text(
                  'Anonim Kullanıcı',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Anonim kullanıcı olarak yalnızca sınırlı özelliklere erişebilirsiniz. Daha fazla özellik için kayıt olun veya giriş yapın.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: "Kayıt Ol",
                  color: AppColors.primaryColor,
                  onPressed: () {
                    _logout(context);
                  },
                )
              ],
            ),
          ),
        ),
      );
    }

    final userName = user.name ?? 'Kullanıcı Adı';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
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
            ),
          ),
          Positioned.fill(
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _isLoadingProfile
                            ? null
                            : (_image != null
                                ? FileImage(_image!)
                                : _profileImageUrl != null
                                    ? NetworkImage(_profileImageUrl!)
                                    : const AssetImage(
                                            "assets/images/default_profile.png")
                                        as ImageProvider),
                        child: _isLoadingProfile
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.grey[200],
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoadingProfile
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 150,
                              height: 20,
                              color: Colors.grey[300],
                            ),
                          )
                        : Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const SizedBox(height: 10),
                    _isLoadingProfile
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 100,
                              height: 20,
                              color: Colors.grey[300],
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStatisticCard(
                                  'Tatil Planları', _vacationCount),
                              const SizedBox(width: 20),
                              _buildStatisticCard('Gönderiler', _postCount),
                            ],
                          ),
                    const SizedBox(height: 34),
                    Container(
                      height: 3,
                      color: Colors.transparent, // Şeffaf hale getirildi
                    ),
                  ],
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: _isLoadingPosts ? 9 : _postCount,
                  itemBuilder: (context, index) {
                    if (_isLoadingPosts) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.white,
                          height: 100,
                          width: 100,
                        ),
                      );
                    } else {
                      if (index < _posts.length) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostScreen(post: _posts[index]),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey, // Border rengi
                                width: 0.2, // Border kalınlığı
                              ),
                            ),
                            child: Image.network(
                              _posts[index].photoUrls.first,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                      return Container(); // Boş geri döndür
                    }
                  },
                ),
              ],
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
            color: Colors.white,
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 0.1),
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
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
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }
}
