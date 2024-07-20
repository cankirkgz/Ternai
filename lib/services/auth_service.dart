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
        emailVerified: userCredential.user!.emailVerified,
        profileImageUrl: userCredential.user!.photoURL, // Yeni eklenen alan
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

  Future<void> updateEmailIfVerified(
      String userId, String newEmail, String password) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      await currentUser.reload(); // Kullanıcı bilgilerini yeniden yükle
      if (!currentUser.emailVerified) {
        await sendEmailVerification();
        throw Exception(
            'E-posta doğrulama gerekli. Lütfen e-postanızı doğrulayın.');
      } else {
        AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: password,
        );

        await currentUser.reauthenticateWithCredential(credential);

        await currentUser.updateEmail(newEmail.trim());
        await _firestoreService
            .updateUserField(userId, {'email': newEmail.trim()});
      }
    }
  }

  Future<void> sendEmailVerification() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null && !currentUser.emailVerified) {
      await currentUser.sendEmailVerification();
    }
  }

  Future<void> reloadCurrentUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      await currentUser.reload();
    }
  }

  bool isEmailVerified() {
    User? currentUser = _auth.currentUser;
    return currentUser?.emailVerified ?? false;
  }
}
