import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userName = authViewModel.user?.email ?? 'Kullanıcı';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ana Sayfa'),
      ),
      body: Center(
        child: Text(
          'Merhaba $userName',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
