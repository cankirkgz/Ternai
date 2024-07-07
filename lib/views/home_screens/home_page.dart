import 'package:flutter/material.dart';
import 'package:travelguide/views/home_screens/new_trip_screen.dart';
import 'package:travelguide/views/home_screens/previous_trips_screen.dart';
import 'package:travelguide/views/home_screens/price_search_screen.dart';
import 'package:travelguide/views/home_screens/profile_screen.dart';
import 'package:travelguide/views/home_screens/home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    PriceSearchScreen(),
    NewTripScreen(),
    PreviousTripsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Fiyat Araması',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Yeni Tatil Planı',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Önceki Tatiller',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
