import 'package:flutter_riverpod/flutter_riverpod.dart';

class TravelInformation {
  final String country;
  final int numberOfPeople;
  final double budget;
  final List<String> placesToVisit;
  final bool kid;

  TravelInformation({
    required this.country,
    required this.numberOfPeople,
    required this.budget,
    required this.placesToVisit,
    required this.kid
  });

  factory TravelInformation.initial() {
    return TravelInformation(
      country: '',
      numberOfPeople: 3,
      budget: 0.0,
      placesToVisit: [],
      kid: false,
    );
  }

  TravelInformation copyWith({
    String? country,
    int? numberOfPeople,
    double? budget,
    List<String>? placesToVisit,
    bool? kid,
  }) {
    return TravelInformation(
      country: country ?? this.country,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      budget: budget ?? this.budget,
      placesToVisit: placesToVisit ?? this.placesToVisit,
      kid: kid ?? this.kid
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

  void updatePlacesToVisit(List<String> placesToVisit) {
    state = state.copyWith(placesToVisit: placesToVisit);
  }

  void updateKid(bool kid) {
    state = state.copyWith(kid: kid);
  }
}

// Global provider
final travelinformationProvider =
StateNotifierProvider<TravelInformationNotifier, TravelInformation>((ref) {
  return TravelInformationNotifier();
});