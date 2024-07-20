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
    try {
      await _authService.sendPasswordResetEmail(email);
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> updateUserField(String userId, Map<String, dynamic> data) async {
    try {
      await _firestoreService.updateUserField(userId, data);
      // Eğer _user'da güncelleme yapmak istiyorsanız, burada yapabilirsiniz
      notifyListeners();
    } catch (e) {
      print("Kullanıcı bilgilerini güncellerken hata oluştu: $e");
      throw e; // Hata yönetimini burada gerçekleştirin
    }
  }

  Future<void> updateEmail(String userId, Map<String, dynamic> data, String email) async {

    try {
      await _authService.updateEmail(userId, email);
      await _firestoreService.updateUserField(userId, data);

      // Eğer _user'da güncelleme yapmak istiyorsanız, burada yapabilirsiniz
      notifyListeners();
    } catch (e) {
      print("Kullanıcı bilgilerini güncellerken hata oluştu: $e");
      throw e; // Hata yönetimini burada gerçekleştirin
    }

  }
}
