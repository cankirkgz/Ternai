import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/day_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/day_choosing_budget.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/day_choosing_country.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/day_choosing_people.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/day_choosing_plans.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/day_plan_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/day_result_page.dart';

class TravelDayMain extends ConsumerStatefulWidget {
  const TravelDayMain({super.key});

  @override
  ConsumerState<TravelDayMain> createState() => _TravelDayMainPageState();
}

class _TravelDayMainPageState extends ConsumerState<TravelDayMain> {

  final List<Widget> _pages = [
    const DayChoosingCountryPage(),
    const DayChoosingPeoplePage(),
    const DayChoosingBudgetPage(),
    DayChoosingPlansPage(),
    const DayPlanPage(),
    const DayResultPage()
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
          title: const Text('Tatil Günü Hesaplama'),
        ),
        body: Consumer(
          builder: (context, ref, _) {
            final currentIndex = ref.watch(bottomNavigationBarProvider);
            return Container(
                  decoration: const BoxDecoration(
                  image: DecorationImage(
                    opacity: 0.65,
                    image: AssetImage("assets/images/welcome_page.jpeg"),
              fit: BoxFit.cover,
              ),
              ),
              child: _pages[currentIndex]);
          },
        ),
        bottomNavigationBar: Consumer(
          builder: (context, ref, _) {
        final currentIndex = ref.watch(bottomNavigationBarProvider);
        return BottomNavigationBar(
          backgroundColor: Colors.blue,
          useLegacyColorScheme: false,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              ref.read(bottomNavigationBarProvider.notifier).changePage(index);
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Ülke'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Kişi Sayısı'),
            BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Bütçe'),
            BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Yerler'),
            BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Plan'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Gün Sayısı')
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