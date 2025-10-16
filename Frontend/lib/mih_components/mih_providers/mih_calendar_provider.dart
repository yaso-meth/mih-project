import 'package:flutter/foundation.dart';

class MihCalendarProvider extends ChangeNotifier {
  int toolIndex;

  MihCalendarProvider({
    this.toolIndex = 0,
  });

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }
}
