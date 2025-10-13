import 'package:flutter/foundation.dart';

class MihAuthenticationProvider extends ChangeNotifier {
  int toolIndex;

  MihAuthenticationProvider({
    this.toolIndex = 0,
  });

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }
}
