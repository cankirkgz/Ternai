import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/day_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/travel_day_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class DayChoosingPlansPage extends ConsumerWidget {
  DayChoosingPlansPage({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Tatilde geçireceğiniz gün sayısını hesaplayalım!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tatilinizde yapmak istediğiniz her şeyi anlatın:',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _controller,
              maxLines: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText:
                    'Örneğin, kahvaltınızı kaçta yapmayı planlıyorsunuz? Nasıl bir yerde yemek yemek istiyorsunuz? Hangi yerleri gezmek istiyorsunuz? Eğlence için neleri tercih ediyorsunuz?',
              ),
              onChanged: (value) {
                ref
                    .read(travelInformationProvider.notifier)
                    .updateTravelPlanDetails(value);
              },
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Devam',
            onPressed: () {
              if (_controller.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen tatil planınızı anlatın!'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                ref.read(bottomNavigationBarProvider.notifier).changePage(4);
              }
            },
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}