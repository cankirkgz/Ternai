import 'package:flutter_riverpod/flutter_riverpod.dart';

class TravelInformation {
  final String fromCountry;
  final String toCountry;
  final double budget;
  final String currency; // Yeni eklenen alan
  final int numberOfDays;
  final int numberOfPeople;
  final bool kid;
  final String kahvaltiPlani;
  final String yemekTercihleri;
  final String gezilecekYerler;
  final String eglenceTercihleri;
  final String alisverisPlanlari;
  final String ozelIstekler;

  TravelInformation({
    required this.fromCountry,
    required this.toCountry,
    required this.budget,
    required this.currency,
    required this.numberOfDays,
    required this.numberOfPeople,
    required this.kid,
    required this.kahvaltiPlani,
    required this.yemekTercihleri,
    required this.gezilecekYerler,
    required this.eglenceTercihleri,
    required this.alisverisPlanlari,
    required this.ozelIstekler,
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
      kahvaltiPlani: '',
      yemekTercihleri: '',
      gezilecekYerler: '',
      eglenceTercihleri: '',
      alisverisPlanlari: '',
      ozelIstekler: '',
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
    String? kahvaltiPlani,
    String? yemekTercihleri,
    String? gezilecekYerler,
    String? eglenceTercihleri,
    String? alisverisPlanlari,
    String? ozelIstekler,
  }) {
    return TravelInformation(
      fromCountry: fromCountry ?? this.fromCountry,
      toCountry: toCountry ?? this.toCountry,
      budget: budget ?? this.budget,
      currency: currency ?? this.currency,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      kid: kid ?? this.kid,
      kahvaltiPlani: kahvaltiPlani ?? this.kahvaltiPlani,
      yemekTercihleri: yemekTercihleri ?? this.yemekTercihleri,
      gezilecekYerler: gezilecekYerler ?? this.gezilecekYerler,
      eglenceTercihleri: eglenceTercihleri ?? this.eglenceTercihleri,
      alisverisPlanlari: alisverisPlanlari ?? this.alisverisPlanlari,
      ozelIstekler: ozelIstekler ?? this.ozelIstekler,
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

  void updateKahvaltiPlani(String kahvaltiPlani) {
    state = state.copyWith(kahvaltiPlani: kahvaltiPlani);
  }

  void updateYemekTercihleri(String yemekTercihleri) {
    state = state.copyWith(yemekTercihleri: yemekTercihleri);
  }

  void updateGezilecekYerler(String gezilecekYerler) {
    state = state.copyWith(gezilecekYerler: gezilecekYerler);
  }

  void updateEglenceTercihleri(String eglenceTercihleri) {
    state = state.copyWith(eglenceTercihleri: eglenceTercihleri);
  }

  void updateAlisverisPlanlari(String alisverisPlanlari) {
    state = state.copyWith(alisverisPlanlari: alisverisPlanlari);
  }

  void updateOzelIstekler(String ozelIstekler) {
    state = state.copyWith(ozelIstekler: ozelIstekler);
  }
}

// Global provider
final travelInformationProvider =
    StateNotifierProvider<TravelInformationNotifier, TravelInformation>((ref) {
  return TravelInformationNotifier();
});
