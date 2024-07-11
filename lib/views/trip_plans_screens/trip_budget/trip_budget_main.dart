import 'package:flutter/material.dart';

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
  int _currentIndex = 0;
  final List<Widget> _pages = [
    UlkeSecimiPage(),
    const KisiSayisiPage(),
    KalacakGunSayisiPage(),
    GezilecekYerlerPage(),
    TatilPlaniPage(),
    const ButcePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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
      ),
    );
  }
}