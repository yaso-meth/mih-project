import 'package:flutter/widgets.dart';

class MihMineSweeperProvider extends ChangeNotifier {
  String difficulty;
  int toolIndex;
  int rowCount;
  int columnCount;
  int totalMines;

  MihMineSweeperProvider({
    this.difficulty = "Normal",
    this.toolIndex = 0,
    this.rowCount = 10,
    this.columnCount = 10,
    this.totalMines = 15,
  });

  void reset() {
    difficulty = "Normal";
    toolIndex = 0;
    rowCount = 10;
    columnCount = 10;
    totalMines = 15;
    notifyListeners();
  }

  void setDifficulty(String difficulty) {
    this.difficulty = difficulty;
    notifyListeners();
  }

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
