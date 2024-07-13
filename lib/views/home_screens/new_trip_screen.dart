import 'package:flutter/material.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/trip_budget_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class NewTripScreen extends StatelessWidget {
  const NewTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Tatil Planı Oluştur'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.65,
              image: AssetImage("assets/images/welcome_page.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomButton(text: "Tatil Bütçesi", color: Colors.blue, onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TatilButcesiMainPage()));

                }),
                const SizedBox(height: 20),
                CustomButton(text: "Tatil Planı", color: Colors.blue, onPressed: () {}),
                const SizedBox(height: 20),
                CustomButton(text: "Kalacak Gün Sayısı", color: Colors.blue, onPressed: () {}),
              ],
            ),
          ),
        ),
    );
  }

}
