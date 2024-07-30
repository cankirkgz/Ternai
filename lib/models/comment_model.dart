import 'package:travelguide/models/user_model.dart';
import 'package:travelguide/models/post_model.dart';

class CommentModel {
  String id;
  String content;
  UserModel user;
  PostModel? post;
  DateTime date;
  int likeCount;

  CommentModel({
    required this.id,
    required this.content,
    required this.user,
    required this.post,
    required this.date,
    this.likeCount = 0,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      content: json['content'],
      user: UserModel.fromMap(json['user']),
      post: PostModel.fromJson(json['post']),
      date: DateTime.parse(json['date']),
      likeCount: json['likeCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'user': user.toMap(),
      'post': post!.toJson(),
      'date': date.toIso8601String(),
      'likeCount': likeCount,
    };
  }
}
