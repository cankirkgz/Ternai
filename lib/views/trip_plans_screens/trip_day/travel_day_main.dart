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
    DayPlanPage(),
    DayResultPage()
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
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
              'Tatil Günü Hesaplama',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ), // Metin rengini siyah yap
            ),
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
            bool selectedValue = true;

            if(index == 1)
            {
              final travelInformation = ref.read(travelInformationProvider);
              if(travelInformation.toCountry.isEmpty)
              {
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

            if(index == 2)
            {
              final travelInformation = ref.read(travelInformationProvider);
              if(travelInformation.numberOfPeople == 0)
              {
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

            if(index == 3)
            {
              final travelInformation = ref.read(travelInformationProvider);
              if(travelInformation.budget == 0)
              {
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

            if(index == 4)
            {
              final travelInformation = ref.read(travelInformationProvider);
              if(travelInformation.breakfastPlan.isEmpty ||
                travelInformation.foodPreferences.isEmpty ||
                travelInformation.placesToVisit.isEmpty ||
                travelInformation.entertainmentPreferences.isEmpty ||
                travelInformation.shoppingPlans.isEmpty ||
                travelInformation.specialRequests.isEmpty)
              {
                selectedValue = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen tüm tatil planı alanlarını doldurun!'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }

            if(selectedValue)
            {
              setState(() {
                ref.read(bottomNavigationBarProvider.notifier).changePage(index);
              });
            }
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