import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _user;
  UserModel? get user => _user;

  AuthViewModel() {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    _user = await _authService.getCurrentUser();
    if (_user != null) {
      _user = await _firestoreService.getUser(_user!.userId);
    }
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _authService.signInWithEmail(email, password);
    _user = await _authService.getCurrentUser();
    if (_user != null) {
      _user = await _firestoreService.getUser(_user!.userId);
    }
    notifyListeners();
  }

  Future<void> signUpWithEmail(
      String email, String password, String name) async {
    await _authService.signUpWithEmail(email, password, name);
    _user = await _authService.getCurrentUser();
    if (_user != null) {
      _user = await _firestoreService.getUser(_user!.userId);
    }
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
