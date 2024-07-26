import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/day_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/day_result_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/travel_day_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class DayPlanPage extends ConsumerStatefulWidget {
  const DayPlanPage({super.key});

  @override
  _DayPlanPageState createState() => _DayPlanPageState();
}

class _DayPlanPageState extends ConsumerState<DayPlanPage> {
  bool isLoading = false;

  final model = GenerativeModel(
    model: "gemini-pro",
    apiKey: "AIzaSyAtPwLEa-Hlw7Mb1NChsjLySrZx32s_bsI",
  );

  Future<String> _calculateBudget(TravelInformation tatilVerileri) async {
    final content = [
      Content.text(
          '''Sen gelişmiş bir yapay zekasın ve tatil planlamada uzmanlaşmışsın. Bir kullanıcı tatil planlamak istiyor ve aşağıdaki bilgileri sağladı. Bu bilgiler ışığında, kullanıcının belirttiği bütçeyle kaç gün tatil yapabileceğini hesapla:

- **Hangi ülkeden gidilecek**: Türkiye
- **Gidilecek Ülke**: ${tatilVerileri.toCountry}
- **Tatil Bütçesi**: ${tatilVerileri.budget} ${tatilVerileri.currency}
- **Kişi Sayısı**: ${tatilVerileri.numberOfPeople}
- **Çocuk Var mı?**: ${tatilVerileri.kid ? 'Evet' : 'Hayır'}
- **Detaylı Tatil Planı**:
  - Kahvaltı planları: ${tatilVerileri.breakfastPlan}
  - Yemek tercihleri: ${tatilVerileri.foodPreferences}
  - Gezilecek yerler: ${tatilVerileri.placesToVisit}
  - Eğlence tercihleri: ${tatilVerileri.entertainmentPreferences}
  - Alışveriş planları: ${tatilVerileri.shoppingPlans}
  - Özel istekler: ${tatilVerileri.specialRequests}

Bu bilgileri dikkate alarak, kullanıcının belirttiği bütçeyle kaç gün tatil yapabileceğini hesapla. Gerekli tüm harcamaları (konaklama, yemek, ulaşım, aktiviteler, vb.) dikkate alarak bir hesaplama yap ve kullanıcıya kaç gün kalabileceğini bildir. Eğer bütçe aşılırsa, kullanıcının bütçesini aşan bir plan oluşturulamayacağı konusunda uyar ve bütçeyi aşmayan alternatif önerilerde bulun.

Örnek olarak:
- **Toplam Harcama Kalemleri**:
  - **Konaklama**: Otel konaklama (100 EUR/gün)
  - **Yemek**: Günlük yemek harcamaları (50 EUR/gün)
  - **Ulaşım**: Taksi ve diğer ulaşım masrafları (20 EUR/gün)
  - **Eğlence**: Günlük eğlence aktiviteleri (30 EUR/gün)
  - **Alışveriş**: Günlük alışveriş harcamaları (20 EUR/gün)
  - **Diğer Masraflar**: Sigorta, bahşişler, vb. (10 EUR/gün)
  - **Uçak Biletleri**: Gidiş-dönüş uçak bileti (200 EUR)
  - **Vize ve Ek Ücretler**: Vize ücreti (60 EUR)

Bu örneği kullanarak, kullanıcıya belirttiği bütçeyle kaç gün tatil yapabileceğini hesapla ve bildir.
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
                'Tatilde geçireceğiniz gün sayısını hesaplayalım!',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor),
              ),
              const SizedBox(height: 20),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.65)),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Ülke'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(travelInformation.toCountry),
                        ),
                      ]),
                  TableRow(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.65)),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Bütçe'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '${travelInformation.budget} ${travelInformation.currency}'),
                        ),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.65)),
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
                      if (travelInformation.kid) ...[
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
                    TableRow(
                      decoration:
                        BoxDecoration(color: Colors.orange.withOpacity(0.65)),
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
                              return Text('Yaş: ${child.kidAge}, Cinsiyet: ${child.kidGender}');
                            }).toList(),
                          ),
                        ),
                      ]
                    ),
                  ],
                  TableRow(
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.65)),
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
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.65)),
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
                          child: Text(travelInformation.entertainmentPreferences),
                        ),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.65)),
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
                  final day = await _calculateBudget(travelInformation);
                  ref.read(dayProvider.notifier).state = day;
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
                    : const Text(
                        'Sonraki',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
