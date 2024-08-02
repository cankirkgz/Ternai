import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/views/home_screens/new_trip_screen.dart';
import 'package:travelguide/views/home_screens/prev_screen/previous_trips_screen.dart';
import 'package:travelguide/views/home_screens/price_search_screen.dart';
import 'package:travelguide/views/home_screens/profile_screen.dart';
import 'package:travelguide/views/home_screens/home_screen.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const double selectedIconSize = 30.0; // Seçilen ikonun boyutu
  static const double unselectedIconSize = 24.0; // Seçilmeyen ikonların boyutu

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    PriceSearchScreen(),
    PreviousTripsScreen(),
    ProfileScreen(),
  ];

  static const List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.history,
    Icons.person,
  ];

  void _onItemTapped(int index) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    if (index == 2 &&
        (authViewModel.user == null || authViewModel.user!.isAnonymous)) {
      _showAnonymousWarning();
      return; // Anonim kullanıcılar PreviousTripsScreen'e giremez
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAnonymousWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Anonim Kullanıcı'),
          content: const Text(
              'Anonim kullanıcı olarak sadece fiyat araması yapabilirsiniz. Diğer özelliklere erişmek için kayıt olmalısınız.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    return true; // Geri tuşuna basıldığında uygulamayı kapatır
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBody: true,
        body: _pages[_selectedIndex],
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (authViewModel.user == null || authViewModel.user!.isAnonymous) {
              _showAnonymousWarning();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewTripScreen()),
              );
            }
          },
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 0.0,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: AnimatedBottomNavigationBar.builder(
            height: 55,
            itemCount: _icons.length,
            tabBuilder: (int index, bool isActive) {
              final color = isActive ? Colors.white : Colors.white;
              final size = isActive ? selectedIconSize : unselectedIconSize;
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _icons[index],
                    size: size,
                    color: color,
                  ),
                  const SizedBox(height: 4),
                  if (isActive)
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    )
                ],
              );
            },
            backgroundColor: AppColors.primaryColor,
            activeIndex: _selectedIndex,
            splashColor: AppColors.primaryColor,
            notchSmoothness: NotchSmoothness.smoothEdge,
            gapLocation: GapLocation.center,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
