import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/travel_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/travel_plan_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class PlanChoosingPeoplePage extends ConsumerWidget {
  const PlanChoosingPeoplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelInformation = ref.watch(travelInformationProvider);

    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Mükemmel bir tatil planı oluşturalım!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              const Text('Gidecek kişi sayısı:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (travelInformation.numberOfPeople > 1) {
                        ref.read(travelInformationProvider.notifier)
                            .updateNumberOfPeople(travelInformation.numberOfPeople - 1);
                      }
                    },
                  ),
                  Text('${travelInformation.numberOfPeople}', style: const TextStyle(fontSize: 24)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      ref.read(travelInformationProvider.notifier)
                          .updateNumberOfPeople(travelInformation.numberOfPeople + 1);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Devam',
                onPressed: () {
                  ref.read(bottomNavigationBarProvider.notifier).changePage(4);
                }, color: Colors.blue,
                
              ),
            ],
          ),
        );
  }
}