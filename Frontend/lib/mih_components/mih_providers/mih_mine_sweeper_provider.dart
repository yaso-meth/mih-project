import 'package:flutter/widgets.dart';

class MihMineSweeperProvider extends ChangeNotifier {
  int toolIndex;
  int rowCount;
  int columnCount;
  int totalMines;

  MihMineSweeperProvider({
    this.toolIndex = 0,
    this.rowCount = 10,
    this.columnCount = 10,
    this.totalMines = 15,
  });

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }

  void setRowCount(int rowCount) {
    this.rowCount = rowCount;
    notifyListeners();
  }

  void setCoulmnCount(int columnCount) {
    this.columnCount = columnCount;
    notifyListeners();
  }

  void setTotalMines(int totalMines) {
    this.totalMines = totalMines;
    notifyListeners();
  }
}
