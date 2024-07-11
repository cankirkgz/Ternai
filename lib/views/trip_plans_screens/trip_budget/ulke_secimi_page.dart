import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';

class UlkeSecimiPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tatilVerileri = ref.watch(tatilVerileriProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/sea_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Mükemmel bir tatil için bütçe oluşturalım!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text('Gideceğiniz ülke:'),
              DropdownButton<String>(
                value: tatilVerileri.ulke.isEmpty ? null : tatilVerileri.ulke,
                hint: const Text('Ülke seçin'),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    ref.read(tatilVerileriProvider.notifier).updateUlke(newValue);
                  }
                },
                items: <String>['Hollanda', 'Fransa', 'İtalya', 'İspanya']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Devam'),
                onPressed: () {
                  // Navigate to next page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}