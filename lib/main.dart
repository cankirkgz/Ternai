import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Firebase Auth Test")),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                UserCredential userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: "testuser@example.com",
                        password: "testpassword");
                print('User created: ${userCredential.user?.email}');
              } catch (e) {
                print('Error creating user: $e');
              }
            },
            child: Text('Create Test User'),
          ),
        ),
      ),
    );
  }
}
