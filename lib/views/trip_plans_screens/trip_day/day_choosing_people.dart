import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/day_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/travel_day_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class DayChoosingPeoplePage extends ConsumerWidget {
  const DayChoosingPeoplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelInformation = ref.watch(travelinformationProvider);

    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Tatilde kalacağınız gün sayısını belirleyelim!',
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
                        ref.read(travelinformationProvider.notifier)
                            .updateNumberOfPeople(travelInformation.numberOfPeople - 1);
                      }
                    },
                  ),
                  Text('${travelInformation.numberOfPeople}', style: const TextStyle(fontSize: 24)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      ref.read(travelinformationProvider.notifier)
                          .updateNumberOfPeople(travelInformation.numberOfPeople + 1);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Devam',
                onPressed: () {
                  ref.read(bottomNavigationBarProvider.notifier).changePage(2);
                }, color: Colors.blue,
                
              ),
            ],
          ),
        );
  }
}