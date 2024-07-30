import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../services/firestore_service.dart';

class PostViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  PostViewModel() {
    fetchPosts();
  }

  Future<List<PostModel>> fetchPosts() async {
    try {
      List<PostModel> posts = await _firestoreService.getAllPosts();
      _posts = posts;
      notifyListeners();
      return posts;
    } catch (e) {
      print("Error fetching posts: $e");
      throw e;
    }
  }

  Future<void> addPost(PostModel post) async {
    try {
      await _firestoreService.createPost(post);
      _posts.insert(0, post); // Yeni postu listenin başına ekliyoruz.
      notifyListeners();
    } catch (e) {
      print("Error adding post: $e");
      throw e;
    }
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    try {
      await _firestoreService.updatePostField(postId, data);
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        _posts[index] =
            PostModel.fromJson({..._posts[index].toJson(), ...data});
        notifyListeners();
      }
    } catch (e) {
      print("Error updating post: $e");
      throw e;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestoreService.deletePost(postId);
      _posts.removeWhere((post) => post.id == postId);
      notifyListeners();
    } catch (e) {
      print("Error deleting post: $e");
      throw e;
    }
  }

  Future<void> toggleLike(PostModel post, String userId) async {
    try {
      await _firestoreService.toggleLike(post.id, userId);
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        if (_posts[index].likedUserIds.contains(userId)) {
          _posts[index].likedUserIds.remove(userId);
          _posts[index].likes -= 1;
        } else {
          _posts[index].likedUserIds.add(userId);
          _posts[index].likes += 1;
        }
        notifyListeners();
      }
    } catch (e) {
      print("Error toggling like: $e");
    }
  }

  Future<void> addComment(PostModel post, CommentModel comment) async {
    try {
      await _firestoreService.addComment(post.id, comment);
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _posts[index].comments.add(comment);
        notifyListeners();
      }
    } catch (e) {
      print("Error adding comment: $e");
      throw e;
    }
  }

  Future<List<CommentModel>> fetchComments(String postId) async {
    try {
      return await _firestoreService.getComments(postId);
    } catch (e) {
      print("Error fetching comments: $e");
      throw e;
    }
  }
}
