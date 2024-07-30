import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/travel_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/plan_result_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/travel_plan_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class PlanPlanPage extends ConsumerStatefulWidget {
  const PlanPlanPage({super.key});

  @override
  _PlanPlanPageState createState() => _PlanPlanPageState();
}

class _PlanPlanPageState extends ConsumerState<PlanPlanPage> {
  bool isLoading = false;

  final model = GenerativeModel(
    model: "gemini-pro",
    apiKey: "AIzaSyAtPwLEa-Hlw7Mb1NChsjLySrZx32s_bsI",
  );

  Future<String> _generateDetailedTravelPlan(
      TravelInformation travelInfo) async {
    final content = [
      Content.text(
          '''Sen gelişmiş bir yapay zekasın ve tatil planlamada uzmanlaşmışsın. Bir kullanıcı tatil planlamak istiyor ve aşağıdaki bilgileri sağladı. Bu bilgiler ışığında, kullanıcının isteklerine göre her gün için detaylı bir tatil planı oluştur:

          - **Hangi ülkeden gidilecek**: Türkiye
          - **Gidilecek Ülke**: ${travelInfo.toCountry}
          - **Tatil Bütçesi**: ${travelInfo.budget} ${travelInfo.currency}
          - **Kalınacak Gün Sayısı**: ${travelInfo.numberOfDays}
          - **Kişi Sayısı**: ${travelInfo.numberOfPeople}
          - **Çocuk Var mı?**: ${travelInfo.kid ? 'Evet' : 'Hayır'}
          - **Detaylı Tatil Planı**:
            - Kahvaltı planları: ${travelInfo.breakfastPlan}
            - Yemek tercihleri: ${travelInfo.foodPreferences}
            - Gezilecek yerler: ${travelInfo.placesToVisit}
            - Eğlence tercihleri: ${travelInfo.entertainmentPreferences}
            - Alışveriş planları: ${travelInfo.shoppingPlans}
            - Özel istekler: ${travelInfo.specialRequests}

              Bu bilgileri dikkate alarak, kullanıcının isteğine göre her gün için detaylı bir tatil planı oluştur. Her gün için aşağıdaki bilgileri içerecek şekilde detaylı bir program hazırla ve her bir kalemin ücretini hesapla ve yaz:

              1. **Kahvaltı**: Kullanıcının kahvaltı planlarına uygun olarak önerilerde bulun ve kahvaltının maliyetini yaz.
              2. **Gezilecek Yerler**: Kullanıcının gezmek istediği yerleri ve önerilen diğer turistik yerleri içeren bir ziyaret planı hazırla ve giriş ücretlerini yaz.
              3. **Yemek**: Kullanıcının yemek tercihleri doğrultusunda önerilen restoranlar veya yemek mekanlarını listele ve yemek maliyetlerini yaz.
              4. **Eğlence**: Kullanıcının eğlence tercihleri doğrultusunda önerilen aktiviteler ve etkinlikleri listele ve bilet/etkinlik ücretlerini yaz.
              5. **Alışveriş**: Alışveriş planlarına uygun olarak önerilen alışveriş merkezleri veya mağazaları listele ve tahmini alışveriş maliyetini yaz.
              6. **Özel İstekler**: Kullanıcının özel isteklerini içeren planlar ve önerileri listele ve bu isteklerin maliyetini yaz.

              Ayrıca, her günün sonunda kullanıcının rahatlayabileceği ve dinlenebileceği yerler hakkında bilgi ver ve bu yerlerin maliyetini hesapla.

              Eğer kullanıcının istekleri belirtilen bütçeyi aşarsa, kullanıcının bütçesini aşan bir plan oluşturulamayacağı konusunda uyar ve bütçeyi aşmayan alternatif önerilerde bulun.

              Örnek olarak:
              - **1. Gün**:
                - **Kahvaltı**: Otel restoranında kahvaltı (20 EUR).
                - **Gezilecek Yerler**: Sabah Ayasofya Müzesi'ni ziyaret (15 EUR), öğleden sonra Topkapı Sarayı (20 EUR).
                - **Yemek**: Öğle yemeği için Sultanahmet Köftecisi (25 EUR).
                - **Eğlence**: Akşamüstü Boğaz turu (30 EUR).
                - **Alışveriş**: Grand Bazaar'da alışveriş (50 EUR).
                - **Özel İstekler**: Akşam romantik bir akşam yemeği için önerilen restoran (40 EUR).
                - **Dinlenme**: Otelde spa ve dinlenme (35 EUR).

              Her gün için benzer detaylı bir program oluştur ve toplam bütçeyi göz önünde bulundurarak tüm harcamaları hesapla. Her bir kategori için önerilen harcamaları detaylandır ve toplam bütçe içinde kalmasını sağla. Eğer bütçe aşılırsa, kullanıcıyı uyar ve bütçe dahilinde kalacak alternatifler sun.
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
                      decoration:
                          BoxDecoration(color: Colors.blue.withOpacity(0.65)),
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
                          BoxDecoration(color: Colors.white.withOpacity(0.65)),
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
                            child:
                                Text(travelInformation.kid ? 'Evet' : 'Hayır'),
                          ),
                        ]),
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
                          BoxDecoration(color: Colors.white.withOpacity(0.65)),
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
                          BoxDecoration(color: Colors.blue.withOpacity(0.65)),
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
                          BoxDecoration(color: Colors.white.withOpacity(0.65)),
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
                          BoxDecoration(color: Colors.blue.withOpacity(0.65)),
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
                          BoxDecoration(color: Colors.white.withOpacity(0.65)),
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
                          BoxDecoration(color: Colors.blue.withOpacity(0.65)),
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
                  final travelPlan =
                      await _generateDetailedTravelPlan(travelInformation);
                  ref.read(travelPlanProvider.notifier).state = travelPlan;
                  setState(() {
                    isLoading = false;
                  });
                  ref.read(bottomNavigationBarProvider.notifier).changePage(6);
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
