import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../models/comment_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı işlemleri
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.userId).set(user.toMap());
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        final user = UserModel.fromMap(data);
        return user;
      }

      print("Kullanıcı bulunamadı veya veriler eksik.");
      return null;
    } catch (e, stacktrace) {
      print("Hata oluştu: $e\nStacktrace: $stacktrace");
      throw Exception("Kullanıcı verisi alınırken hata oluştu: $e");
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.userId)
          .update(user.toMap());
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUserField(
      String userId, Map<String, dynamic> fields) async {
    try {
      await _firestore.collection('users').doc(userId).update(fields);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw e;
    }
  }

  // Post işlemleri
  Future<void> createPost(PostModel post) async {
    try {
      await _firestore.collection('posts').doc(post.id).set(post.toJson());
    } catch (e) {
      throw e;
    }
  }

  Future<PostModel?> getPost(String postId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('posts').doc(postId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return PostModel.fromJson(data);
      }
      return null;
    } catch (e) {
      throw e;
    }
  }

  Future<List<PostModel>> getAllPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('posts').get();
      List<PostModel> posts = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PostModel.fromJson(data);
      }).toList();
      return posts;
    } catch (e) {
      throw e;
    }
  }

  Future<void> updatePost(PostModel post) async {
    try {
      await _firestore.collection('posts').doc(post.id).update(post.toJson());
    } catch (e) {
      throw e;
    }
  }

  Future<void> updatePostField(
      String postId, Map<String, dynamic> fields) async {
    try {
      await _firestore.collection('posts').doc(postId).update(fields);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      throw e;
    }
  }

  // Beğeni işlemleri
  Future<void> toggleLike(String postId, String userId) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      DocumentSnapshot postSnapshot = await postRef.get();

      if (postSnapshot.exists) {
        final post =
            PostModel.fromJson(postSnapshot.data() as Map<String, dynamic>);
        List<String> likedUserIds = List.from(post.likedUserIds);

        if (likedUserIds.contains(userId)) {
          likedUserIds.remove(userId);
          await postRef.update({
            'likedUserIds': likedUserIds,
            'likes': FieldValue.increment(-1),
          });
        } else {
          likedUserIds.add(userId);
          await postRef.update({
            'likedUserIds': likedUserIds,
            'likes': FieldValue.increment(1),
          });
        }
      }
    } catch (e) {
      print("Error toggling like: $e");
      throw e;
    }
  }

// Yorum işlemleri
  Future<void> addComment(String postId, CommentModel comment) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      DocumentReference commentRef =
          postRef.collection('comments').doc(comment.id);

      // Yorumun JSON verisini yazdır
      print("Adding comment: ${comment.toJson()}");

      await commentRef.set(comment.toJson());
    } catch (e) {
      print("Error adding comment: $e");
      throw e;
    }
  }

  Future<List<CommentModel>> getComments(String postId) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      QuerySnapshot commentSnapshot =
          await postRef.collection('comments').get();

      List<CommentModel> comments = commentSnapshot.docs.map((doc) {
        return CommentModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return comments;
    } catch (e) {
      print("Error fetching comments: $e");
      throw e;
    }
  }
}
