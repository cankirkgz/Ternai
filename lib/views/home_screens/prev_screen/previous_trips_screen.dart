import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelguide/models/budget_plan_model.dart';
import 'package:travelguide/models/day_plan_model.dart';
import 'package:travelguide/models/plan_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/budget_result_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/day_result_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/plan_result_page.dart';

part 'previous_trips_screen_mixin.dart';

class PreviousTripsScreen extends StatefulWidget {
  const PreviousTripsScreen({super.key});

  @override
  State<PreviousTripsScreen> createState() => _PreviousTripsScreenState();
}

class _PreviousTripsScreenState extends State<PreviousTripsScreen> with _PreviousTripsScreenMixin {
  late Future<List<dynamic>> _futurePlans;

  @override
  void initState() {
    super.initState();
    _futurePlans = fetchAllPlans();
  }

  Future<List<dynamic>> fetchAllPlans() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    final userId = user.uid;

    final budgetPlans = await fetchBudgetPlans(userId);
    final dayPlans = await fetchDayPlans(userId);
    final planPlans = await fetchPlanPlans(userId);

    return [...budgetPlans, ...dayPlans, ...planPlans];
  }

  void _navigateToPlanPage(dynamic plan) {
    if (plan is BudgetPlanModel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BudgetResultPage(plan: plan),
        ),
      );
    } else if (plan is DayPlanModel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DayResultPage(plan: plan),
        ),
      );
    } else if (plan is PlanPlanModel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlanResultPage(plan: plan),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Önceki Tatil Planlarım'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futurePlans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching plans'));
          } else if (snapshot.hasData) {
            final plans = snapshot.data!;
            if (plans.isEmpty) {
              return const Center(child: Text('No plans found', style: TextStyle(fontSize: 24)));
            }
            return ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return GestureDetector(
                  onTap: () => _navigateToPlanPage(plan),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0, right: 30, left: 30.0),
                    height: 200,
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(blurRadius: 10, color: Colors.grey, offset: Offset.zero)
                    ]),
                    child: Card(
                      color: const Color.fromARGB(255, 170, 210, 230),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/Hollanda.jpg',
                            height: 120,
                            fit: BoxFit.fill,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                            child: Column(
                              children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  '${plan.toCountry} - ${plan.numberOfPeople} kişi için ${plan.numberOfDays} günlük tatil.',
                                  style: TextStyle(
                                    color: Colors.grey[900],
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (plan is! BudgetPlanModel)
                                  Text(
                                    'Bütçe: ${plan.budget}\$',
                                    style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No plans found'));
          }
        },
      ),
    );
  }
}