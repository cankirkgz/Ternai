import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travelguide/models/budget_plan_model.dart';
import 'package:travelguide/models/country_model.dart';
import 'package:travelguide/models/day_plan_model.dart';
import 'package:travelguide/models/plan_plan_model.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/budget_result_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/day_result_page.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/plan_result_page.dart';

part 'previous_trips_screen_mixin.dart';

class PreviousTripsScreen extends StatefulWidget {
  const PreviousTripsScreen({super.key});

  @override
  State<PreviousTripsScreen> createState() => _PreviousTripsScreenState();
}

class _PreviousTripsScreenState extends State<PreviousTripsScreen>
    with _PreviousTripsScreenMixin {
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

  Future<Country?> _fetchCountry(String countryName) async {
    try {
      final countryService = CountryService();
      final country = await countryService.getCountryByName(countryName);
      return country;
    } catch (e) {
      print('Error fetching country data: $e');
      return null;
    }
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

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5, // Placeholder miktarı
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 120,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: double.infinity,
                      height: 15.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlanCard(dynamic plan, Country country) {
    String title;
    Color backgroundColor;

    if (plan is BudgetPlanModel) {
      title =
          '${country.name} - ${plan.numberOfPeople} kişi için ${plan.numberOfDays} günlük tatil';
      backgroundColor = Colors.blueAccent;
    } else if (plan is DayPlanModel) {
      title =
          '${country.name} - ${plan.numberOfPeople} kişi ile ${plan.budget} ${plan.currency} bütçeli tatil';
      backgroundColor = Colors.greenAccent;
    } else if (plan is PlanPlanModel) {
      title =
          '${country.name} - ${plan.numberOfPeople} kişi için ${plan.numberOfDays} günlük tatil planı';
      backgroundColor = Colors.orangeAccent;
    } else {
      title = 'Bilinmeyen Plan';
      backgroundColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 30, left: 30.0),
      child: GestureDetector(
        onTap: () => _navigateToPlanPage(plan),
        child: Card(
          color: backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              (country.countryImageUrl.isNotEmpty)
                  ? Image.network(
                      country.countryImageUrl,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: Colors.grey,
                          child: Icon(Icons.broken_image, size: 50),
                        );
                      },
                    )
                  : Container(
                      height: 120,
                      color: Colors.grey,
                      child: Icon(Icons.broken_image, size: 50),
                    ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryColor,
                  Colors.white,
                ],
              ),
            ),
          ),
          FutureBuilder<List<dynamic>>(
            future: _futurePlans,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerLoading();
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Planlar yüklenirken hata oluştu.'));
              } else if (snapshot.hasData) {
                final plans = snapshot.data!;
                if (plans.isEmpty) {
                  return const Center(
                      child: Text('Henüz bir plan oluşturulmadı.'));
                }
                return ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return FutureBuilder<Country?>(
                      future: _fetchCountry(plan.toCountry),
                      builder: (context, countrySnapshot) {
                        if (countrySnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 30.0),
                              height: 120,
                              color: Colors.grey,
                            ),
                          );
                        } else if (countrySnapshot.hasError ||
                            !countrySnapshot.hasData) {
                          return const Center(
                              child: Text('Ülke verisi yüklenemedi.'));
                        } else {
                          final country = countrySnapshot.data!;
                          return _buildPlanCard(plan, country);
                        }
                      },
                    );
                  },
                );
              } else {
                return const Center(child: Text('Henüz bir plan'));
              }
            },
          ),
        ],
      ),
    );
  }
}
