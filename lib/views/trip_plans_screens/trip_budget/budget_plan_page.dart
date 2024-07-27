import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/budget_result_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/travel_budget_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class BudgetPlanPage extends ConsumerStatefulWidget {
  const BudgetPlanPage({super.key});

  @override
  _BudgetPlanPageState createState() => _BudgetPlanPageState();
}

class _BudgetPlanPageState extends ConsumerState<BudgetPlanPage> {
  bool isLoading = false;

  final model = GenerativeModel(
    model: "gemini-pro",
    apiKey: "AIzaSyAtPwLEa-Hlw7Mb1NChsjLySrZx32s_bsI",
  );

  Future<String> _calculateBudget(TravelInformation travelInformation) async {
    final content = [
      Content.text(
          '''Sen gelişmiş bir yapay zekasın ve tatil bütçesi planlamada uzmanlaşmışsın. Bir kullanıcı tatil planlamak istiyor ve tahmini bir bütçeye ihtiyaç duyuyor. Lütfen kullanıcının sağladığı aşağıdaki bilgileri dikkate al:
        - **Hangi ülkeden gidilecek**: Türkiye
        - **Gidilecek Ülke**: ${travelInformation.country}
        - **Kalınacak Gün Sayısı**: ${travelInformation.numberOfDays}
        - **Kişi Sayısı**: ${travelInformation.numberOfPeople}
        - **Çocuk Var mı?**: ${travelInformation.kid}
        - **Detaylı Tatil Planı**:
          - Kahvaltı planları: ${travelInformation.breakfastPlan}
          - Yemek tercihleri: ${travelInformation.foodPreferences}
          - Gezilecek yerler: ${travelInformation.placesToVisit}
          - Eğlence tercihleri: ${travelInformation.entertainmentPreferences}
          - Alışveriş planları: ${travelInformation.shoppingPlans}
          - Özel istekler: ${travelInformation.specialRequests}
        
        Bu bilgileri dikkate alarak, bu tatil için en uygun bütçeyi hesapla. 
        - **Konaklama, yemek, ulaşım, aktiviteler ve diğer ilgili masrafları içerecek şekilde tüm gerekli harcamaların detaylı bir dökümünü sağla.**
        - **Gidilen ülkede ve gidilecek ülkede vize gereksinimleri varsa, bunları da bütçeye ekle.**
        - **İki ülke arasındaki uçak bileti maliyetlerini hesapla ve bütçeye dahil et.**
        - **Vize ve diğer ek ücretleri belirlerken, ülkelerin vize politikalarını ve diğer olası masrafları göz önünde bulundur.**

        Sonuçları aşağıdaki kategoriler altında organize et:
        1. **Konaklama**: Otel, pansiyon, kiralık ev vb. konaklama masrafları.
        2. **Ulaşım**: Uçak, tren, otobüs biletleri, taksi, araba kiralama vb. ulaşım masrafları.
        3. **Yemek**: Restoran, kafe, market alışverişi vb. yemek masrafları.
        4. **Eğlence**: Müzeler, konserler, turlar, etkinlikler vb. eğlence masrafları.
        5. **Alışveriş**: Hediyelik eşyalar, hatıralar, kıyafetler vb. alışveriş masrafları.
        6. **Diğer Masraflar**: Sigorta, bahşişler, döviz bozdurma ücretleri, beklenmedik harcamalar vb. diğer masraflar.
        7. **Vize ve Ek Ücretler**: Vize ücretleri ve diğer ek masraflar.
        8. **Uçak Biletleri**: İki ülke arasındaki uçak bileti maliyetleri.

        Bu kategoriler altında detaylı bir bütçe hesapla ve kullanıcıya sun.
        ''')
    ];
    final response = await model.generateContent(content);
    return response.text ?? 'Bir hata oluştu.';
  }

  @override
  Widget build(BuildContext context) {
    final travelInformation = ref.watch(travelInformationProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
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
                          child:
                              Text(travelInformation.numberOfDays.toString()),
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
                          BoxDecoration(color: Colors.white.withOpacity(0.65)),
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
                  if (travelInformation.kid) ...[
                    TableRow(
                        decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.65)),
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Çocuk Bilgileri'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: travelInformation.children.map((child) {
                                return Text(
                                    'Yaş: ${child.age}, Cinsiyet: ${child.gender}');
                              }).toList(),
                            ),
                          ),
                        ]),
                  ],
                  TableRow(
                      decoration:
                          BoxDecoration(color: Colors.blue.withOpacity(0.65)),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Kahvaltı planları'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(travelInformation.breakfastPlan),
                        ),
                      ]),
                  TableRow(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.65)),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Yemek tercihleri'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(travelInformation.foodPreferences),
                        ),
                      ]),
                  TableRow(
                      decoration:
                          BoxDecoration(color: Colors.blue.withOpacity(0.65)),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Gezilecek yerler'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(travelInformation.placesToVisit),
                        ),
                      ]),
                  TableRow(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.65)),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Eğlence tercihleri'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text(travelInformation.entertainmentPreferences),
                        ),
                      ]),
                  TableRow(
                      decoration:
                          BoxDecoration(color: Colors.blue.withOpacity(0.65)),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Alışveriş planları'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(travelInformation.shoppingPlans),
                        ),
                      ]),
                  TableRow(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.65)),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Özel istekler'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(travelInformation.specialRequests),
                        ),
                      ]),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Sonraki',
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final budget = await _calculateBudget(travelInformation);
                  ref.read(budgetProvider.notifier).state = budget;
                  setState(() {
                    isLoading = false;
                  });
                  ref.read(bottomNavigationBarProvider.notifier).changePage(5);
                },
                color: AppColors.primaryColor,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Sonraki',
                        style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
