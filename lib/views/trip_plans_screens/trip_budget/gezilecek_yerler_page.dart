import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';

class GezilecekYerlerPage extends ConsumerWidget {
  final List<String> yerler = ['Sahiller', 'Tarihi yerler', 'Hayvanat bahçesi', 'Müzeler', 'Sanat'];

  GezilecekYerlerPage({super.key});

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
              const Text('En çok gezmeyi tercih ettiğiniz yerler:'),
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
              ElevatedButton(
                child: const Text('Oluştur'),
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