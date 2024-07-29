import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/models/post_model.dart';
import 'package:travelguide/services/api_service.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/widgets/custom_dropdown_button.dart';
import 'package:travelguide/models/country_model.dart';
import 'package:uuid/uuid.dart';

class NewPostScreen extends StatefulWidget {
  final List<File>? images;
  const NewPostScreen({super.key, this.images});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  late List<File> _images = [];
  Country? selectedCountry;
  final uuid = Uuid();
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Country> countries = [];

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _images = widget.images ?? [];
  }

  Future<void> _loadCountries() async {
    try {
      List<Country> loadedCountries = await _apiService.getCountries();
      setState(() {
        countries = loadedCountries;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Yeni Gönderi'),
        backgroundColor: AppColors.primaryColor,
        elevation: 4.0,
      ),
      body: 
      Stack(
        children:<Widget>[
        
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          authViewModel.user?.profileImageUrl ??
                              'https://cdn.dribbble.com/userupload/5484248/file/original-c165b8bbd27323405cbb77126a3d29ec.png?resize=1200x710',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          minLines: 2,
                          maxLines: 6,
                          keyboardType: TextInputType.multiline,
                          controller: _numberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            hintText: 'Anınızı paylaşın',
                            hintStyle: TextStyle(fontSize: 17, color: Colors.grey[500]),
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen anınızı paylaşın';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 90),
                          child: CustomDropDownButton(
                            listName: "Ülke",
                            items: {
                              for (var country in countries) country.id: country.name
                            },
                            validator: (value) => value == null ? "Lütfen bir ülke seçiniz" : null,
                            onChanged: (value) {
                              setState(() {
                                selectedCountry = countries.firstWhere((c) => c.id == value);
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: IconButton(
                          onPressed: _shareImage,
                          icon: const Icon(Icons.add_a_photo, color: AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 70,),
                  _images.isNotEmpty
                      ? Container(
                          height: 200,
                          padding: const EdgeInsets.all(5),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    _images[index],
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const Text('Fotoğraf seçilmedi.'),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: CustomButton(
                      text: "Paylaş",
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (_images.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Lütfen bir fotoğraf ekleyin!')),
                            );
                            return;
                          }
                          if (selectedCountry == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Lütfen bir ülke seçin!')),
                            );
                            return;
                          }
                          Navigator.of(context).pop();
                          _uploadImage(context);
                        }
                      }, color: AppColors.primaryColor,
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
        ]
      ),
    );
  }
  Future<void> _pickImages(ImageSource source) async {
    if (source == ImageSource.camera) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _images = [File(pickedFile.path)];
        });
        _showConfirmationDialog(source);
      }
    } else if (source == ImageSource.gallery) {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          _images = pickedFiles.map((file) => File(file.path)).toList();
        });
        _showConfirmationDialog(source);
      }
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_images.isNotEmpty) {
      try {
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        final userId = authViewModel.user?.userId;
        if (userId != null) {
          final fileName = DateTime.now().millisecondsSinceEpoch.toString();
          final storageRef = _storage.ref().child('user_posts/$userId/$fileName');
          final uploadTask = storageRef.putFile(_images.first);
          await uploadTask.whenComplete(() async {
            final downloadUrl = await storageRef.getDownloadURL();
            PostModel newPost = PostModel(
              id: uuid.v4(),
              user: authViewModel.user!,
              photoUrl: downloadUrl,
              country: selectedCountry!,
              daysStayed: 5,
              memories: _numberController.text,
              postDate: DateTime.now(),
            );
            await FirebaseFirestore.instance
                .collection('posts')
                .doc(newPost.id)
                .set(newPost.toJson());
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({
              'posts': FieldValue.arrayUnion([newPost.toJson()])
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fotoğraf yüklendi!')),
            );
            Navigator.of(context).pop();
          });
        }
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fotoğraf yükleme hatası!')),
        );
      }
    }
  }

  void _showConfirmationDialog(ImageSource source) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Onayla'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    _images[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _images.clear(); // Clear the images if canceled
                });
              },
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle saving or further processing of images
              },
              child: const Text('Kaydet'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImages(source); // Use the source to prompt picking a new image
              },
              child: const Text('Değiştir'),
            ),
          ],
        );
      },
    );
  }

  void _shareImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera ile çek'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImages(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Galeriden seç'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImages(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
