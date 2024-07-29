import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelguide/models/budget_plan_model.dart';
import 'package:travelguide/models/country_model.dart';
import 'package:travelguide/models/day_plan_model.dart';
import 'package:travelguide/models/plan_plan_model.dart';
import 'package:travelguide/models/post_model.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final int? age;
  final DateTime? birthDate;
  final Country? country;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool emailVerified;
  final String? profileImageUrl;
  final List<PostModel> posts;
  final List<BudgetPlanModel> budgetPlans;
  final List<DayPlanModel> dayPlans;
  final List<PlanPlanModel> planPlans;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.emailVerified,
    this.age,
    this.birthDate,
    this.country,
    this.profileImageUrl,
    this.posts = const [],
    this.budgetPlans = const [],
    this.dayPlans = const [],
    this.planPlans = const [],
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      userId: user.uid,
      name: user.displayName ?? '',
      email: user.email!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      emailVerified: user.emailVerified,
      profileImageUrl: user.photoURL,
    );
  }

  get user_id => null;

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
      'email_verified': emailVerified,
      'profile_image_url': profileImageUrl,
      'posts': posts.map((post) => post.toJson()).toList(),
      'budget_plans': budgetPlans.map((plan) => plan.toJson()).toList(),
      'day_plans': dayPlans.map((plan) => plan.toJson()).toList(),
      'plan_plans': planPlans.map((plan) => plan.toJson()).toList(),
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
      birthDate:
          map['birth_date'] != null ? DateTime.parse(map['birth_date']) : null,
      country:
          map['country'] != null ? Country.fromMap(map['country'], '') : null,
      emailVerified: map['email_verified'] ?? false,
      profileImageUrl: map['profile_image_url'],
      posts: map['posts'] != null
          ? List<PostModel>.from(
              (map['posts'] as List).map((post) => PostModel.fromJson(post)))
          : [],
      budgetPlans: map['budget_plans'] != null
          ? List<BudgetPlanModel>.from((map['budget_plans'] as List)
              .map((plan) => BudgetPlanModel.fromJson(plan)))
          : [],
      dayPlans: map['day_plans'] != null
          ? List<DayPlanModel>.from((map['day_plans'] as List)
              .map((plan) => DayPlanModel.fromJson(plan)))
          : [],
      planPlans: map['plan_plans'] != null
          ? List<PlanPlanModel>.from((map['plan_plans'] as List)
              .map((plan) => PlanPlanModel.fromJson(plan)))
          : [],
    );
  }
}
