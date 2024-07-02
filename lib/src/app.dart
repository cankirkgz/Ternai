import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelguide/src/views/signUp_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Firebase Auth Test")),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
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
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                ),
                child: Text('SignUpScreen'),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => SignUpScreen()),
            //     ),
            //   child: Text('SignUpScreen'),
            // )
          ]),
        ),
      ),
    );
  }
}
