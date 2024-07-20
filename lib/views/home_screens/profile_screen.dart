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

//   final FirebaseAuth _auth = FirebaseAuth.instance;
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

  get math => null;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authViewModel.user!.userId;

    // Firestore'dan profil fotoğrafı URL'sini al
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists && userDoc['profileImageUrl'] != null) {
      setState(() {
        _profileImageUrl = userDoc['profileImageUrl'];
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authViewModel.user!.userId;
    if (_image == null) return;

    try {
      String fileName = 'profile_pics/${userId}.png';
      await _storage.ref(fileName).putFile(_image!);

      String downloadURL = await _storage.ref(fileName).getDownloadURL();
      print('Download URL: $downloadURL');

      // Profil fotoğrafı URL'sini Firestore'a kaydet
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profileImageUrl': downloadURL,
      });

      // Yeni URL'yi state'e yükle
      setState(() {
        _profileImageUrl = downloadURL;
      });
    } catch (e) {
      print('Upload error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userName = authViewModel.user?.displayName ?? 'Mücahit Gökçe';
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(userName),
        centerTitle: true,
        titleTextStyle: TextStyle(
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
                    children: const [
                      Icon(Icons.settings),
                      SizedBox(width: 8),
                      Text('Ayarlar'),
                    ],
                  ),
                ),
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
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text('sfdsd'),
            ),
          ),
          // ListView.builder(
          //     itemCount: 100,
          //     itemBuilder: (context, index) {
          //       return Container(
          //         color: Colors.red,
          //         child: Text('Random Color'),
          //       );
          //     }),
          Positioned.fill(
            top: 0,
            left: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - keyboardHeight,
              child: Container(
                  height: 20,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/1.0X/profile_front.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 120),
                      InkWell(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: _profileImageUrl != null
                              ? NetworkImage(
                                  _profileImageUrl!,
                                  scale: 1.0,
                                )
                              : null,
                          child: _image != null
                              ? Image.file(_image!)
                              : _profileImageUrl == null
                                  ? Text('Bir resim seçin')
                                  : null,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _uploadImage(context);
                        },
                        child: Text('Resmi Yükle'),
                      ),
                      Text(authViewModel.user!.userId)
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  void _settings(BuildContext context) {
    Navigator.pushReplacement(
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



// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:travelguide/services/auth_service.dart';
// import 'package:travelguide/viewmodels/auth_viewmodel.dart';
// import 'package:travelguide/views/authentication_screens/login_page.dart';
// import 'package:travelguide/views/home_screens/settings_screen.dart';

// final AuthService _authService = AuthService();
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
  
//   File? _image;

//   final ImagePicker _picker = ImagePicker();
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _uploadImage(
//     BuildContext context,
//   ) async {
//         final authViewModel = Provider.of<AuthViewModel>(context,listen: false);
//         final userId = authViewModel.user!.userId;
//     if (_image == null) return;

//     try {
//       String fileName =
//                 // 'profile_pics/${DateTime.now().millisecondsSinceEpoch}.png';

//           'default_user_sourses/${userId}user_photo_test.png';
//       await _storage.ref(fileName).putFile(_image!);

//       String downloadURL = await _storage.ref(fileName).getDownloadURL();
//       print('Download URL: $downloadURL');
//       // Burada downloadURL'yi Firestore veya Realtime Database gibi bir yere kaydedebilirsiniz
//     } catch (e) {
//       print('Upload error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     final authViewModel = Provider.of<AuthViewModel>(context);
//     final userName = authViewModel.user?.displayName ?? 'Mücahit Gökçe';
//     // double screenWidth = MediaQuery.of(context).size.width;
//     // double screenHeight = MediaQuery.of(context).size.height;
//     double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: Text(userName),
//         centerTitle: true,
//         titleTextStyle: TextStyle(
//             color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               if (value == 'logout') {
//                 _logout(context);
//               } else if (value == 'settings') {
//                 _settings(context);
//               }
//             },
//             itemBuilder: (BuildContext context) {
//               return [
//                 const PopupMenuItem<String>(
//                   value: 'settings',
//                   child: Row(
//                     children: const [
//                       Icon(Icons.settings),
//                       SizedBox(width: 8),
//                       Text('Ayarlar'),
//                     ],
//                   ),
//                 ),
//                 const PopupMenuItem<String>(
//                   value: 'logout',
//                   child: Row(
//                     children: const [
//                       Icon(Icons.logout),
//                       SizedBox(width: 8),
//                       Text('Çıkış Yap'),
//                     ],
//                   ),
//                 ),
//               ];
//             },
//           ),
//         ],
//       ),
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/profile_background.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Text('sfdsd'),
//             ),
//           ),
//           Positioned.fill(
//             top: 0,
//             left: 0,
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height - keyboardHeight,
//               child: Container(
//                   height: 20,
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image:
//                           AssetImage("assets/images/1.0X/profile_front.png"),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       SizedBox(height: 120),
//                       InkWell(
//                         onTap: _pickImage,
//                         child: CircleAvatar(
//                             radius: 80,
//                             child: _image != null
//                                 ? Image.file(_image!)
//                                 : Text('Bir resim seçin')),
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: (){
//                           _uploadImage(context);
//                         },
//                         child: Text('Resmi Yükle'),
//                       ),
//                       Text(authViewModel.user!.userId)
//                     ],
//                   )),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void _settings(BuildContext context) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const SettingsScreen()),
//     );
//   }

//   void _logout(BuildContext context) async {
//     final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
//     await authViewModel.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//     );
//   }
// }
