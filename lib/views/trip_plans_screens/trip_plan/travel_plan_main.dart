import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/travel_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/plan_choosing_budget.dart';

import 'package:travelguide/views/trip_plans_screens/trip_plan/plan_choosing_country.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/plan_choosing_day.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/plan_choosing_people.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/plan_choosing_plans.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/plan_plan_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/plan_result_page.dart';

class TravelPlanMain extends ConsumerStatefulWidget {
  const TravelPlanMain({super.key});

  @override
  ConsumerState<TravelPlanMain> createState() => _TravelPlanMainPageState();
}

class _TravelPlanMainPageState extends ConsumerState<TravelPlanMain> {

  final List<Widget> _pages = [
    const PlanChoosingCountryPage(),
    const PlanChoosingBudgetPage(),
    PlanChoosingDayPage(),
    const PlanChoosingPeoplePage(),
    PlanChoosingPlansPage(),
    PlanPlanPage(),
    PlanResultPage()
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
          title: const Text('Tatil Planı Oluşturma'),
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
            BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Bütçe'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Gün Sayısı'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Kişi Sayısı'),
            BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Yerler'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Plan'),
            BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Son'),
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