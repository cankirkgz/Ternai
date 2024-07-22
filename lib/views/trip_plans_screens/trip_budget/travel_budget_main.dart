import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';

import 'package:travelguide/views/trip_plans_screens/trip_budget/budget_plan_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/budget_result_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/budget_choosing_plans.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/budget_choosing_day.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/budget_choosing_people.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/budget_choosing_country.dart';

class TravelBudgetMain extends ConsumerStatefulWidget {
  const TravelBudgetMain({super.key});

  @override
  ConsumerState<TravelBudgetMain> createState() => _TravelBudgetMainPageState();
}

class _TravelBudgetMainPageState extends ConsumerState<TravelBudgetMain> {

  final List<Widget> _pages = [
    const BudgetChoosingCountryPage(),
    const BudgetChoosingPeoplePage(),
    BudgetChoosingDayPage(),
    BudgetChoosingPlansPage(),
    BudgetPlanPage(),
    BudgetResultPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool) {
        ref.read(travelInformationProvider.notifier).reset();
      },
      child: Scaffold(
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
      ),
    );
  }
}

class BottomNavigationBarNotifier extends StateNotifier<int> {
  BottomNavigationBarNotifier() : super(0);

  void changePage(int index) {
    state = index;
  }
}

final bottomNavigationBarProvider = AutoDisposeStateNotifierProvider<BottomNavigationBarNotifier, int>((ref) {
  return BottomNavigationBarNotifier();
});