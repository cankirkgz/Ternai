import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/budget_result_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/travel_budget_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class BudgetPlanPage extends ConsumerWidget {
  // Bu değerler normalde önceki sayfalardan alınacak

  final model = GenerativeModel(
    model: "gemini-pro",
    apiKey: "AIzaSyAtPwLEa-Hlw7Mb1NChsjLySrZx32s_bsI",
  );

  BudgetPlanPage({super.key});

  Future<String> _calculateBudget(TravelInformation tatilVerileri) async {
    final content = [
      Content.text(
          '''Sen gelişmiş bir yapay zekasın ve tatil bütçesi planlamada uzmanlaşmışsın. Bir kullanıcı tatil planlamak istiyor ve tahmini bir bütçeye ihtiyaç duyuyor. Lütfen kullanıcının sağladığı aşağıdaki bilgileri dikkate al:

          - **Gidilecek Ülke**: ${tatilVerileri.country}
          - **Kalınacak Gün Sayısı**: ${tatilVerileri.numberOfDays}
          - **Kişi Sayısı**: ${tatilVerileri.numberOfPeople}
          - **Çocuk Var mı?**: ${tatilVerileri.kid}
          - **Detaylı Tatil Planı**:
            - Kahvaltı planları: ${tatilVerileri.breakfastPlan}
            - Yemek tercihleri: ${tatilVerileri.foodPreferences}
            - Gezilecek yerler: ${tatilVerileri.placesToVisit}
            - Eğlence tercihleri: ${tatilVerileri.entertainmentPreferences}
            - Alışveriş planları: ${tatilVerileri.shoppingPlans}
            - Özel istekler: ${tatilVerileri.specialRequests}

          Bu bilgileri dikkate alarak, bu tatil için en uygun bütçeyi hesapla. Konaklama, yemek, ulaşım, aktiviteler ve diğer ilgili masrafları içerecek şekilde tüm gerekli harcamaların detaylı bir dökümünü sağla.''')
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
              'Mükemmel bir tatil planı oluşturalım!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 20),
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                    decoration:
                        BoxDecoration(color: Colors.blue.withOpacity(0.65)),
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
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.65)),
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Kalacak gün'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(travelInformation.numberOfDays.toString()),
                      ),
                    ]),
                TableRow(
                    decoration:
                        BoxDecoration(color: Colors.blue.withOpacity(0.65)),
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Kişi sayısı'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text(travelInformation.numberOfPeople.toString()),
                      ),
                    ]),
                TableRow(
                    decoration:
                        BoxDecoration(color: Colors.blue.withOpacity(0.65)),
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
                final budget = await _calculateBudget(travelInformation);
                ref.read(budgetProvider.notifier).state = budget;
                ref.read(bottomNavigationBarProvider.notifier).changePage(5);
              },
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
