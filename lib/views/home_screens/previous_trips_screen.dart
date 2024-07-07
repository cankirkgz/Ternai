import 'package:flutter/material.dart';

class PreviousTripsScreen extends StatelessWidget {
  const PreviousTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Önceki Tatil Planlarım'),
      ),
      body: const Center(
        child: Text('Önceki Tatil Planlarım İçeriği'),
      ),
    );
  }
}
