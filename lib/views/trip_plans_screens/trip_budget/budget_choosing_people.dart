import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/travel_budget_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class BudgetChoosingPeoplePage extends ConsumerWidget {
  const BudgetChoosingPeoplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelInformation = ref.watch(travelInformationProvider);
    final travelNotifier = ref.read(travelInformationProvider.notifier);
    final ScrollController scrollController = ScrollController();

    return Center(
      child: SingleChildScrollView(
        controller: scrollController,
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
            const SizedBox(height: 20),
            const Text('Gidecek kişi sayısı:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (travelInformation.numberOfPeople > 1) {
                      travelNotifier.updateNumberOfPeople(travelInformation.numberOfPeople - 1);
                    }
                  },
                ),
                Text('${travelInformation.numberOfPeople}',
                    style: const TextStyle(fontSize: 24)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    travelNotifier.updateNumberOfPeople(travelInformation.numberOfPeople + 1);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Çocuk var mı?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Checkbox(
                  value: travelInformation.kid,
                  onChanged: (value) {
                    travelNotifier.updateKid(value ?? false);
                  },
                ),
              ],
            ),
            if (travelInformation.kid) ...[
              const SizedBox(height: 20),
              const Text('Çocuk Bilgileri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              for (var i = 0; i < travelInformation.children.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Yaş: ${travelInformation.children[i].kidAge}"),
                          Text("Cinsiyet: ${travelInformation.children[i].kidGender}"),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          travelNotifier.removeChild(i);
                        },
                      ),
                    ],
                  ),
                ),
              ElevatedButton(
                onPressed: () async {
                  final result = await showDialog<ChildInformation>(
                    context: context,
                    builder: (context) {
                      int age = 0;
                      String gender = 'Kız';
                      String? ageError;
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: const Text('Çocuk Bilgisi Ekle'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Yaş',
                                    errorText: ageError,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    age = int.tryParse(value) ?? 0;
                                  },
                                ),
                                DropdownButton<String>(
                                  value: gender,
                                  items: const [
                                    DropdownMenuItem(child: Text('Kız'), value: 'Kız'),
                                    DropdownMenuItem(child: Text('Erkek'), value: 'Erkek'),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(null);
                                },
                                child: const Text('İptal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (age >= 18) {
                                    setState(() {
                                      ageError = 'Yaş 18 veya daha büyük olamaz!';
                                    });
                                  } else {
                                    Navigator.of(context).pop(ChildInformation(kidAge: age, kidGender: gender));
                                  }
                                },
                                child: const Text('Ekle'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                  if (result != null) {
                    travelNotifier.addChild(result);
                    Future.delayed(const Duration(milliseconds: 100), () {
                      scrollController.jumpTo(scrollController.position.maxScrollExtent);
                    });
                  }
                },
                child: const Text('Çocuk Ekle'),
              ),
            ],
            const SizedBox(height: 20),
            CustomButton(
              text: 'Devam',
              onPressed: () {
                if (travelInformation.numberOfPeople == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen kişi sayısı seçin!'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ),
                  );
                } else {
                  ref.read(bottomNavigationBarProvider.notifier).changePage(2);
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
