import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';
import '../utils/firebase_error_messages.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _userFromFirebase(User? user) {
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future<UserModel?> getCurrentUser() async {
    return _userFromFirebase(_auth.currentUser);
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print("HATA: ${e.code}");
      throw FirebaseErrorMessages.getErrorMessage(e.code);
    }
  }

  Future<void> signUpWithEmail(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      UserModel newUser = UserModel(
        userId: userCredential.user!.uid,
        name: name,
        email: email.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestoreService.createUser(newUser);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMessages.getErrorMessage(e.code);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMessages.getErrorMessage(e.code);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
