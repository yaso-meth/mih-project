import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_objects/minesweeper_player_score.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_minesweeper_services.dart';

class MinesweeperHiveData {
  final Box<List> _playerLeaderboardBox =
      Hive.box<List>('ms_player_leaderboard_box');
  final Box<List> _myLeaderboardBox = Hive.box<List>('ms_my_leaderboard_box');
  final Box<Map> _modificationsQueue =
      Hive.box<Map>('minesweeper_modifications_queue');

  Future<void> clearMinesweeperCache() async {
    try {
      await _playerLeaderboardBox.clear();
      await _myLeaderboardBox.clear();
      KenLogger.success("Cleared Local Minesweeper Cache.");
    } catch (error) {
      KenLogger.error("Failed to clear local minesweeper cache.");
    }
  }

  List<MinesweeperPlayerScore> getCachedPlayerLeaderboard(String difficulty) {
    final list = _playerLeaderboardBox.get(difficulty);
    if (list == null) return [];
    List<MinesweeperPlayerScore> sortedList =
        List<MinesweeperPlayerScore>.from(list);
    sortedList.sort((a, b) => b.game_score.compareTo(a.game_score));
    return sortedList;
  }

  List<MinesweeperPlayerScore> getCachedMyLeaderboard(String difficulty) {
    final list = _myLeaderboardBox.get(difficulty);
    if (list == null) return [];

    List<MinesweeperPlayerScore> sortedList =
        List<MinesweeperPlayerScore>.from(list);
    sortedList.sort((a, b) => b.game_score.compareTo(a.game_score));
    return sortedList;
  }

  Future<void> addNewScore(MinesweeperPlayerScore newScore) async {
    var list = _myLeaderboardBox.get(newScore.difficulty) ?? [];
    List<MinesweeperPlayerScore> sortedList =
        List<MinesweeperPlayerScore>.from(list);
    sortedList.add(newScore);
    sortedList.sort((a, b) => b.game_score.compareTo(a.game_score));
    await _myLeaderboardBox.put(newScore.difficulty, sortedList);
    KenLogger.success("New Score Saved Locally.");
  }

  Future<void> tryAddToGlobalLeaderboard(
      MinesweeperPlayerScore newScore) async {
    final rawList = _playerLeaderboardBox.get(newScore.difficulty) ?? [];
    List<MinesweeperPlayerScore> globalScores =
        List<MinesweeperPlayerScore>.from(rawList);
    globalScores.sort((a, b) => b.game_score.compareTo(a.game_score));
    bool qualifies = false;
    if (globalScores.length < 20) {
      qualifies = true;
    } else {
      double lowestScore = globalScores.last.game_score;
      if (newScore.game_score > lowestScore) {
        qualifies = true;
      }
    }
    if (qualifies) {
      globalScores.add(newScore);
      globalScores.sort((a, b) => b.game_score.compareTo(a.game_score));
      if (globalScores.length > 20) {
        globalScores = globalScores.sublist(0, 20);
      }
      await _playerLeaderboardBox.put(newScore.difficulty, globalScores);
      KenLogger.success(
          "Local score qualified for Top 20 offline global leaderboard!");
    }
  }

  Future<void> cachePlayerLeaderBoardData(
    String difficulty,
    List<MinesweeperPlayerScore> remotePlayerLeaderboard,
  ) async {
    await _playerLeaderboardBox.put(difficulty, remotePlayerLeaderboard);
    KenLogger.success(
        "Minesweeper Player Leaderboard Cached for $difficulty mode");
  }

  Future<void> cacheMyLeaderBoardData(
    String difficulty,
    List<MinesweeperPlayerScore> remoteMyLeaderboard,
  ) async {
    await _myLeaderboardBox.put(difficulty, remoteMyLeaderboard);
    KenLogger.success("Minesweeper My Leaderboard Cached for $difficulty mode");
  }

  Future<bool> syncMinesweeperWithServer(
    MzansiProfileProvider profileProvider,
    MihMineSweeperProvider mineSweeperProvider,
  ) async {
    try {
      final activeDifficulty = mineSweeperProvider.difficulty;
      List<MinesweeperPlayerScore> remotePlayerLeaderboard =
          await MihMinesweeperServices()
              .getTop20LeaderboardV2(mineSweeperProvider);
      await cachePlayerLeaderBoardData(
          activeDifficulty, remotePlayerLeaderboard);
      List<MinesweeperPlayerScore> remoteMyLeaderboard =
          await MihMinesweeperServices()
              .getMyScoreboardV2(profileProvider, mineSweeperProvider);
      await cacheMyLeaderBoardData(activeDifficulty, remoteMyLeaderboard);
      return true;
    } catch (error) {
      KenLogger.warning("MIH App Operating in Offline Mode. Sync Paused.");
      return false;
    }
  }

  Future<void> queueAddScoreModification(
      MinesweeperPlayerScore newScore) async {
    await _modificationsQueue.add({
      'action': 'ADD',
      'payload': newScore,
    });
    KenLogger.warning("Add New Score Queued For Online Sync");
  }

  Future<bool> proccessModificationQueue() async {
    if (_modificationsQueue.isEmpty) {
      return true;
    }
    final List<dynamic> queueKeys = _modificationsQueue.keys.toList();
    for (var taskKey in queueKeys) {
      final task = _modificationsQueue.get(taskKey);
      if (task == null) {
        continue;
      }
      final String action = task['action'];
      final MinesweeperPlayerScore newScore = task['payload'];
      if (action == 'ADD') {
        int? responseCode =
            await MihMinesweeperServices().addPlayerScoreV2(newScore);
        if (responseCode != null && responseCode == 201) {
          await _modificationsQueue.delete(taskKey);
          KenLogger.success("Add New Local Card to MIH Cloud");
        } else {
          KenLogger.warning("MIH App Operating in Offline Mode. Sync Paused");
          return false;
        }
      }
    }
    return true;
  }

  bool isModificationNotEmpty() {
    return _modificationsQueue.values.toList().isNotEmpty;
  }
}
