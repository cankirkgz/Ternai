import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/models/country_model.dart';
import 'package:travelguide/services/api_service.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/authentication_screens/phone_number_select_page.dart';
import 'package:travelguide/views/home_screens/home_page.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/widgets/custom_dropdown_button.dart';

class CountrySelectPage extends StatefulWidget {
  const CountrySelectPage({super.key});

  @override
  State<CountrySelectPage> createState() => _CountrySelectPageState();
}

class _CountrySelectPageState extends State<CountrySelectPage> {
  final _formKey = GlobalKey<FormState>();
  Country? selectedCountry;
  bool isLoading = false;

  final ApiService _apiService = ApiService(); // ApiService'i oluştur

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
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Kullanıcı Bilgileri"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Text(
                  "Hangi ülkede yaşıyorsun?",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                CustomDropDownButton(
                  listName: "Ülke",
                  items: {
                    for (var country in countries) country.id: country.name
                  },
                  validator: (value) =>
                      value == null ? "Lütfen bir ülke seçiniz" : null,
                  onChanged: (value) {
                    setState(() {
                      selectedCountry =
                          countries.firstWhere((c) => c.id == value);
                    });
                  },
                ),
                SizedBox(height: 16),
                CustomButton(
                  text: "Kaydet",
                  color: AppColors.primaryColor,
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        selectedCountry != null) {
                      Map<String, dynamic> data = {
                        'country': selectedCountry!.toMap()
                      };
                      await authViewModel.updateUserField(
                          authViewModel.user!.userId, data);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
