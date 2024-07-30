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
  List<File> _images = [];
  Country? selectedCountry;
  final uuid = Uuid();
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _memoriesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isUploading = false; // Yükleme durumu

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: NetworkImage(
                        authViewModel.user!.profileImageUrl ??
                            'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIzLTAxL3JtNjA5LXNvbGlkaWNvbi13LTAwMi1wLnBuZw.png',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        minLines: 2,
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                        controller: _memoriesController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Anınızı paylaşın...',
                          hintStyle:
                              TextStyle(fontSize: 17, color: Colors.grey[500]),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
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
                SizedBox(height: 20),
                CustomDropDownButton(
                  listName: "Ülke",
                  items: {
                    for (var country in countries) country.id: country.name
                  },
                  validator: (value) =>
                      value == null ? "Lütfen bir ülke seçiniz" : null,
                  onChanged: (value) {
                    setState(() {
                      selectedCountry =
                          countries.firstWhere((c) => c.id == value);
                    });
                  },
                ),
                SizedBox(height: 20),
                _images.isNotEmpty
                    ? Column(
                        children: [
                          Container(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _images.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.file(
                                          _images[index],
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 5,
                                      top: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _images.removeAt(index);
                                          });
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GestureDetector(
                              onTap: _shareImage,
                              child: Text(
                                'Daha fazla fotoğraf eklemek için buraya tıklayın.',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: _shareImage,
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.grey[600],
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                isUploading
                    ? CircularProgressIndicator()
                    : CustomButton(
                        text: "Paylaş",
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (_images.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Lütfen bir fotoğraf ekleyin!')),
                              );
                              return;
                            }
                            if (selectedCountry == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Lütfen bir ülke seçin!')),
                              );
                              return;
                            }
                            _uploadImages(context);
                          }
                        },
                        color: AppColors.primaryColor,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages(ImageSource source) async {
    final pickedFiles = source == ImageSource.camera
        ? [await _picker.pickImage(source: ImageSource.camera)]
        : await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file!.path)));
      });
    }
  }

  Future<void> _uploadImages(BuildContext context) async {
    if (_images.isNotEmpty) {
      setState(() {
        isUploading = true;
      });

      try {
        final authViewModel =
            Provider.of<AuthViewModel>(context, listen: false);
        final userId = authViewModel.user?.userId;
        if (userId != null) {
          List<String> downloadUrls = [];
          for (File image in _images) {
            final fileName = DateTime.now().millisecondsSinceEpoch.toString();
            final storageRef =
                _storage.ref().child('user_posts/$userId/$fileName');
            final uploadTask = storageRef.putFile(image);
            await uploadTask.whenComplete(() async {
              final downloadUrl = await storageRef.getDownloadURL();
              downloadUrls.add(downloadUrl);
            });
          }
          PostModel newPost = PostModel(
            id: uuid.v4(),
            userId: authViewModel.user!.userId,
            photoUrls: downloadUrls,
            country: selectedCountry!,
            memories: _memoriesController.text,
            postDate: DateTime.now(),
            lastUpdated: DateTime.now(),
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
            const SnackBar(content: Text('Fotoğraflar yüklendi!')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        print('Error uploading images: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fotoğraf yükleme hatası!')),
        );
      } finally {
        setState(() {
          isUploading = false;
        });
      }
    }
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
