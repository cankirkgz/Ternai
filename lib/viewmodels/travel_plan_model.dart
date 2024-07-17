import 'package:flutter_riverpod/flutter_riverpod.dart';

class TravelInformation {
  final String country;
  final double budget;
  final int numberOfDays;
  final int numberOfPeople;
  final List<String> placesToVisit;
  final bool kid;

  TravelInformation({
    required this.country,
    required this.budget,
    required this.numberOfDays,
    required this.numberOfPeople,
    required this.placesToVisit,
    required this.kid
  });

  factory TravelInformation.initial() {
    return TravelInformation(
      country: '',
      budget: 0.0,
      numberOfDays: 15,
      numberOfPeople: 3,
      placesToVisit: [],
      kid: false,
    );
  }

  TravelInformation copyWith({
    String? country,
    double? budget,
    int? numberOfDays,
    int? numberOfPeople,
    List<String>? placesToVisit,
    bool? kid,
  }) {
    return TravelInformation(
      country: country ?? this.country,
      budget: budget ?? this.budget,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
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

  void updateBudget(double budget) {
    state = state.copyWith(budget: budget);
  }

  void updateNumberOfDays(int numberOfDays) {
    state = state.copyWith(numberOfDays: numberOfDays);
  }

  void updateNumberOfPeople(int numberOfPeople) {
    state = state.copyWith(numberOfPeople: numberOfPeople);
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