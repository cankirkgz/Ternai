import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelguide/models/country_model.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final int? age;
  final DateTime? birthDate;
  final Country? country;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.age,
    this.birthDate,
    this.country,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      userId: user.uid,
      name: user.displayName ?? '',
      email: user.email!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
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
      'birth_date': birthDate?.toIso8601String(),
      'country': country?.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError("Veri null olmamalı");
    }

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
      age: map['age'],
      birthDate: map['birth_date'] != null
          ? DateTime.parse(map['birth_date'])
          : null, // Yeni eklenen alan
      country:
          map['country'] != null ? Country.fromMap(map['country'], '') : null,
    );
  }
}
