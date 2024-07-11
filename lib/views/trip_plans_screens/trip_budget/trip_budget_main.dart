import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:travelguide/views/trip_plans_screens/trip_budget/budget_plan_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/calculated_budget_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/gezilecek_yerler_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/kalacak_gun_sayisi_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/kisi_sayisi_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/ulke_secimi_page.dart';

class TatilButcesiMainPage extends StatefulWidget {
  const TatilButcesiMainPage({super.key});

  @override
  State<TatilButcesiMainPage> createState() => _TatilButcesiMainPageState();
}

class _TatilButcesiMainPageState extends State<TatilButcesiMainPage> {

  final List<Widget> _pages = [
    const UlkeSecimiPage(),
    const KisiSayisiPage(),
    KalacakGunSayisiPage(),
    GezilecekYerlerPage(),
    TatilPlaniPage(),
    const ButcePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white.withOpacity(0.65),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Tatil Bütçesi Hesaplama'),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final _currentIndex = ref.watch(bottomNavigationBarProvider);
          return Container(
                decoration: const BoxDecoration(
                image: DecorationImage(
                  opacity: 0.65,
                  image: AssetImage("assets/images/welcome_page.jpeg"),
            fit: BoxFit.cover,
            ),
            ),
            child: _pages[_currentIndex]);
        },
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, _) {
      final _currentIndex = ref.watch(bottomNavigationBarProvider);
      return BottomNavigationBar(
        backgroundColor: Colors.blue,
        useLegacyColorScheme: false,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            ref.read(bottomNavigationBarProvider.notifier).changePage(index);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Ülke'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Kişi Sayısı'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Gün Sayısı'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Yerler'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Bütçe'),
        ],
      );
        }
    )
    );
  }
}

class BottomNavigationBarNotifier extends StateNotifier<int> {
  BottomNavigationBarNotifier() : super(0);

  void changePage(int index) {
    state = index;
  }
}

final bottomNavigationBarProvider = StateNotifierProvider<BottomNavigationBarNotifier, int>((ref) {
  return BottomNavigationBarNotifier();
});