import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  static const String apiKey = '9d86fdabf8f7070f494653da';
  static const String apiUrl = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/';

  Future<double> getExchangeRate(String fromCurrency, String toCurrency) async {
    final response = await http.get(Uri.parse('$apiUrl$fromCurrency'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['conversion_rates'][toCurrency] ?? 0.0;
    } else {
      throw Exception('Failed to load exchange rate');
    }
  }
}