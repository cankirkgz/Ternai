import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/travel_budget_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class BudgetChoosingCountryPage extends ConsumerWidget {
  const BudgetChoosingCountryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tatilVerileri = ref.watch(tatilVerileriProvider);

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mükemmel bir tatil için bütçe oluşturalım!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Text('Gideceğiniz ülke:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            DropdownButton<String>(

              value: tatilVerileri.ulke.isEmpty ? null : tatilVerileri.ulke,
              hint: const Text('Ülke seçin'),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ref.read(tatilVerileriProvider.notifier).updateUlke(newValue);
                }
              },
              items: <String>['Hollanda', 'Fransa', 'İtalya', 'İspanya']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Devam',
              onPressed: () {
                ref.read(bottomNavigationBarProvider.notifier).changePage(1);
              }, color: Colors.blue,
            ),
          ],
        ),
      );
  }
}