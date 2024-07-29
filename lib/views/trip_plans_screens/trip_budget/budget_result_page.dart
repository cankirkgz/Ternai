import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/models/budget_plan_model.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/viewmodels/plan_viewmodel.dart';
import 'package:travelguide/views/home_screens/new_trip_screen.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:uuid/uuid.dart';

class BudgetResultPage extends ConsumerWidget {

  final BudgetPlanModel? plan;

  const BudgetResultPage({super.key, this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planViewModel = ref.watch(planViewModelProvider);
    final travelInformation = ref.watch(travelInformationProvider);
    final authViewModel = ref.watch(authViewModelProvider);
    final uuid = Uuid();

    final budget = plan?.result ?? ref.watch(budgetProvider)!;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 0),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Önerilen Bütçe',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          MarkdownBody(
                            data: budget,
                            styleSheet: MarkdownStyleSheet(
                              h1: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                              h2: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              p: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              listBullet: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (plan == null) CustomButton(
                    text: 'Kaydet',
                    onPressed: () async {
                      final BudgetPlanModel plan = BudgetPlanModel(
                        id: uuid.v4(),
                        fromCountry: authViewModel.user!.country!.name,
                        toCountry: travelInformation.country,
                        numberOfDays: travelInformation.numberOfDays,
                        numberOfPeople: travelInformation.numberOfPeople,
                        kids: travelInformation.children,
                        breakfastPlan: travelInformation.breakfastPlan,
                        mealPlan: travelInformation.foodPreferences,
                        entertainmentPreferences:
                            travelInformation.placesToVisit,
                        shoppingPlans: travelInformation.shoppingPlans,
                        specialRequests: travelInformation.specialRequests,
                        result: budget,
                      );
                      await planViewModel.createPlan(
                          authViewModel.user!.userId, plan.toJson());

                      // Başarı mesajı göster
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Plan başarıyla kaydedildi!'),
                        ),
                      );
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NewTripScreen()));
                    },
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final planViewModelProvider = ChangeNotifierProvider((ref) => PlanViewModel());
final authViewModelProvider = ChangeNotifierProvider((ref) => AuthViewModel());

final budgetProvider = StateProvider<String>((ref) => '');
