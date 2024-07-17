import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class ButcePage extends ConsumerWidget {
  // Bu değerler normalde hesaplanacak
  final double ucakBileti = 1500.0;
  final double konaklama = 2250.0;
  final double yemek = 1500.0;
  final double ulasim = 450.0;
  final double aktiviteler = 900.0;

  const ButcePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final toplamButce = ref.watch(butceProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Mükemmel bir tatil için ayırmanız gereken bütçe',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: const Text('Gidiş-Dönüş Uçak Bileti'),
                    trailing: Text('₺${ucakBileti.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: const Text('Konaklama'),
                    trailing: Text('₺${konaklama.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: const Text('Yemek'),
                    trailing: Text('₺${yemek.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: const Text('Ulaşım'),
                    trailing: Text('₺${ulasim.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: const Text('Aktiviteler'),
                    trailing: Text('₺${aktiviteler.toStringAsFixed(2)}'),
                  ),
                ],
                        ),
            ),
              ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Toplam bütçe:\n₺${toplamButce.toStringAsFixed(2)}',
            onPressed: () {},
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}