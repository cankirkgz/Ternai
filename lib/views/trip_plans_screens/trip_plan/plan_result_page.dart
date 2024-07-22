import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class PlanResultPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelPlan = ref.watch(travelPlanProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Text(
                  'Önerilen Tatil Planı',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                Text(
                  travelPlan,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Geri Dön',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final travelPlanProvider = StateProvider<String>((ref) => '');

