import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/day_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_day/travel_day_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/widgets/custom_dropdown_button.dart';
import 'package:travelguide/views/widgets/custom_text_field.dart';

class DayChoosingBudgetPage extends ConsumerStatefulWidget {
  const DayChoosingBudgetPage({super.key});

  @override
  _DayChoosingBudgetPageState createState() => _DayChoosingBudgetPageState();
}

class _DayChoosingBudgetPageState extends ConsumerState<DayChoosingBudgetPage> {
  final TextEditingController _budgetController = TextEditingController();
  String _selectedCurrency = 'TRY';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Tatilde geçireceğiniz gün sayısını hesaplayalım!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor),
          ),
          const SizedBox(height: 20),
          const Text('Bütçeniz:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _budgetController,
                  labelText: 'Bütçe',
                  hintText: 'Bütçe giriniz',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir bütçe giriniz';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Lütfen geçerli bir sayı giriniz';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomDropDownButton(
                  listName: 'Para Birimi',
                  items: const {'TRY': 'Türk Lirası', 'EUR': 'Euro'},
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCurrency = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Devam',
            onPressed: () {
              if (_budgetController.text.isEmpty ||
                  double.tryParse(_budgetController.text) == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen geçerli bir bütçe giriniz'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                ref
                    .read(travelInformationProvider.notifier)
                    .updateBudget(double.parse(_budgetController.text));
                ref
                    .read(travelInformationProvider.notifier)
                    .updateCurrency(_selectedCurrency);
                ref.read(bottomNavigationBarProvider.notifier).changePage(3);
              }
            },
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
