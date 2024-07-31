import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/travel_budget_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class BudgetChoosingPlansPage extends ConsumerWidget {
  BudgetChoosingPlansPage({super.key});

  final TextEditingController breakfastPlanController = TextEditingController();
  final TextEditingController foodPreferencesController = TextEditingController();
  final TextEditingController placesToVisitController = TextEditingController();
  final TextEditingController entertainmentPreferencesController = TextEditingController();
  final TextEditingController shoppingPlansController = TextEditingController();
  final TextEditingController specialRequestsController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 90.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Mükemmel bir tatil için bütçe oluşturalım!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                'Tatilinizde yapmak istediğiniz her şeyi anlatın:',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 20),
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
                      controller: breakfastPlanController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            'Örneğin, kahvaltınızı kaçta yapmayı planlıyorsunuz?',
                      ),
                      onChanged: (value) {
                        ref
                            .read(travelInformationProvider.notifier)
                            .updateBreakfastPlan(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Yemek tercihleri:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: foodPreferencesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Nasıl bir yerde yemek yemek istiyorsunuz?',
                      ),
                      onChanged: (value) {
                        ref
                            .read(travelInformationProvider.notifier)
                            .updateFoodPreferences(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Gezilecek yerler:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: placesToVisitController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Hangi yerleri gezmek istiyorsunuz?',
                      ),
                      onChanged: (value) {
                        ref
                            .read(travelInformationProvider.notifier)
                            .updatePlacesToVisit(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Eğlence tercihleri:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: entertainmentPreferencesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Eğlence için neleri tercih ediyorsunuz?',
                      ),
                      onChanged: (value) {
                        ref
                            .read(travelInformationProvider.notifier)
                            .updateEntertainmentPreferences(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Alışveriş planları:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: shoppingPlansController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            'Alışveriş yapmayı planlıyor musunuz? Neler almak istiyorsunuz?',
                      ),
                      onChanged: (value) {
                        ref
                            .read(travelInformationProvider.notifier)
                            .updateShoppingPlans(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Özel istekler:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: specialRequestsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            'Özel istekleriniz nelerdir? (Örneğin, romantik akşam yemekleri)',
                      ),
                      onChanged: (value) {
                        ref
                            .read(travelInformationProvider.notifier)
                            .updateSpecialRequests(value);
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
          
                  if (breakfastPlanController.text.isEmpty &&
                      foodPreferencesController.text.isEmpty &&
                      placesToVisitController.text.isEmpty &&
                      entertainmentPreferencesController.text.isEmpty &&
                      shoppingPlansController.text.isEmpty &&
                      specialRequestsController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Lütfen tatil planı alanlarından en az birini doldurun!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    travelInfo.updateBreakfastPlan(breakfastPlanController.text);
                    travelInfo.updateFoodPreferences(foodPreferencesController.text);
                    travelInfo.updatePlacesToVisit(placesToVisitController.text);
                    travelInfo.updateEntertainmentPreferences(entertainmentPreferencesController.text);
                    travelInfo.updateShoppingPlans(shoppingPlansController.text);
                    travelInfo.updateSpecialRequests(specialRequestsController.text);
          
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Ne kadar çok detay verirseniz, o kadar sağlam bir bütçe tahmini alabilirsiniz!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    ref.read(bottomNavigationBarProvider.notifier).changePage(4);
                  }
                },
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}