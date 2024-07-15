import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/travel_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/travel_plan_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class PlanChoosingPlacesPage extends ConsumerWidget {
  final List<String> places = ['Sahiller', 'Tarihi yerler', 'Hayvanat bahçesi', 'Müzeler', 'Sanat'];

  PlanChoosingPlacesPage({super.key});

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
              const Text(textAlign: TextAlign.center,'En çok gezmeyi tercih ettiğiniz yerler:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ...places.map((place) => CheckboxListTile(
                title: Text(place),
                value: travelInformation.placesToVisit.contains(place),
                onChanged: (bool? value) {
                  List<String> newPlaces = List.from(travelInformation.placesToVisit);
                  if (value == true) {
                    newPlaces.add(place);
                  } else {
                    newPlaces.remove(place);
                  }
                  ref.read(travelinformationProvider.notifier).updatePlacesToVisit(newPlaces);
                },
              )),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Devam',
                onPressed: () {
                  ref.read(bottomNavigationBarProvider.notifier).changePage(5);
                }, color: Colors.blue,
              ),
            ],
          ),
        );
  }
}