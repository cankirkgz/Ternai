import 'package:flutter/material.dart';

class NavigatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigator Page'),
      ),
      body: Center(
        child: Text('This page does not have a BottomNavigationBar'),
      ),
    );
  }
}
