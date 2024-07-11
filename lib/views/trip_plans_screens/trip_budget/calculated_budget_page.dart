import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';

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
                'Mükemmel bir tatil için ayırmanız gereken bütçe',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Gidiş-Dönüş Uçak Bileti'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('₺${ucakBileti.toStringAsFixed(2)}'),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Konaklama'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('₺${konaklama.toStringAsFixed(2)}'),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Yemek'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('₺${yemek.toStringAsFixed(2)}'),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Ulaşım'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('₺${ulasim.toStringAsFixed(2)}'),
                    ),
                  ]),
                  TableRow(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Aktiviteler'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('₺${aktiviteler.toStringAsFixed(2)}'),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Toplam bütçe: ₺${toplamButce.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}