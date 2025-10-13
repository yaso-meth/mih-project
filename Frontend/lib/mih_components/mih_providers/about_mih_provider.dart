import 'package:flutter/foundation.dart';

class AboutMihProvider extends ChangeNotifier {
  int toolIndex;

  AboutMihProvider({
    this.toolIndex = 0,
  });

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }
}
