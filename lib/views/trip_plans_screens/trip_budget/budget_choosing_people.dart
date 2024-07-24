import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/travel_budget_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class BudgetChoosingPeoplePage extends ConsumerWidget {
  const BudgetChoosingPeoplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelInformation = ref.watch(travelInformationProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Mükemmel bir tatil için bütçe oluşturalım!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Gidecek kişi sayısı:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (travelInformation.numberOfPeople > 1) {
                    ref
                        .read(travelInformationProvider.notifier)
                        .updateNumberOfPeople(travelInformation.numberOfPeople - 1);
                  }
                },
              ),
              Text('${travelInformation.numberOfPeople}',
                  style: const TextStyle(fontSize: 24)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  ref
                      .read(travelInformationProvider.notifier)
                      .updateNumberOfPeople(travelInformation.numberOfPeople + 1);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Devam',
            onPressed: () {
              if (travelInformation.numberOfPeople == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen kişi sayısı seçin!'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              }else{
                ref.read(bottomNavigationBarProvider.notifier).changePage(2);
              }
            },
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
