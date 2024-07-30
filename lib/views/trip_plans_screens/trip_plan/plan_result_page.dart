// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/models/plan_plan_model.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/viewmodels/plan_viewmodel.dart';
import 'package:travelguide/viewmodels/travel_plan_model.dart';
import 'package:travelguide/views/home_screens/new_trip_screen.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:uuid/uuid.dart';

class PlanResultPage extends ConsumerWidget {
  const PlanResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planViewModel = ref.watch(planViewModelProvider);
    final travelInformation = ref.watch(travelInformationProvider);
    final authViewModel = ref.watch(authViewModelProvider);
    final uuid = Uuid();

    final travelPlan = ref.watch(travelPlanProvider);
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
                  const SizedBox(height: 20),
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
                          Center(
                            child: Text(
                              'Önerilen Tatil Planı',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          MarkdownBody(
                            data: travelPlan,
                            styleSheet: MarkdownStyleSheet(
                              h1: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                              h2: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                              p: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              listBullet: TextStyle(
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
                  CustomButton(
                    text: 'Kaydet',
                    onPressed: () async {
                      final PlanPlanModel plan = PlanPlanModel(
                        id: uuid.v4(),
                        fromCountry: authViewModel.user!.country!.name,
                        toCountry: travelInformation.toCountry,
                        numberOfDays: travelInformation.numberOfDays,
                        numberOfPeople: travelInformation.numberOfPeople,
                        kids: travelInformation.children,
                        budget: travelInformation.budget,
                        currency: travelInformation.currency,
                        breakfastPlan: travelInformation.breakfastPlan,
                        mealPlan: travelInformation.foodPreferences,
                        entertainmentPreferences:
                            travelInformation.entertainmentPreferences,
                        shoppingPlans: travelInformation.shoppingPlans,
                        specialRequests: travelInformation.specialRequests,
                        result: travelPlan,
                      );
                      await planViewModel.createPlan(
                          authViewModel.user!.userId, plan.toJson());

                      // Kullanıcıya başarı mesajı göster
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Plan başarıyla kaydedildi!'),
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewTripScreen()),
                      );
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

final travelPlanProvider = StateProvider<String>((ref) => '');
