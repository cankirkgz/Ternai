import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/services/auth_service.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/viewmodels/day_plan_model.dart';
import 'package:travelguide/viewmodels/plan_viewmodel.dart';
import 'package:travelguide/views/authentication_screens/login_page.dart';
import 'package:travelguide/views/home_screens/settings_screen.dart';
import 'package:travelguide/models/post_model.dart';
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
  late Future<List<dynamic>> _futurePlans;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUserPosts();
    _futurePlans = fetchAllPlans();
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
          .where('userId', isEqualTo: userId)
          .get();

      if (postsSnapshot.docs.isNotEmpty) {
        setState(() {
          _posts = postsSnapshot.docs
              .map((doc) =>
                  PostModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
          _postCount = _posts.length;
        });
      } else {
        setState(() {
          _posts = [];
          _postCount = 0;
        });
      }
    }
  }

  Future<List<dynamic>> fetchAllPlans() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    final userId = user.uid;

    final budgetPlans = await fetchBudgetPlans(userId);
    final dayPlans = await fetchDayPlans(userId);
    final planPlans = await fetchPlanPlans(userId);

    return [...budgetPlans, ...dayPlans, ...planPlans];
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
          )),
          Positioned.fill(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                Column(children: [
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
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder<List<dynamic>>(
                        future: _futurePlans,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return _buildStatisticCard('Vacations', 0);
                          } else if (snapshot.hasError) {
                            return _buildStatisticCard('Vacations', 0);
                          } else if (snapshot.hasData) {
                            final plans = snapshot.data!;
                            return _buildStatisticCard(
                                'Vacations', _futurePlans.toString().length);
                          } else {
                            return _buildStatisticCard('Vacations', 0);
                          }
                        },
                      ),
                      const SizedBox(width: 20),
                      _buildStatisticCard('Posts', _postCount),
                    ],
                  ),
                  SizedBox(
                    height: 34,
                  ),
                  Container(
                    color: Colors.lightBlueAccent,
                    height: 3,
                  ),
                ]),
                Container(
                  height: 34,
                  color: Colors.lightBlueAccent.withAlpha(90),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 21,
                      ),
                      Icon(Icons.grid_on_outlined,
                          color: Colors.white, size: 21),
                      SizedBox(
                        width: 3,
                      ),
                      const Text(
                        'POST',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 45,
                      ),
                      Icon(Icons.health_and_safety_rounded,
                          color: Colors.white30, size: 21),
                      SizedBox(
                        width: 3,
                      ),
                      const Text(
                        'LIKED',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                _posts.isNotEmpty
                    ? Container(
                        color: Colors.lightBlueAccent.withAlpha(90),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          itemCount: _posts.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.blueGrey,
                              child: GestureDetector(
                                onTap: () {
                                  _showFullScreenImages(context, index);

                                  // PostCard(post: posts[index];
                                },
                                child: Image.network(
                                  _posts[index].photoUrls.first,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'Henüz bir gönderi paylaşmadınız',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                Container(
                  color: Colors.lightBlueAccent.withAlpha(70),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                          style: ButtonStyle(
                            // foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.lightBlueAccent),
                          ),
                          child: const Text(
                            'BAŞA DÖN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          onPressed: () {}),
                      SizedBox(
                        height: 200,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImages(BuildContext context, int index) {
    int _currentImageIndex = index;

    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PageView.builder(
                itemCount: _posts[index].photoUrls.length,
                controller: PageController(initialPage: _currentImageIndex),
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, pageIndex) {
                  return InteractiveViewer(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 8,
                        left: 8,
                        right: 8,
                        
                      ),
                      child: Center(
                        child: PostCard(post: _posts[index]),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '/ ${_posts[index].postDate.toString().trimLeft(  )}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
