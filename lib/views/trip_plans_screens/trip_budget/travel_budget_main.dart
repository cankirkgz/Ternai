import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/theme/theme.dart';
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
    const BudgetPlanPage(),
    BudgetResultPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool) {
        ref.read(travelInformationProvider.notifier).reset();
      },
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Arka planı beyaz yap
            elevation: 0, // Gölgeyi kaldırmak için 0 yapabilirsiniz
            title: const Text(
              'Tatil Bütçesi Hesaplama',
            ),
          ),
          body: Consumer(
            builder: (context, ref, _) {
              final _currentIndex = ref.watch(bottomNavigationBarProvider);
              return Container(
                  child: _pages[_currentIndex]);
            },
          ),
          bottomNavigationBar: Consumer(builder: (context, ref, _) {
            final _currentIndex = ref.watch(bottomNavigationBarProvider);
            return BottomNavigationBar(
              backgroundColor: Colors.blue,
              useLegacyColorScheme: false,
              currentIndex: _currentIndex,
              onTap: (index) {
                bool selectedValue = true;

                if (index == 1) {
                  final travelInformation = ref.read(travelInformationProvider);
                  if (travelInformation.country.isEmpty) {
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
                  if (travelInformation.breakfastPlan.isEmpty ||
                      travelInformation.foodPreferences.isEmpty ||
                      travelInformation.placesToVisit.isEmpty ||
                      travelInformation.entertainmentPreferences.isEmpty ||
                      travelInformation.shoppingPlans.isEmpty ||
                      travelInformation.specialRequests.isEmpty) {
                    selectedValue = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lütfen tatil planı alanlarından en az birini doldurun!'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                }

                if (selectedValue) {
                  setState(() {
                    ref
                        .read(bottomNavigationBarProvider.notifier)
                        .changePage(index);
                  });
                }
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Ülke'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.people), label: 'Kişi Sayısı'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today), label: 'Gün Sayısı'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.place), label: 'Yerler'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.schedule), label: 'Plan'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.attach_money), label: 'Bütçe'),
              ],
            );
          })),
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
    AutoDisposeStateNotifierProvider<BottomNavigationBarNotifier, int>((ref) {
  return BottomNavigationBarNotifier();
});
