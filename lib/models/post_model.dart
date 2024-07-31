import 'package:travelguide/models/country_model.dart';
import 'package:travelguide/models/comment_model.dart';

class PostModel {
  String id;
  String userId;
  List<String> photoUrls;
  Country country;
  String memories;
  DateTime postDate;
  int likes;
  List<String> likedUserIds;
  List<CommentModel> comments;
  List<String>? tags;
  bool isPublic;
  DateTime? lastUpdated;

  PostModel({
    required this.id,
    required this.userId,
    required this.photoUrls,
    required this.country,
    required this.memories,
    required this.postDate,
    this.likes = 0,
    this.likedUserIds = const [],
    this.comments = const [],
    this.tags,
    this.isPublic = true,
    this.lastUpdated,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      country: Country.fromMap(json['country'], json['country']['countryId']),
      memories: json['memories'] ?? '',
      postDate: DateTime.parse(json['postDate'] ?? DateTime.now().toString()),
      likes: json['likes'] ?? 0,
      likedUserIds: List<String>.from(json['likedUserIds'] ?? []),
      comments: List<CommentModel>.from(
          (json['comments'] ?? []).map((item) => CommentModel.fromJson(item))),
      tags: List<String>.from(json['tags'] ?? []),
      isPublic: json['isPublic'] ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'photoUrls': photoUrls,
      'country': country.toMap(),
      'memories': memories,
      'postDate': postDate.toIso8601String(),
      'likes': likes,
      'likedUserIds': likedUserIds,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'tags': tags,
      'isPublic': isPublic,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }
}
