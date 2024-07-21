import 'package:flutter/material.dart';
import 'package:currency_converter/currency.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:travelguide/models/price_model.dart';
import 'package:travelguide/models/country_model.dart';
import 'package:travelguide/models/category_model.dart';
import 'package:travelguide/models/product_service_model.dart';
import 'package:travelguide/services/api_service.dart'; // ApiService'i import ediyoruz

class ResultScreen extends StatefulWidget {
  final Country country;
  final Category category;
  final ProductService? subCategory;
  final Country? userCountry; // Kullanıcının ülkesi

  const ResultScreen({
    Key? key,
    required this.country,
    required this.category,
    this.subCategory,
    required this.userCountry, // Kullanıcının ülkesi
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ApiService apiService;
  late Future<List<Price>> futurePrices;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    futurePrices = apiService.getPrices(
        widget.country.id, widget.category.id, widget.subCategory?.id);
  }

  Future<Map<String, double>> convertCurrencies(
      String fromCurrency, double amount) async {
    try {
      print(
          "Converting from $fromCurrency to USD and ${widget.userCountry!.currency}");

      var usdRate = await CurrencyConverter.convert(
        from: Currency.values.firstWhere((e) => e.name == fromCurrency,
            orElse: () => Currency.usd),
        to: Currency.usd,
        amount: amount,
      );

      var userCurrencyRate = await CurrencyConverter.convert(
        from: Currency.values.firstWhere((e) => e.name == fromCurrency,
            orElse: () => Currency.usd),
        to: Currency.values.firstWhere(
            (e) => e.name == widget.userCountry!.currency,
            orElse: () => Currency.usd),
        amount: amount,
      );

      print(
          "Converted rates: USD = $usdRate, User Currency = $userCurrencyRate");

      return {
        'usd': usdRate ?? 0.0,
        'userCurrency': userCurrencyRate ?? 0.0,
      };
    } catch (e) {
      print("Currency conversion error: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fiyat Sonuçları',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Price>>(
        future: futurePrices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Sonuç bulunamadı'));
          } else {
            List<Price> prices = snapshot.data!;
            return ListView.builder(
              itemCount: prices.length,
              itemBuilder: (context, index) {
                Price price = prices[index];
                return FutureBuilder<Map<String, double>>(
                  future: convertCurrencies(price.currency, price.price),
                  builder: (context, conversionSnapshot) {
                    if (conversionSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (conversionSnapshot.hasError) {
                      return ListTile(
                        title: Text(
                          '${price.productServiceName} - ${price.price} ${price.currency}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Döviz çevirme hatası'),
                      );
                    } else {
                      var conversionRates = conversionSnapshot.data!;
                      double? usdPrice = conversionRates['usd'];
                      double? userCurrencyPrice =
                          conversionRates['userCurrency'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${widget.country.name} - ${price.productServiceName}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Ülke Fiyatı: ${price.price.toStringAsFixed(2)} ${price.currency}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Dolar Fiyatı: ${usdPrice?.toStringAsFixed(2)} USD',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '${widget.userCountry!.name} Fiyatı: ${userCurrencyPrice?.toStringAsFixed(2)} ${widget.userCountry!.currency}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.orange,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Son güncelleme: ${price.lastUpdated.day}/${price.lastUpdated.month}/${price.lastUpdated.year}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Not: Bu fiyatlar ortalama olup, yukarı veya aşağı yönlü değişiklik gösterebilir.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.redAccent,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
