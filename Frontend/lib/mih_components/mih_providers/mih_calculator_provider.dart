import 'package:flutter/foundation.dart';

class MihCalculatorProvider extends ChangeNotifier {
  List<String> availableCurrencies;
  int toolIndex;

  MihCalculatorProvider({
    this.availableCurrencies = const [],
    this.toolIndex = 0,
  });

  void reset() {
    availableCurrencies = [];
    toolIndex = 0;
    notifyListeners();
  }

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }

  void setAvailableCurrencies({required List<String> currencies}) async {
    availableCurrencies = currencies;
    notifyListeners();
  }
}
