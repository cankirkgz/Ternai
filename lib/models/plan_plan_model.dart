import 'package:travelguide/models/kid_model.dart';

class PlanPlanModel {
  final String id;
  final String fromCountry;
  final String toCountry;
  final int numberOfDays;
  final int numberOfPeople;
  final List<KidModel> kids;
  final double budget;
  final String currency;
  final String? breakfastPlan;
  final String? mealPlan;
  final String? entertainmentPreferences;
  final String? shoppingPlans;
  final String? specialRequests;
  final String result;
  final String type = 'plan'; // Sabit değer

  PlanPlanModel({
    required this.id,
    required this.fromCountry,
    required this.toCountry,
    required this.numberOfDays,
    required this.numberOfPeople,
    required this.kids,
    required this.budget,
    required this.currency,
    this.breakfastPlan,
    this.mealPlan,
    this.entertainmentPreferences,
    this.shoppingPlans,
    this.specialRequests,
    required this.result,
  });

  // JSON'dan PlanPlanModel'e dönüşüm
  factory PlanPlanModel.fromJson(Map<String, dynamic> json) {
    return PlanPlanModel(
      id: json['id'],
      fromCountry: json['fromCountry'],
      toCountry: json['toCountry'],
      numberOfDays: json['numberOfDays'],
      numberOfPeople: json['numberOfPeople'],
      kids: (json['kids'] as List<dynamic>)
          .map((kid) => KidModel.fromJson(kid))
          .toList(),
      budget: json['budget'],
      currency: json['currency'],
      breakfastPlan: json['breakfastPlan'],
      mealPlan: json['mealPlan'],
      entertainmentPreferences: json['entertainmentPreferences'],
      shoppingPlans: json['shoppingPlans'],
      specialRequests: json['specialRequests'],
      result: json['result'],
    );
  }

  // PlanPlanModel'den JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromCountry': fromCountry,
      'toCountry': toCountry,
      'numberOfDays': numberOfDays,
      'numberOfPeople': numberOfPeople,
      'kids': kids.map((kid) => kid.toJson()).toList(),
      'budget': budget,
      'currency': currency,
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
