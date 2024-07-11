import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/trip_budget_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class GezilecekYerlerPage extends ConsumerWidget {
  final List<String> yerler = ['Sahiller', 'Tarihi yerler', 'Hayvanat bahçesi', 'Müzeler', 'Sanat'];

  GezilecekYerlerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tatilVerileri = ref.watch(tatilVerileriProvider);

    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Mükemmel bir tatil için bütçe oluşturalım!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              const Text(textAlign: TextAlign.center,'En çok gezmeyi tercih ettiğiniz yerler:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ...yerler.map((yer) => CheckboxListTile(
                title: Text(yer),
                value: tatilVerileri.gezilecekYerler.contains(yer),
                onChanged: (bool? value) {
                  List<String> yeniYerler = List.from(tatilVerileri.gezilecekYerler);
                  if (value == true) {
                    yeniYerler.add(yer);
                  } else {
                    yeniYerler.remove(yer);
                  }
                  ref.read(tatilVerileriProvider.notifier).updateGezilecekYerler(yeniYerler);
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