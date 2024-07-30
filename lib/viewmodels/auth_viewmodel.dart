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
      await _firestoreService.createUser(_user!);
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
      _user =
          await _firestoreService.getUser(userId); // Kullanıcıyı yeniden yükle
      notifyListeners();
    } catch (e) {
      print("Kullanıcı bilgilerini güncellerken hata oluştu: $e");
      throw e;
    }
  }

  Future<void> updateEmail(
      String userId, String newEmail, String password) async {
    try {
      await _authService.updateEmailIfVerified(userId, newEmail, password);
      notifyListeners();
    } catch (e) {
      print("E-posta güncelleme hatası: $e");
      throw e;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
      notifyListeners();
    } catch (e) {
      print("E-posta doğrulama hatası: $e");
      throw e;
    }
  }

  Future<void> reloadUser() async {
    try {
      await _authService.reloadCurrentUser();
      _user = await _authService.getCurrentUser();
      if (_user != null) {
        _user = await _firestoreService.getUser(_user!.userId);
      }
      notifyListeners();
    } catch (e) {
      print("Kullanıcı bilgilerini yeniden yüklerken hata oluştu: $e");
      throw e;
    }
  }

  Future<void> changePassword(String newPassword) async {
    try {
      await _authService.changePassword(newPassword);
      notifyListeners();
    } catch (e) {
      print("Şifre değiştirme hatası: $e");
      throw e;
    }
  }

  Future<void> reauthenticateAndChangePassword(
      String currentPassword, String newPassword) async {
    try {
      await _authService.reauthenticate(currentPassword);
      await _authService.changePassword(newPassword);
      notifyListeners();
    } catch (e) {
      print("Şifre değiştirme hatası: $e");
      throw e;
    }
  }

  Future<UserModel> getUserWithId(String userId) async {
    final user = await _firestoreService.getUser(userId);
    return user!;
  }
}
