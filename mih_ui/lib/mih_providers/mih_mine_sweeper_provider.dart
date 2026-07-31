import 'package:flutter/widgets.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_hive/minesweeper_hive_data.dart';
import 'package:mzansi_innovation_hub/mih_objects/minesweeper_player_score.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';

class MihMineSweeperProvider extends ChangeNotifier {
  final MinesweeperHiveData _hiveData;
  String difficulty;
  int toolIndex;
  int rowCount;
  int columnCount;
  int totalMines;
  List<MinesweeperPlayerScore>? leaderboard;
  List<MinesweeperPlayerScore>? myScoreboard;

  MihMineSweeperProvider(
    this._hiveData, {
    this.difficulty = "Easy",
    this.toolIndex = 0,
    this.rowCount = 10,
    this.columnCount = 10,
    this.totalMines = 15,
  }) {
    loadCachedMSleaderboards();
  }

  void loadCachedMSleaderboards() {
    leaderboard = _hiveData.getCachedPlayerLeaderboard(difficulty);
    myScoreboard = _hiveData.getCachedMyLeaderboard(difficulty);
    KenLogger.success("Minesweeper Leaderboards Loaded from Cache");
    notifyListeners();
  }

  Future<bool> syncWithMihServerData(
    MzansiProfileProvider profileProvider,
    MihMineSweeperProvider mineSweeperProvider,
  ) async {
    await _hiveData.proccessModificationQueue();
    bool success = await _hiveData.syncMinesweeperWithServer(
        profileProvider, mineSweeperProvider);
    loadCachedMSleaderboards();
    return success;
  }

  Future<void> addNewScoreLocally(
    MzansiProfileProvider profileProvider,
    MihMineSweeperProvider mineSweeperProvider,
    MinesweeperPlayerScore newScore,
  ) async {
    await _hiveData.addNewScore(newScore);
    await _hiveData.tryAddToGlobalLeaderboard(newScore);
    await _hiveData.queueAddScoreModification(newScore);
    await _hiveData.proccessModificationQueue();
    await _hiveData.syncMinesweeperWithServer(
        profileProvider, mineSweeperProvider);
    loadCachedMSleaderboards();
  }

  Future<void> clearMinesweeperCacheAndProvider() async {
    await _hiveData.clearMinesweeperCache();
    reset();
  }

  bool isLocalModificationsPending() {
    return _hiveData.isModificationNotEmpty();
  }

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
    loadCachedMSleaderboards();
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
}
