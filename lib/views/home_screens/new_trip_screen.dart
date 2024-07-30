import 'package:flutter/material.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/travel_budget_main.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/travel_day_main.dart';
import 'package:travelguide/views/trip_plans_screens/trip_plan/travel_plan_main.dart';

class NewTripScreen extends StatelessWidget {
  const NewTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double buttonSize = MediaQuery.of(context).size.width * 0.4;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Tatil Planı Oluştur',
            style: TextStyle(color: AppColors.textColor)),
        centerTitle: false,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Tatil Planınızı Yapın',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildOptionCard(
                    context,
                    icon: Icons.attach_money,
                    text: "Tatil Bütçesi",
                    size: buttonSize,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TravelBudgetMain()),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildOptionCard(
                    context,
                    icon: Icons.map,
                    text: "Tatil Planı",
                    size: buttonSize,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TravelPlanMain()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildOptionCard(
                context,
                icon: Icons.calendar_today,
                text: "Kalacak Gün Sayısı",
                size: buttonSize,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TravelDayMain()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context,
      {required IconData icon,
      required String text,
      required double size,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white.withOpacity(0.9),
        elevation: 5,
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: AppColors.primaryColor, size: 40),
              const SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}