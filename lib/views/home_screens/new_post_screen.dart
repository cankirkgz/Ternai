import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/services/api_service.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/widgets/custom_dropdown_button.dart';
import 'package:travelguide/models/country_model.dart';
class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  File? _image;
  Country? selectedCountry;
  
  
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final  _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _numberController = TextEditingController();
  
  
  List<Country> countries = [];

@override
  void initState() {
  super.initState();
  _loadCountries();
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('New Post Screen')),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0),
              child: SizedBox(
                height: 650,
                child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  ),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left:30 ,right:100 ),
                  child: Text(
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,),
                      textAlign: TextAlign.left,
                        'Anılarınızı paylaşmak ister misiniz?'),
                ),
                  Padding(
                    padding: const EdgeInsets.only(left:40,right:90 ),
                    child: ElevatedButton(style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blue),),
                      onPressed: (){_shareImage();}, 
                      child:const Text(
                        style: TextStyle(color: Colors.white,),
                        'Fotoğraf ekleyin ')),
                  ),
                Padding(
                  padding: EdgeInsets.only(left:10,right:90),
                  child: SizedBox(height:100
                  ,width: 250,
                    child: TextField(
                      minLines: 3,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      controller: _numberController,
                      decoration:  InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:BorderRadius.circular(20),),
                        hintText:'Yorum yazın',
                        hintStyle: TextStyle(fontSize: 13)),
                      ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 90),
                  child: CustomDropDownButton(
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
                ),
                  Padding(
                  padding: EdgeInsets.only(top:2,bottom: 50,left: 40,right: 100),
                  child: ElevatedButton(style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blue),),
                    onPressed: (){Navigator.of(context).pop();
                                  _uploadImage(context);}, 
                    child:const Text(
                      style: TextStyle(color: Colors.white,),
                      'Paylaş ')),
                ),
                      ],
                      ),
                          ),
              ),
            ),
      ),
    );
  }
  void _shareImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(style:TextStyle(fontSize: 15),
            'Kaynak seçin'),
          actions: <Widget>[
                TextButton(
                  child: const Text('Galeri'),
                  onPressed: () {Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(width: 70),
                TextButton(
                  onPressed: () {Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                  child: const Text('Camera'),
                ),
          ],
        );
      },
    );
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
  if (_image != null) {
      try {
        // Get the user ID
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        final userId = authViewModel.user?.userId;

        if (userId != null) {
          // Upload image to Firebase Storage
          final fileName = DateTime.now().millisecondsSinceEpoch.toString();
          final storageRef = _storage.ref().child('user_posts/$userId/$fileName');
          final uploadTask = storageRef.putFile(_image!);

          await uploadTask.whenComplete(() async {
            final downloadUrl = await storageRef.getDownloadURL();

            // Save image URL to Firestore
            await FirebaseFirestore.instance.collection('posts').add({
              'userId': userId,
              'imageUrl': downloadUrl,
              'timestamp': FieldValue.serverTimestamp(),
            });

            // Show success message
            _scaffoldKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Fotoğraf yüklendi!')),);
            
            // Navigate to HomeScreen or update the UI
            Navigator.of(context).pop();
          });
        }
      } catch (e) {
        print('Error uploading image: $e');
        _scaffoldKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Fotoğraf yükleme hatası!')),
        );
      }
    }
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
              onPressed: () {setState(() {
                ;
              });
                Navigator.of(context).pop();
                
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
}
