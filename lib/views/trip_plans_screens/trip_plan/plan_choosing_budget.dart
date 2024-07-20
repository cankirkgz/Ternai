import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/travel_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/travel_plan_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class PlanChoosingBudgetPage extends ConsumerWidget {
  const PlanChoosingBudgetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelInformation = ref.watch(travelinformationProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Mükemmel bir tatil planı oluşturalım!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 20),
          const Text('Bütçeniz:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          DropdownButton<double>(
            value: travelInformation.budget == 0.0 ? null : travelInformation.budget,
            hint: const Text('Bütçe seçin'),
            onChanged: (double? newValue) {
              if (newValue != null) {
                ref.read(travelinformationProvider.notifier).updateBudget(newValue);
              }
            },
            items: <double>[
              0.0,
              1000.0,
              2000.0,
              3000.0,
              4000.0,
              5000.0,
              6000.0,
              7000.0,
              8000.0,
              9000.0,
              10000.0,
            ].map<DropdownMenuItem<double>>((double value) {
              return DropdownMenuItem<double>(
                value: value,
                child: Text(value == 0.0 ? 'Belirtmek istemiyorum' : '${value.toInt()} - ${value.toInt() + 1000}'),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Devam',
            onPressed: () {
              ref.read(bottomNavigationBarProvider.notifier).changePage(2);
            },
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
