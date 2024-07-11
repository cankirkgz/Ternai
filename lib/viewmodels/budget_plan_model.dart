import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tatil verilerini tutan model sınıfı
class TatilVerileri {
  final String ulke;
  final int kisiSayisi;
  final int gunSayisi;
  final List<String> gezilecekYerler;
  final bool cocukVarMi;

  TatilVerileri({
    required this.ulke,
    required this.kisiSayisi,
    required this.gunSayisi,
    required this.gezilecekYerler,
    required this.cocukVarMi,
  });

  TatilVerileri copyWith({
    String? ulke,
    int? kisiSayisi,
    int? gunSayisi,
    List<String>? gezilecekYerler,
    bool? cocukVarMi,
  }) {
    return TatilVerileri(
      ulke: ulke ?? this.ulke,
      kisiSayisi: kisiSayisi ?? this.kisiSayisi,
      gunSayisi: gunSayisi ?? this.gunSayisi,
      gezilecekYerler: gezilecekYerler ?? this.gezilecekYerler,
      cocukVarMi: cocukVarMi ?? this.cocukVarMi,
    );
  }
}

// TatilVerileri için StateNotifier
class TatilVerileriNotifier extends StateNotifier<TatilVerileri> {
  TatilVerileriNotifier()
      : super(TatilVerileri(
    ulke: '',
    kisiSayisi: 1,
    gunSayisi: 1,
    gezilecekYerler: [],
    cocukVarMi: false,
  ));

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
  toplamButce += tatilVerileri.kisiSayisi * tatilVerileri.gunSayisi * 150; // Konaklama
  toplamButce += tatilVerileri.kisiSayisi * tatilVerileri.gunSayisi * 100; // Yemek
  toplamButce += tatilVerileri.kisiSayisi * tatilVerileri.gunSayisi * 30; // Ulaşım
  toplamButce += tatilVerileri.kisiSayisi * tatilVerileri.gezilecekYerler.length * 60; // Aktiviteler

  return toplamButce;
});