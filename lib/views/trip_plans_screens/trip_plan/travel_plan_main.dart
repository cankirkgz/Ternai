import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/theme/theme.dart';
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
    const PlanChoosingDayPage(),
    const PlanChoosingPeoplePage(),
    PlanChoosingPlansPage(),
    const PlanPlanPage(),
    PlanResultPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Tatil Planı Oluşturma',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              final _currentIndex = ref.watch(bottomNavigationBarProvider);
              return _pages[_currentIndex];
            },
          ),
        ],
      ),
      bottomNavigationBar: Consumer(builder: (context, ref, _) {
        final _currentIndex = ref.watch(bottomNavigationBarProvider);
        return BottomNavigationBar(
          backgroundColor: Colors.blueAccent,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.black,
          currentIndex: _currentIndex,
          onTap: (index) {
            bool selectedValue = true;

            if (index == 1) {
              final travelInformation = ref.read(travelInformationProvider);
              if (travelInformation.toCountry.isEmpty) {
                selectedValue = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen bir ülke seçin!'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }

            if (index == 2) {
              final travelInformation = ref.read(travelInformationProvider);
              if (travelInformation.budget == 0) {
                selectedValue = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen geçerli bir bütçe girin!'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }

            if (index == 3) {
              final travelInformation = ref.read(travelInformationProvider);
              if (travelInformation.numberOfDays == 0) {
                selectedValue = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen gün sayısı seçin!'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }

            if (index == 4) {
              final travelInformation = ref.read(travelInformationProvider);
              if (travelInformation.numberOfPeople == 0) {
                selectedValue = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen kişi sayısı seçin!'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }

            if (index == 5) {
              final travelInformation = ref.read(travelInformationProvider);
              if (travelInformation.breakfastPlan.isEmpty ||
                  travelInformation.foodPreferences.isEmpty ||
                  travelInformation.placesToVisit.isEmpty ||
                  travelInformation.entertainmentPreferences.isEmpty ||
                  travelInformation.shoppingPlans.isEmpty ||
                  travelInformation.specialRequests.isEmpty) {
                selectedValue = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Lütfen tüm tatil planı alanlarını doldurun!'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }

            if (selectedValue) {
              ref.read(bottomNavigationBarProvider.notifier).changePage(index);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Ülke'),
            BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Bütçe'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: 'Gün Sayısı'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'Kişi Sayısı'),
            BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Yerler'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Plan'),
            BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Son'),
          ],
        );
      }),
    );
  }
}

class BottomNavigationBarNotifier extends StateNotifier<int> {
  BottomNavigationBarNotifier() : super(0);

  void changePage(int index) {
    state = index;
  }
}

final bottomNavigationBarProvider =
    StateNotifierProvider<BottomNavigationBarNotifier, int>((ref) {
  return BottomNavigationBarNotifier();
});