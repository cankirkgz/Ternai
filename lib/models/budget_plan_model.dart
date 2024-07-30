import 'package:travelguide/models/kid_model.dart';

class BudgetPlanModel {
  final String id;
  final String fromCountry;
  final String toCountry;
  final int numberOfDays;
  final int numberOfPeople;
  final List<KidModel> kids;
  final String? breakfastPlan;
  final String? mealPlan;
  final String? entertainmentPreferences;
  final String? shoppingPlans;
  final String? specialRequests;
  final String result;
  final String type = 'budget'; // Sabit değer

  BudgetPlanModel({
    required this.id,
    required this.fromCountry,
    required this.toCountry,
    required this.numberOfDays,
    required this.numberOfPeople,
    required this.kids,
    this.breakfastPlan,
    this.mealPlan,
    this.entertainmentPreferences,
    this.shoppingPlans,
    this.specialRequests,
    required this.result,
  });

  // JSON'dan BudgetPlanModel'e dönüşüm
  factory BudgetPlanModel.fromJson(Map<String, dynamic> json) {
    return BudgetPlanModel(
      id: json['id'],
      fromCountry: json['fromCountry'],
      toCountry: json['toCountry'],
      numberOfDays: json['numberOfDays'],
      numberOfPeople: json['numberOfPeople'],
      kids: (json['kids'] as List<dynamic>)
          .map((kid) => KidModel.fromJson(kid))
          .toList(),
      breakfastPlan: json['breakfastPlan'],
      mealPlan: json['mealPlan'],
      entertainmentPreferences: json['entertainmentPreferences'],
      shoppingPlans: json['shoppingPlans'],
      specialRequests: json['specialRequests'],
      result: json['result'],
    );
  }

  // BudgetPlanModel'den JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromCountry': fromCountry,
      'toCountry': toCountry,
      'numberOfDays': numberOfDays,
      'numberOfPeople': numberOfPeople,
      'kids': kids.map((kid) => kid.toJson()).toList(),
      'breakfastPlan': breakfastPlan,
      'mealPlan': mealPlan,
      'entertainmentPreferences': entertainmentPreferences,
      'shoppingPlans': shoppingPlans,
      'specialRequests': specialRequests,
      'result': result,
      'type': type, // Sabit değer JSON'a ekleniyor
    };
  }
}
