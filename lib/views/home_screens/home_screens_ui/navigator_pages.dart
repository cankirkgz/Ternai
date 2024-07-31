import 'package:flutter/material.dart';

class NavigatorPage extends StatelessWidget {
  const NavigatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigator Page'),
      ),
      body: const Center(
        child: Text('This page does not have a BottomNavigationBar'),
      ),
    );
  }
}
