import 'package:flutter/widgets.dart';
import 'package:mzansi_innovation_hub/mih_objects/minesweeper_player_score.dart';

class MihMineSweeperProvider extends ChangeNotifier {
  String difficulty;
  int toolIndex;
  int rowCount;
  int columnCount;
  int totalMines;
  List<MinesweeperPlayerScore>? leaderboard;
  List<MinesweeperPlayerScore>? myScoreboard;
  List<ImageProvider<Object>?> leaderboardUserPictures = [];

  MihMineSweeperProvider({
    this.difficulty = "Easy",
    this.toolIndex = 0,
    this.rowCount = 10,
    this.columnCount = 10,
    this.totalMines = 15,
  });

  void reset() {
    difficulty = "Easy";
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

  void setLeaderboard({required List<MinesweeperPlayerScore>? leaderboard}) {
    if (leaderboard == null) {
      this.leaderboard = [];
    } else {
      this.leaderboard = leaderboard;
    }
    notifyListeners();
  }

  void setMyScoreboard({
    required List<MinesweeperPlayerScore>? myScoreboard,
  }) {
    if (myScoreboard == null) {
      this.myScoreboard = [];
    } else {
      this.myScoreboard = myScoreboard;
    }
    notifyListeners();
  }

  void setLeaderboardUserPictures(
      {required List<ImageProvider<Object>?> leaderboardUserPictures}) {
    this.leaderboardUserPictures = leaderboardUserPictures;
    notifyListeners();
  }
}
