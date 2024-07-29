import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/models/kid_model.dart';

class TravelInformation {
  final String fromCountry;
  final String toCountry;
  final double budget;
  final String currency; // Yeni eklenen alan
  final int numberOfDays;
  final int numberOfPeople;
  final bool kid;
  final List<KidModel> children;
  final String breakfastPlan;
  final String foodPreferences;
  final String placesToVisit;
  final String entertainmentPreferences;
  final String shoppingPlans;
  final String specialRequests;

  TravelInformation({
    required this.fromCountry,
    required this.toCountry,
    required this.budget,
    required this.currency,
    required this.numberOfDays,
    required this.numberOfPeople,
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
      fromCountry: '',
      toCountry: '',
      budget: 0.0,
      currency: 'TRY', // Varsayılan değer
      numberOfDays: 0,
      numberOfPeople: 0,
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
    String? fromCountry,
    String? toCountry,
    double? budget,
    String? currency,
    int? numberOfDays,
    int? numberOfPeople,
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
      fromCountry: fromCountry ?? this.fromCountry,
      toCountry: toCountry ?? this.toCountry,
      budget: budget ?? this.budget,
      currency: currency ?? this.currency,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
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

// TatilVerileri için StateNotifier
class TravelInformationNotifier extends StateNotifier<TravelInformation> {
  TravelInformationNotifier() : super(TravelInformation.initial());

  void reset() {
    state = TravelInformation.initial();
  }

  void updateFromCountry(String fromCountry) {
    state = state.copyWith(fromCountry: fromCountry);
  }

  void updateToCountry(String toCountry) {
    state = state.copyWith(toCountry: toCountry);
  }

  void updateBudget(double budget) {
    state = state.copyWith(budget: budget);
  }

  void updateCurrency(String currency) {
    state = state.copyWith(currency: currency);
  }

  void updateNumberOfDays(int numberOfDays) {
    state = state.copyWith(numberOfDays: numberOfDays);
  }

  void updateNumberOfPeople(int numberOfPeople) {
    state = state.copyWith(numberOfPeople: numberOfPeople);
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

  void updateBreakfastPlan(String kahvaltiPlani) {
    state = state.copyWith(breakfastPlan: kahvaltiPlani);
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
