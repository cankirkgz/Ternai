import 'package:travelguide/models/country_model.dart';
import 'package:travelguide/models/comment_model.dart';

class PostModel {
  String id; // Post ID
  String userId; // Paylaşan kullanıcının ID'si
  List<String> photoUrls; // Paylaşılan fotoğrafların URL'leri
  Country country; // Tatile gidilen ülke
  String memories; // Tatil anıları
  DateTime postDate; // Yayınlanma tarihi
  int likes; // Beğeni sayısı
  List<String> likedUserIds; // Beğenen kullanıcıların ID'leri
  List<CommentModel> comments; // Yorumlar
  List<String>? tags; // Tatil ile ilgili etiketler (Zorunlu değil)
  bool isPublic; // Postun herkese açık olup olmadığı (Varsayılan true)
  DateTime? lastUpdated; // Postun en son güncellenme tarihi

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
      postDate: DateTime.parse(json['postDate'] ?? ''),
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
