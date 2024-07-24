import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/day_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/travel_day_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class DayChoosingPlansPage extends ConsumerWidget {
  DayChoosingPlansPage({super.key});

  final TextEditingController kahvaltiController = TextEditingController();
  final TextEditingController yemekTercihleriController =
      TextEditingController();
  final TextEditingController gezilecekYerlerController =
      TextEditingController();
  final TextEditingController eglenceTercihleriController =
      TextEditingController();
  final TextEditingController alisverisPlanlariController =
      TextEditingController();
  final TextEditingController ozelIsteklerController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Tatilde geçireceğiniz gün sayısını hesaplayalım!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tatilinizde yapmak istediğiniz her şeyi anlatın:',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kahvaltı planları:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: kahvaltiController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText:
                          'Örneğin, kahvaltınızı kaçta yapmayı planlıyorsunuz?',
                    ),
                    onChanged: (value) {
                      ref
                          .read(travelInformationProvider.notifier)
                          .updateKahvaltiPlani(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Yemek tercihleri:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: yemekTercihleriController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nasıl bir yerde yemek yemek istiyorsunuz?',
                    ),
                    onChanged: (value) {
                      ref
                          .read(travelInformationProvider.notifier)
                          .updateYemekTercihleri(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Gezilecek yerler:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: gezilecekYerlerController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Hangi yerleri gezmek istiyorsunuz?',
                    ),
                    onChanged: (value) {
                      ref
                          .read(travelInformationProvider.notifier)
                          .updateGezilecekYerler(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Eğlence tercihleri:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: eglenceTercihleriController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Eğlence için neleri tercih ediyorsunuz?',
                    ),
                    onChanged: (value) {
                      ref
                          .read(travelInformationProvider.notifier)
                          .updateEglenceTercihleri(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Alışveriş planları:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: alisverisPlanlariController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText:
                          'Alışveriş yapmayı planlıyor musunuz? Neler almak istiyorsunuz?',
                    ),
                    onChanged: (value) {
                      ref
                          .read(travelInformationProvider.notifier)
                          .updateAlisverisPlanlari(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Özel istekler:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: ozelIsteklerController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText:
                          'Özel istekleriniz nelerdir? (Örneğin, romantik akşam yemekleri)',
                    ),
                    onChanged: (value) {
                      ref
                          .read(travelInformationProvider.notifier)
                          .updateOzelIstekler(value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Devam',
              onPressed: () {
                final travelInfo = ref.read(travelInformationProvider.notifier);

                if (kahvaltiController.text.isEmpty &&
                    yemekTercihleriController.text.isEmpty &&
                    gezilecekYerlerController.text.isEmpty &&
                    eglenceTercihleriController.text.isEmpty &&
                    alisverisPlanlariController.text.isEmpty &&
                    ozelIsteklerController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Lütfen tatil planı alanlarından en az birini doldurun!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  travelInfo.updateKahvaltiPlani(kahvaltiController.text);
                  travelInfo
                      .updateYemekTercihleri(yemekTercihleriController.text);
                  travelInfo
                      .updateGezilecekYerler(gezilecekYerlerController.text);
                  travelInfo.updateEglenceTercihleri(
                      eglenceTercihleriController.text);
                  travelInfo.updateAlisverisPlanlari(
                      alisverisPlanlariController.text);
                  travelInfo.updateOzelIstekler(ozelIsteklerController.text);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Ne kadar çok detay verirseniz, o kadar sağlam bir gün tahmini alabilirsiniz!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  ref.read(bottomNavigationBarProvider.notifier).changePage(4);
                }
              },
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
