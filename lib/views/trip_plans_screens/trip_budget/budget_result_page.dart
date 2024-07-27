// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/models/budget_plan_model.dart';
import 'package:travelguide/models/kid_model.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/viewmodels/plan_viewmodel.dart';
import 'package:travelguide/views/home_screens/new_trip_screen.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:uuid/uuid.dart';

class BudgetResultPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planViewModel = ref.watch(planViewModelProvider);
    final travelInformation = ref.watch(travelInformationProvider);
    final authViewModel = ref.watch(authViewModelProvider);
    final uuid = Uuid();

    final budget = ref.watch(budgetProvider);
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
                          Center(
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
                              h1: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                              h2: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
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
                      final BudgetPlanModel plan = BudgetPlanModel(
                        id: uuid.v4(), // Örnek veri
                        fromCountry: 'Turkey', // Örnek veri
                        toCountry: travelInformation.country, // Örnek veri
                        numberOfDays:
                            travelInformation.numberOfDays, // Örnek veri
                        numberOfPeople:
                            travelInformation.numberOfPeople, // Örnek veri
                        kids: travelInformation.children, // Örnek veri
                        breakfastPlan:
                            travelInformation.breakfastPlan, // Örnek veri
                        mealPlan:
                            travelInformation.foodPreferences, // Örnek veri
                        entertainmentPreferences:
                            travelInformation.placesToVisit, // Örnek veri
                        shoppingPlans:
                            travelInformation.shoppingPlans, // Örnek veri
                        specialRequests:
                            travelInformation.specialRequests, // Örnek veri
                        result: budget, // Markdown verisi
                      );
                      await planViewModel.createPlan(
                          authViewModel.user!.userId, plan.toJson());

                      // Başarı mesajı göster
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Başarılı'),
                            content: Text('Plan başarıyla kaydedildi!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewTripScreen()));
                                },
                                child: Text('Tamam'),
                              ),
                            ],
                          );
                        },
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

// PlanViewModel için Riverpod provider'ı oluşturuyoruz
final planViewModelProvider = ChangeNotifierProvider((ref) => PlanViewModel());
final authViewModelProvider = ChangeNotifierProvider((ref) => AuthViewModel());

final budgetProvider = StateProvider<String>((ref) => '');
