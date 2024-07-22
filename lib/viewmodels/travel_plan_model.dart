import 'package:flutter_riverpod/flutter_riverpod.dart';

class TravelInformation {
  final String country;
  final double budget;
  final int numberOfDays;
  final int numberOfPeople;
  final bool kid;
  final String travelPlanDetails;

  TravelInformation({
    required this.country,
    required this.budget,
    required this.numberOfDays,
    required this.numberOfPeople,
    required this.kid,
    required this.travelPlanDetails,
  });

  factory TravelInformation.initial() {
    return TravelInformation(
      country: '',
      budget: 0.0,
      numberOfDays: 0,
      numberOfPeople: 0,
      kid: false,
      travelPlanDetails: '',
    );
  }

  TravelInformation copyWith({
    String? country,
    double? budget,
    int? numberOfDays,
    int? numberOfPeople,
    bool? kid,
    String? travelPlanDetails,
  }) {
    return TravelInformation(
      country: country ?? this.country,
      budget: budget ?? this.budget,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      kid: kid ?? this.kid,
      travelPlanDetails: travelPlanDetails ?? this.travelPlanDetails,
    );
  }
}

// TatilVerileri için StateNotifier
class TravelInformationNotifier extends StateNotifier<TravelInformation> {
  TravelInformationNotifier() : super(TravelInformation.initial());

  void reset() {
    state = TravelInformation.initial();
  }

  void updateCountry(String country) {
    state = state.copyWith(country: country);
  }

  void updateBudget(double budget) {
    state = state.copyWith(budget: budget);
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

  void updateTravelPlanDetails(String travelPlanDetails) {
    state = state.copyWith(travelPlanDetails: travelPlanDetails);
  }
}

// Global provider
final travelInformationProvider =
StateNotifierProvider<TravelInformationNotifier, TravelInformation>((ref) {
  return TravelInformationNotifier();
});