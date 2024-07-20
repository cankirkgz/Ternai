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
    final tatilVerileri = ref.watch(tatilVerileriProvider);

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
                  if (tatilVerileri.kisiSayisi > 1) {
                    ref
                        .read(tatilVerileriProvider.notifier)
                        .updateKisiSayisi(tatilVerileri.kisiSayisi - 1);
                  }
                },
              ),
              Text('${tatilVerileri.kisiSayisi}',
                  style: const TextStyle(fontSize: 24)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  ref
                      .read(tatilVerileriProvider.notifier)
                      .updateKisiSayisi(tatilVerileri.kisiSayisi + 1);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Devam',
            onPressed: () {
              ref.read(bottomNavigationBarProvider.notifier).changePage(2);
              print(tatilVerileri.kisiSayisi);
            },
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
