import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/day_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/travel_day_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class DayChoosingPlacesPage extends ConsumerWidget {
  final List<String> places = ['Sahiller', 'Tarihi yerler', 'Hayvanat bahçesi', 'Müzeler', 'Sanat'];

  DayChoosingPlacesPage({super.key});

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
                  ref.read(bottomNavigationBarProvider.notifier).changePage(4);
                }, color: Colors.blue,
              ),
            ],
          ),
        );
  }
}