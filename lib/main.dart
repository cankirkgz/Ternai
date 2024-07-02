import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travelguide/pages/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF2fa4cf), // Gök mavisi
            elevation: 10, // Gölge yüksekliği
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21, color: Colors.white), // Beyaz yazı (font
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 96, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFd38c40),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21), // Gök mavisi
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
