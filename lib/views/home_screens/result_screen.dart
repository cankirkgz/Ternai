import 'package:currency_converter/currency.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:travelguide/models/price_model.dart';
import 'package:travelguide/models/country_model.dart';
import 'package:travelguide/models/category_model.dart';
import 'package:travelguide/models/product_service_model.dart';
import 'package:travelguide/services/api_service.dart'; // ApiService'i import ediyoruz

class ResultScreen extends StatefulWidget {
  final Country country;
  final Category category;
  final ProductService? subCategory;

  const ResultScreen({
    Key? key,
    required this.country,
    required this.category,
    this.subCategory,
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

  Future<double?> convertCurrency(
      String fromCurrency, String toCurrency, double amount) async {
    try {
      var rate = await CurrencyConverter.convert(
        from: Currency.values.firstWhere((e) => e.name == fromCurrency),
        to: Currency.values.firstWhere((e) => e.name == toCurrency),
        amount: amount,
      );
      return rate;
    } catch (e) {
      print("Currency conversion error: $e");
      return null;
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
                return FutureBuilder<double?>(
                  future: convertCurrency(price.currency, 'TRY', price.price),
                  builder: (context, conversionSnapshot) {
                    if (conversionSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ListTile(
                        title: Text(
                          '${price.productServiceName} - ${price.price} ${price.currency}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Çeviriliyor...'),
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
                      double? convertedPrice = conversionSnapshot.data;
                      double? usdPrice = convertedPrice != null
                          ? (convertedPrice / 26.88)
                          : null; // 1 USD = 26.88 TRY (örnek oran)
                      return ListTile(
                        title: Text(
                          '${price.productServiceName}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Ülke Fiyatı: ${price.price.toStringAsFixed(2)} ${price.currency}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              'Son güncelleme: ${price.lastUpdated.day}/${price.lastUpdated.month}/${price.lastUpdated.year}',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Not: Bu fiyatlar ortalama olup, yukarı veya aşağı yönlü değişiklik gösterebilir.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
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
