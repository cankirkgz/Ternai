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
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await _firestoreService.updateUserField(
        userCredential.user!.uid,
        {'updated_at': DateTime.now().toIso8601String()},
      );
    } on FirebaseAuthException catch (e) {
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

Future<void> updateEmail(String userId, String newEmail) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updateEmail(newEmail.trim());
        await currentUser.reload();
        currentUser = _auth.currentUser;

        // Firestore'daki kullanıcı belgesini güncelle
        await _firestoreService.updateUserField(
          userId,
          {'email': newEmail.trim(), 'updated_at': DateTime.now().toIso8601String()},
        );
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMessages.getErrorMessage(e.code);
    }
  }
//   Future<void> updateEmail(String userId, String email) async {

// try {
//       await _auth.currentUser!.updateEmail(email);
//       await _auth.currentUser?.reload();
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseErrorMessages.getErrorMessage(e.code);
//     }

//   }
}
