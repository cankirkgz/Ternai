import 'package:flutter/material.dart';

class PriceSearchScreen extends StatelessWidget {
  const PriceSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Fiyat Araması'),
      ),
      body: const Center(
        child: Text('Fiyat Araması İçeriği'),
      ),
    );
  }
}
