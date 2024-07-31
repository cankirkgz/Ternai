import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/models/budget_plan_model.dart';
import 'package:travelguide/models/kid_model.dart';

class TravelInformation {
  final String country;
  final int numberOfPeople;
  final int numberOfDays;
  final bool kid;
  final List<KidModel> children;
  final String breakfastPlan;
  final String foodPreferences;
  final String placesToVisit;
  final String entertainmentPreferences;
  final String shoppingPlans;
  final String specialRequests;

  TravelInformation({
    required this.country,
    required this.numberOfPeople,
    required this.numberOfDays,
    required this.kid,
    required this.children,
    required this.breakfastPlan,
    required this.foodPreferences,
    required this.placesToVisit,
    required this.entertainmentPreferences,
    required this.shoppingPlans,
    required this.specialRequests,
  });

  factory TravelInformation.initial() {
    return TravelInformation(
      country: '',
      numberOfPeople: 0,
      numberOfDays: 0,
      kid: false,
      children: [],
      breakfastPlan: '',
      foodPreferences: '',
      placesToVisit: '',
      entertainmentPreferences: '',
      shoppingPlans: '',
      specialRequests: '',
    );
  }

  TravelInformation copyWith({
    String? country,
    int? numberOfPeople,
    int? numberOfDays,
    bool? kid,
    List<KidModel>? children,
    String? breakfastPlan,
    String? foodPreferences,
    String? placesToVisit,
    String? entertainmentPreferences,
    String? shoppingPlans,
    String? specialRequests,
  }) {
    return TravelInformation(
      country: country ?? this.country,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      kid: kid ?? this.kid,
      children: children ?? this.children,
      breakfastPlan: breakfastPlan ?? this.breakfastPlan,
      foodPreferences: foodPreferences ?? this.foodPreferences,
      placesToVisit: placesToVisit ?? this.placesToVisit,
      entertainmentPreferences:
          entertainmentPreferences ?? this.entertainmentPreferences,
      shoppingPlans: shoppingPlans ?? this.shoppingPlans,
      specialRequests: specialRequests ?? this.specialRequests,
    );
  }
}

class TravelInformationNotifier extends StateNotifier<TravelInformation> {
  TravelInformationNotifier() : super(TravelInformation.initial());

  void reset() {
    state = TravelInformation.initial();
  }

  void updateCountry(String country) {
    state = state.copyWith(country: country);
  }

  void updateNumberOfPeople(int numberOfPeople) {
    state = state.copyWith(numberOfPeople: numberOfPeople);
  }

  void updateNumberOfDays(int numberOfDays) {
    state = state.copyWith(numberOfDays: numberOfDays);
  }

  void updateKid(bool kid) {
    state = state.copyWith(kid: kid);
  }

  void addChild(KidModel child) {
    state = state.copyWith(children: [...state.children, child]);
  }

  void removeChild(int index) {
    final updatedChildren = List<KidModel>.from(state.children);
    if (index >= 0 && index < updatedChildren.length) {
      updatedChildren.removeAt(index);
      state = state.copyWith(children: updatedChildren);
    }
  }

  void updateBreakfastPlan(String breakfastPlan) {
    state = state.copyWith(breakfastPlan: breakfastPlan);
  }

  void updateFoodPreferences(String foodPreferences) {
    state = state.copyWith(foodPreferences: foodPreferences);
  }

  void updatePlacesToVisit(String placesToVisit) {
    state = state.copyWith(placesToVisit: placesToVisit);
  }

  void updateEntertainmentPreferences(String entertainmentPreferences) {
    state = state.copyWith(entertainmentPreferences: entertainmentPreferences);
  }

  void updateShoppingPlans(String shoppingPlans) {
    state = state.copyWith(shoppingPlans: shoppingPlans);
  }

  void updateSpecialRequests(String specialRequests) {
    state = state.copyWith(specialRequests: specialRequests);
  }
}

// Global provider
final travelInformationProvider =
    StateNotifierProvider<TravelInformationNotifier, TravelInformation>((ref) {
  return TravelInformationNotifier();
});


Future<List<BudgetPlanModel>> fetchBudgetPlans(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final budgetPlansData = userDoc.data()?['budget_plans'] as List<dynamic>? ?? [];

    return budgetPlansData.map((data) {
      return BudgetPlanModel.fromJson(data as Map<String, dynamic>);
    }).toList();
  }