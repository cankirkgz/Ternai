import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.userId).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      print("userId: $userId");
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.userId)
          .update(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserField(
      String userId, Map<String, dynamic> fields) async {
    try {
      await _firestore.collection('users').doc(userId).update(fields);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
