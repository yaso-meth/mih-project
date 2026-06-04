import 'package:flutter/foundation.dart';

class AboutMihProvider extends ChangeNotifier {
  int toolIndex;
  String version = "1.3.0";

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
