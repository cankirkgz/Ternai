import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tatil verilerini tutan model sınıfı
class TatilVerileri {
  final String ulke;
  final int kisiSayisi;
  final int gunSayisi;
  final List<String> gezilecekYerler;
  final bool cocukVarMi;
  final String tatilPlanDetaylari;

  TatilVerileri({
    required this.ulke,
    required this.kisiSayisi,
    required this.gunSayisi,
    required this.gezilecekYerler,
    required this.cocukVarMi,
    required this.tatilPlanDetaylari,
  });

  factory TatilVerileri.initial() {
    return TatilVerileri(
      ulke: '',
      kisiSayisi: 2,
      gunSayisi: 15,
      gezilecekYerler: [],
      cocukVarMi: false,
      tatilPlanDetaylari: '',
    );
  }

  TatilVerileri copyWith({
    String? ulke,
    int? kisiSayisi,
    int? gunSayisi,
    List<String>? gezilecekYerler,
    bool? cocukVarMi,
    String? tatilPlanDetaylari,
  }) {
    return TatilVerileri(
      ulke: ulke ?? this.ulke,
      kisiSayisi: kisiSayisi ?? this.kisiSayisi,
      gunSayisi: gunSayisi ?? this.gunSayisi,
      gezilecekYerler: gezilecekYerler ?? this.gezilecekYerler,
      cocukVarMi: cocukVarMi ?? this.cocukVarMi,
      tatilPlanDetaylari: tatilPlanDetaylari ?? this.tatilPlanDetaylari,
    );
  }
}

// TatilVerileri için StateNotifier
class TatilVerileriNotifier extends StateNotifier<TatilVerileri> {
  TatilVerileriNotifier() : super(TatilVerileri.initial());

  void reset() {
    state = TatilVerileri.initial();
  }

  void updateUlke(String ulke) {
    state = state.copyWith(ulke: ulke);
  }

  void updateKisiSayisi(int kisiSayisi) {
    state = state.copyWith(kisiSayisi: kisiSayisi);
  }

  void updateGunSayisi(int gunSayisi) {
    state = state.copyWith(gunSayisi: gunSayisi);
  }

  void updateGezilecekYerler(List<String> gezilecekYerler) {
    state = state.copyWith(gezilecekYerler: gezilecekYerler);
  }

  void updateCocukVarMi(bool cocukVarMi) {
    state = state.copyWith(cocukVarMi: cocukVarMi);
  }

  void updateTatilPlanDetails(String tatilPlanDetaylari) {
    state = state.copyWith(tatilPlanDetaylari: tatilPlanDetaylari);
  }
}

// Global provider
final tatilVerileriProvider =
    StateNotifierProvider<TatilVerileriNotifier, TatilVerileri>((ref) {
  return TatilVerileriNotifier();
});

// Bütçe hesaplama provider'ı
final butceProvider = Provider<double>((ref) {
  final tatilVerileri = ref.watch(tatilVerileriProvider);

  // Basit bir bütçe hesaplama örneği
  double toplamButce = 0;
  toplamButce += tatilVerileri.kisiSayisi * 1500; // Uçak bileti
  toplamButce +=
      tatilVerileri.kisiSayisi * tatilVerileri.gunSayisi * 150; // Konaklama
  toplamButce +=
      tatilVerileri.kisiSayisi * tatilVerileri.gunSayisi * 100; // Yemek
  toplamButce +=
      tatilVerileri.kisiSayisi * tatilVerileri.gunSayisi * 30; // Ulaşım
  toplamButce += tatilVerileri.kisiSayisi *
      tatilVerileri.gezilecekYerler.length *
      60; // Aktiviteler

  // Örnek olarak, tatil planı detaylarından bütçeye ekleyebileceğimiz bir kalem:
  if (tatilVerileri.tatilPlanDetaylari.isNotEmpty) {
    toplamButce +=
        500; // Tatil planı detayları için ek bütçe (örneğin eğlence, ekstra aktiviteler)
  }

  return toplamButce;
});
