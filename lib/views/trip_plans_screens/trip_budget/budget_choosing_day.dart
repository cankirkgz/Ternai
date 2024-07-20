import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/travel_budget_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class BudgetChoosingDayPage extends ConsumerWidget {
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
          const Text('Kalacak gün sayısı:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (tatilVerileri.gunSayisi > 1) {
                    ref
                        .read(tatilVerileriProvider.notifier)
                        .updateGunSayisi(tatilVerileri.gunSayisi - 1);
                  }
                },
              ),
              Text('${tatilVerileri.gunSayisi}',
                  style: const TextStyle(fontSize: 24)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  ref
                      .read(tatilVerileriProvider.notifier)
                      .updateGunSayisi(tatilVerileri.gunSayisi + 1);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Devam',
            onPressed: () {
              ref.read(bottomNavigationBarProvider.notifier).changePage(3);
              print("${tatilVerileri.gunSayisi}");
            },
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
