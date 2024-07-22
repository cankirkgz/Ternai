import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:travelguide/viewmodels/day_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/day_result_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/travel_day_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class DayPlanPage extends ConsumerWidget {


  final model = GenerativeModel(
    model: "gemini-pro",
    apiKey: "AIzaSyAtPwLEa-Hlw7Mb1NChsjLySrZx32s_bsI",
  );

  DayPlanPage({super.key});

  Future<String> _calculateBudget(TravelInformation tatilVerileri) async {
    final content = [
      Content.text(
          'Ben Türkiyeden ${tatilVerileri.country} ülkesine tatile gitmek istiyorum. Bütçem : ${tatilVerileri.budget} TL. ${tatilVerileri.numberOfPeople} kişiyle seyahat etmeyi planlıyorum. Tatilde şunları yapmayı planlıyorum: ${tatilVerileri.travelPlanDetails}. Eğer kullanıcı özel olarak bir müze ismi belirtirse o müzenin giriş fiyatını da yaz. Bunlara göre tatilde kaç gün geçirebilirim?')
    ];
    final response = await model.generateContent(content);
    return response.text ?? 'Bir hata oluştu.';
  }

  @override
  Widget build(BuildContext context, ref) {
    final travelInformation = ref.watch(travelInformationProvider);

    return Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tatilde geçireceğiniz gün sayısını hesaplayalım!',
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
                        child: Text(travelInformation.country),
                      ),
                    ]),
                    TableRow(
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.65)),
                        children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Bütçe'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(travelInformation.budget.toString()),
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
                        child: Text(travelInformation.numberOfPeople.toString()),
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
                        child: Text(travelInformation.kid ? 'Evet' : 'Hayır'),
                      ),
                    ]),
                  ],
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Sonraki',
                  onPressed: () async {
                    final day = await _calculateBudget(travelInformation);
                    ref.read(dayProvider.notifier).state = day;
                    ref.read(bottomNavigationBarProvider.notifier).changePage(5);
                  }, color: Colors.blue,
                ),
              ],
            ),
          ),
        );
  }
}