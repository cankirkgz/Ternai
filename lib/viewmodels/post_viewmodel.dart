import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/country_model.dart';
import '../services/firestore_service.dart';

class PostViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  List<Country> _countries = [];
  List<Country> get countries => _countries;

  bool _isLoading = false; // isLoading durumu eklendi
  bool get isLoading => _isLoading;

  PostViewModel() {
    fetchPosts();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      List<Country> loadedCountries = await _firestoreService.getCountries();
      _countries = loadedCountries;
      notifyListeners();
    } catch (e) {
      print("Error fetching countries: $e");
      throw e;
    }
  }

  Future<List<PostModel>> fetchPosts() async {
    _isLoading = true; // Veriler yüklenmeye başlarken isLoading true yapılır
    notifyListeners();
    try {
      List<PostModel> posts = await _firestoreService.getAllPosts();
      _posts = posts;
      return posts;
    } catch (e) {
      print("Error fetching posts: $e");
      throw e;
    } finally {
      _isLoading = false; // Veriler yüklendikten sonra isLoading false yapılır
      notifyListeners();
    }
  }

  Future<void> addPost(List<File> images, Country country, String memories,
      String userId) async {
    try {
      List<String> downloadUrls = await _uploadImages(images, userId);
      PostModel newPost = PostModel(
        id: Uuid().v4(),
        userId: userId,
        photoUrls: downloadUrls,
        country: country,
        memories: memories,
        postDate: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
      await _firestoreService.createPost(newPost);
      _posts.insert(0, newPost);
      notifyListeners();
    } catch (e) {
      print("Error adding post: $e");
      throw e;
    }
  }

  Future<List<String>> _uploadImages(List<File> images, String userId) async {
    List<String> downloadUrls = [];
    for (File image in images) {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = _storage.ref().child('user_posts/$userId/$fileName');
      final uploadTask = storageRef.putFile(image);
      await uploadTask.whenComplete(() async {
        final downloadUrl = await storageRef.getDownloadURL();
        downloadUrls.add(downloadUrl);
      });
    }
    return downloadUrls;
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
