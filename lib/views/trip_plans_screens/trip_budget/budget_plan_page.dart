import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/travel_budget_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class BudgetPlanPage extends ConsumerWidget {
  // Bu değerler normalde önceki sayfalardan alınacak
  final String ulke = 'Hollanda';
  final int kalacakGun = 15;
  final int kisiSayisi = 2;
  final List<String> gezilecekYerler = ['Müzeler'];

  BudgetPlanPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final tatilVerileri = ref.watch(tatilVerileriProvider);

    return Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Mükemmel bir tatil planı oluşturalım!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.65)),
                        children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Ülke'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(tatilVerileri.ulke),
                      ),
                    ]),
                    TableRow(
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.65)),
                        children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Kalacak gün'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(tatilVerileri.gunSayisi.toString()),
                      ),
                    ]),
                    TableRow(
                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.65)),
                        children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Kişi sayısı'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(tatilVerileri.kisiSayisi.toString()),
                      ),
                    ]),
                    TableRow(
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.65)),
                        children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Gezilecek yerler'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(tatilVerileri.gezilecekYerler.join(', ')),
                      ),
                    ]),
                    TableRow(
                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.65)),
                        children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Çocuk var mı'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(tatilVerileri.cocukVarMi ? 'Evet' : 'Hayır'),
                      ),
                    ]),
                  ],
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Sonraki',
                  onPressed: () {
                    ref.read(bottomNavigationBarProvider.notifier).changePage(5);
                  }, color: Colors.blue,
                ),
              ],
            ),
          ),
        );
  }
}