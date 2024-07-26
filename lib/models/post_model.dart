import 'package:travelguide/models/user_model.dart';
import 'package:travelguide/models/country_model.dart';

class PostModel {
  String id; // Post ID
  UserModel user; // Paylaşan kullanıcı
  String photoUrl; // Paylaşılan fotoğraf URL'si
  Country country; // Tatile gidilen ülke
  int daysStayed; // Kaç gün kalındı
  String memories; // Tatil anıları
  DateTime postDate; // Yayınlanma tarihi
  int likes; // Beğeni sayısı
  List<String> comments; // Yorumlar
  List<String>? tags; // Tatil ile ilgili etiketler (Zorunlu değil)
  bool isPublic; // Postun herkese açık olup olmadığı (Varsayılan true)
  DateTime lastUpdated; // Postun en son güncellenme tarihi

  PostModel({
    required this.id,
    required this.user,
    required this.photoUrl,
    required this.country,
    required this.daysStayed,
    required this.memories,
    required this.postDate,
    required this.likes,
    required this.comments,
    this.tags,
    this.isPublic = true,
    required this.lastUpdated,
  });

  // JSON dönüşümleri için methodlar
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      user: UserModel.fromMap(json['user']),
      photoUrl: json['photoUrl'],
      country: Country.fromMap(json['country'], json['country']['id']),
      daysStayed: json['daysStayed'],
      memories: json['memories'],
      postDate: DateTime.parse(json['postDate']),
      likes: json['likes'],
      comments: List<String>.from(json['comments']),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      isPublic: json['isPublic'] ?? true,
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toMap(),
      'photoUrl': photoUrl,
      'country': country.toMap(),
      'daysStayed': daysStayed,
      'memories': memories,
      'postDate': postDate.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'tags': tags,
      'isPublic': isPublic,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
