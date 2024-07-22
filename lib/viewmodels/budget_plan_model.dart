import 'package:flutter_riverpod/flutter_riverpod.dart';

class TravelInformation {
  final String country;
  final int numberOfPeople;
  final int numberOfDays;
  final bool kid;
  final String kahvaltiPlani;
  final String yemekTercihleri;
  final String gezilecekYerler;
  final String eglenceTercihleri;
  final String alisverisPlanlari;
  final String ozelIstekler;

  TravelInformation({
    required this.country,
    required this.numberOfPeople,
    required this.numberOfDays,
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
      country: '',
      numberOfPeople: 0,
      numberOfDays: 0,
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
    String? country,
    int? numberOfPeople,
    int? numberOfDays,
    bool? kid,
    String? kahvaltiPlani,
    String? yemekTercihleri,
    String? gezilecekYerler,
    String? eglenceTercihleri,
    String? alisverisPlanlari,
    String? ozelIstekler,
  }) {
    return TravelInformation(
      country: country ?? this.country,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      numberOfDays: numberOfDays ?? this.numberOfDays,
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

// TatilVerileri iÃ§in StateNotifier
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
