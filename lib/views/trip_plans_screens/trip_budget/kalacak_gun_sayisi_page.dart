import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
class KalacakGunSayisiPage extends ConsumerWidget {
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
              const Text('Kalacak gün sayısı:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (tatilVerileri.gunSayisi > 1) {
                        ref.read(tatilVerileriProvider.notifier)
                            .updateGunSayisi(tatilVerileri.gunSayisi - 1);
                      }
                    },
                  ),
                  Text('${tatilVerileri.gunSayisi}', style: const TextStyle(fontSize: 24)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      ref.read(tatilVerileriProvider.notifier)
                          .updateGunSayisi(tatilVerileri.gunSayisi + 1);
                    },
                  ),
                ],
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