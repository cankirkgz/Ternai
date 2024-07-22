import 'package:flutter_riverpod/flutter_riverpod.dart';

class TravelInformation {
  final String country;
  final int numberOfPeople;
  final double budget;
  final bool kid;
  final String travelPlanDetails;

  TravelInformation({
    required this.country,
    required this.numberOfPeople,
    required this.budget,
    required this.kid,
    required this.travelPlanDetails,
  });

  factory TravelInformation.initial() {
    return TravelInformation(
      country: '',
      numberOfPeople: 0,
      budget: 0.0,
      kid: false,
      travelPlanDetails: '',
    );
  }

  TravelInformation copyWith({
    String? country,
    int? numberOfPeople,
    double? budget,
    bool? kid,
    String? travelPlanDetails,
  }) {
    return TravelInformation(
      country: country ?? this.country,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      budget: budget ?? this.budget,
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

  void updateNumberOfPeople(int numberOfPeople) {
    state = state.copyWith(numberOfPeople: numberOfPeople);
  }

  void updateBudget(double budget) {
    state = state.copyWith(budget: budget);
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