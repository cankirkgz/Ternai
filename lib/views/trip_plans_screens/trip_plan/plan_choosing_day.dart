import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/travel_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/travel_plan_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class PlanChoosingDayPage extends ConsumerWidget {
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
              const Text('Kalacak gün sayısı:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (travelInformation.numberOfDays > 1) {
                        ref.read(travelinformationProvider.notifier)
                            .updateNumberOfDays(travelInformation.numberOfDays - 1);
                      }
                    },
                  ),
                  Text('${travelInformation.numberOfDays}', style: const TextStyle(fontSize: 24)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      ref.read(travelinformationProvider.notifier)
                          .updateNumberOfDays(travelInformation.numberOfDays + 1);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Devam',
                onPressed: () {
                  ref.read(bottomNavigationBarProvider.notifier).changePage(3);
                }, color: Colors.blue,
              ),
            ],
          ),
        );
  }
}