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
import 'package:travelguide/viewmodels/post_viewmodel.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _memoriesController = TextEditingController();
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _images = widget.images ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
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
                          contentPadding: const EdgeInsets.symmetric(
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
                const SizedBox(height: 20),
                CustomDropDownButton(
                  listName: "Ülke",
                  items: {
                    for (var country in postViewModel.countries)
                      country.id: country.name
                  },
                  validator: (value) =>
                      value == null ? "Lütfen bir ülke seçiniz" : null,
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = postViewModel.countries
                          .firstWhere((c) => c.id == value);
                    });
                  },
                ),
                const SizedBox(height: 20),
                _images.isNotEmpty
                    ? Column(
                        children: [
                          SizedBox(
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
                                        child: const Icon(
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
                              child: const Text(
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
                    ? const CircularProgressIndicator()
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
                            _uploadImages(postViewModel, authViewModel);
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

  Future<void> _pickImages(ImageSource source) async {
    final pickedFiles = source == ImageSource.camera
        ? [await ImagePicker().pickImage(source: ImageSource.camera)]
        : await ImagePicker().pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file!.path)));
      });
    }
  }

  Future<void> _uploadImages(
      PostViewModel postViewModel, AuthViewModel authViewModel) async {
    setState(() {
      isUploading = true;
    });

    try {
      await postViewModel.addPost(
        _images,
        selectedCountry!,
        _memoriesController.text,
        authViewModel.user!.userId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gönderi başarıyla paylaşıldı!')),
      );
      Navigator.of(context).pop();
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
