import 'package:flutter/foundation.dart';

class AboutMihProvider extends ChangeNotifier {
  int toolIndex;

  AboutMihProvider({
    this.toolIndex = 0,
  });

  void reset() {
    toolIndex = 0;
    notifyListeners();
  }

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }
}
