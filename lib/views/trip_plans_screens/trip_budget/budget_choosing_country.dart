import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelguide/models/country_model.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/budget_plan_model.dart';
import 'package:travelguide/views/trip_plans_screens/trip_budget/travel_budget_main.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/widgets/custom_dropdown_button.dart';
import 'package:travelguide/services/api_service.dart';

class BudgetChoosingCountryPage extends ConsumerStatefulWidget {
  const BudgetChoosingCountryPage({super.key});

  @override
  _BudgetChoosingCountryPageState createState() =>
      _BudgetChoosingCountryPageState();
}

class _BudgetChoosingCountryPageState
    extends ConsumerState<BudgetChoosingCountryPage> {
  Country? selectedCountry;
  bool isLoading = false;
  final ApiService _apiService = ApiService();

  List<Country> countries = [];

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      List<Country> loadedCountries = await _apiService.getCountries();
      setState(() {
        countries = loadedCountries;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final tatilVerileri = ref.watch(tatilVerileriProvider);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Mükemmel bir tatil için bütçe oluşturalım!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Gideceğiniz ülke:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: CustomDropDownButton(
              listName: "Ülke",
              items: {for (var country in countries) country.id: country.name},
              validator: (value) =>
                  value == null ? "Lütfen bir ülke seçiniz" : null,
              onChanged: (value) {
                setState(() {
                  selectedCountry = countries.firstWhere((c) => c.id == value);
                  ref.read(tatilVerileriProvider.notifier).updateUlke(value!);
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Devam',
            onPressed: () {
              if (tatilVerileri.ulke.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen bir ülke seçin!'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                print(tatilVerileri.ulke);
                ref.read(bottomNavigationBarProvider.notifier).changePage(1);
              }
            },
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
