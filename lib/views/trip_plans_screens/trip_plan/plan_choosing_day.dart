import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/travel_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/travel_plan_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class PlanChoosingDayPage extends ConsumerWidget {
  const PlanChoosingDayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelInformation = ref.watch(travelInformationProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Mükemmel bir tatil planı oluşturalım!',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
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
                  if (travelInformation.numberOfDays > 1) {
                    ref
                        .read(travelInformationProvider.notifier)
                        .updateNumberOfDays(travelInformation.numberOfDays - 1);
                  }
                },
              ),
              Text('${travelInformation.numberOfDays}',
                  style: const TextStyle(fontSize: 24)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  ref
                      .read(travelInformationProvider.notifier)
                      .updateNumberOfDays(travelInformation.numberOfDays + 1);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Devam',
            onPressed: () {
              if(travelInformation.numberOfDays == 0)
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Lütfen gün sayısı seçin!"),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  )
                );
              }else{
                ref.read(bottomNavigationBarProvider.notifier).changePage(3);
              }
            },
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
