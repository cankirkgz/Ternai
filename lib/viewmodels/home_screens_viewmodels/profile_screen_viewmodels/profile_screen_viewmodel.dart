import 'package:flutter/material.dart';
import 'package:travelguide/models/user_model.dart';
import 'package:travelguide/services/auth_service.dart';
import 'package:travelguide/services/firestore_service.dart';


class ProfileScreenViewModel extends ChangeNotifier {
     final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

UserModel? _user;
  UserModel? get user => _user;

  ProfileScreenViewModel() {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    _user = await _authService.getCurrentUser();
    if (_user != null) {
      _user = await _firestoreService.getUser(_user!.userId);
    }
    notifyListeners();
  }

    Future<void>  dbUser() async {
   await _firestoreService.getUser(_user!.userId);
    }

  


  

}
