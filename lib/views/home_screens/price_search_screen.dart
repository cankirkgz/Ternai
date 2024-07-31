import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/models/category_model.dart';
import 'package:travelguide/models/country_model.dart';
import 'package:travelguide/models/product_service_model.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:travelguide/views/widgets/custom_button.dart';
import 'package:travelguide/views/widgets/custom_dropdown_button.dart';
import 'result_screen.dart';
import 'package:travelguide/services/api_service.dart';

class PriceSearchScreen extends StatefulWidget {
  const PriceSearchScreen({super.key});

  @override
  _PriceSearchScreenState createState() => _PriceSearchScreenState();
}

class _PriceSearchScreenState extends State<PriceSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  Country? selectedCountry;
  Category? selectedCategory;
  ProductModel? selectedSubCategory;
  bool isLoading = false;

  final ApiService _apiService = ApiService();

  List<Country> countries = [];
  List<Category> categories = [];
  List<ProductModel> productServices = [];

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _loadCategories();
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

  Future<void> _loadCategories() async {
    try {
      List<Category> loadedCategories = await _apiService.getCategories();
      setState(() {
        categories = loadedCategories;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _loadProductServices(String categoryId) async {
    try {
      List<ProductModel> loadedProductServices =
          await _apiService.getProductServices();
      setState(() {
        productServices = loadedProductServices
            .where((ps) => ps.categoryId == categoryId)
            .toList();
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.1,
            vertical: screenHeight * 0.1,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bilgi almak istediğiniz hizmet ile ilgili:",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
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
                SizedBox(height: 10),
                CustomDropDownButton(
                  listName: "Kategori",
                  items: {
                    for (var category in categories) category.id: category.name
                  },
                  validator: (value) =>
                      value == null ? "Lütfen bir kategori seçiniz" : null,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory =
                          categories.firstWhere((c) => c.id == value);
                      selectedSubCategory = null;
                      productServices = [];
                    });
                    _loadProductServices(value!);
                  },
                ),
                if (selectedCategory != null && productServices.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(height: 10),
                      CustomDropDownButton(
                        listName: "Ürün veya Hizmet",
                        items: {for (var ps in productServices) ps.id: ps.name},
                        validator: (value) => value == null
                            ? "Lütfen bir ürün veya hizmet seçiniz"
                            : null,
                        onChanged: (value) {
                          setState(() {
                            selectedSubCategory = productServices
                                .firstWhere((ps) => ps.id == value);
                          });
                        },
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? CircularProgressIndicator()
                        : CustomButton(
                            text: "Ara",
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() {
                                  isLoading = true;
                                });

                                await Future.delayed(Duration(seconds: 1));
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultScreen(
                                      country: selectedCountry!,
                                      category: selectedCategory!,
                                      subCategory: selectedSubCategory,
                                      userCountry: authViewModel.user!.country!,
                                    ),
                                  ),
                                );
                              }
                            },
                            color: AppColors.primaryColor,
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
