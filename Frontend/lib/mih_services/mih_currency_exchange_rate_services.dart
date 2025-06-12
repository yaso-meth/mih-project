import 'dart:convert';

import 'package:mzansi_innovation_hub/mih_components/mih_objects/currency.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihCurrencyExchangeRateServices {
  static Future<List<Currency>> getCurrencyObjectList() async {
    final response = await http.get(Uri.parse(
        "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.min.json"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      List<Currency> currencies = [];
      jsonMap.forEach((code, dynamic nameValue) {
        final String name = nameValue is String ? nameValue : 'Unknown Name';
        currencies.add(Currency(code: code, name: name));
      });
      currencies.sort((a, b) => a.name.compareTo(b.name));
      return currencies;
    } else {
      throw Exception('failed to fatch currencies');
    }
  }

  static Future<List<String>> getCurrencyCodeList() async {
    final response = await http.get(Uri.parse(
        "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.min.json"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      List<String> currencies = [];
      jsonMap.forEach((code, dynamic nameValue) {
        final String name = nameValue is String ? nameValue : 'Unknown Name';
        currencies.add("$code - $name");
      });
      currencies.sort();
      return currencies;
    } else {
      throw Exception('failed to fatch currencies');
    }
  }

  static Future<List<String>> getCurrencyExchangeValue(
    String fromCurrencyCode,
    String toCurrencyCode,
  ) async {
    final response = await http.get(Uri.parse(
        "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/$fromCurrencyCode.min.json"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic>? baseCurrencyData =
          jsonResponse[fromCurrencyCode];
      final List<String> dateValue = [];
      if (baseCurrencyData != null) {
        final dynamic rateValue = baseCurrencyData[toCurrencyCode];
        final String date = jsonResponse["date"];

        if (rateValue is num) {
          dateValue.add(date);
          dateValue.add(rateValue.toString());
          return dateValue;
        } else {
          print(
              'Warning: Rate for $toCurrencyCode in $fromCurrencyCode is not a number or missing.');
          return ["Error", "0"];
        }
      } else {
        throw Exception(
            'Base currency "$fromCurrencyCode" data not found in response.');
      }
    } else {
      throw Exception('failed to fatch currencies');
    }
  }
}
