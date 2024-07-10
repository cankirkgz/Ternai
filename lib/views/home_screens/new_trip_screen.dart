import 'package:flutter/material.dart';

class NewTripScreen extends StatelessWidget {
  const NewTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Tatil Planı'),
      ),
      body: const Center(
        child: Text('Yeni Tatil Planı İçeriği'),
      ),
    );
  }
}
