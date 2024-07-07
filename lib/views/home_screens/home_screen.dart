import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ana Sayfa'),
      ),
      body: const Center(
        child: Text('Ana Sayfa İçeriği'),
      ),
    );
  }
}
