import 'dart:convert';
import 'package:bars/utilities/currency_key.dart';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String apiKey = currencyKey; // Replace with your actual API key

  Future<double> fetchExchangeRate(
      String fromCurrency, String toCurrency) async {
    final response = await http.get(Uri.parse(
        'https://openexchangerates.org/api/latest.json?app_id=$apiKey'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['rates'][toCurrency] / data['rates'][fromCurrency];
    } else {
      throw Exception('Failed to load exchange rate');
    }
  }
}
