import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelguide/models/country_model.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final int? age;
  final Country? country;
  final String? profileUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.age,
    this.country,
    this.profileUrl,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      userId: user.uid,
      name: user.displayName ?? '',
      email: user.email!,
      createdAt: DateTime
          .now(), // Placeholder, should come from Firestore or other source
      updatedAt: DateTime
          .now(), // Placeholder, should come from Firestore or other source
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'age': age,
      'country': country?.toMap(),
      'profile_url': profileUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : DateTime.now(),
      age: map['age'] ?? 0,
      country: map['country'] != null
          ? Country.fromMap(map['country'], map['country_id'])
          : null,
      profileUrl: map['profile_url'] ?? '',
    );
  }
}
