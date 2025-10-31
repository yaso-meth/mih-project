import 'dart:convert';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/minesweeper_player_score.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihMinesweeperServices {
  Future<int> getTop20Leaderboard(
    MihMineSweeperProvider mineSweeperProvider,
  ) async {
    String difficulty = mineSweeperProvider.difficulty;
    var response = await http.get(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/minesweeper/leaderboard/top20/$difficulty"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<MinesweeperPlayerScore> leaderboard =
          List<MinesweeperPlayerScore>.from(
              l.map((model) => MinesweeperPlayerScore.fromJson(model)));
      mineSweeperProvider.setLeaderboard(leaderboard: leaderboard);
    } else {
      mineSweeperProvider.setLeaderboard(leaderboard: null);
    }
    return response.statusCode;
  }

  Future<int> getMyScoreboard(
    MzansiProfileProvider profileProvider,
    MihMineSweeperProvider mineSweeperProvider,
  ) async {
    String difficulty = mineSweeperProvider.difficulty;
    var response = await http.get(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/minesweeper/leaderboard/top_score/$difficulty/${profileProvider.user!.app_id}"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<MinesweeperPlayerScore> leaderboard =
          List<MinesweeperPlayerScore>.from(
              l.map((model) => MinesweeperPlayerScore.fromJson(model)));
      mineSweeperProvider.setMyScoreboard(myScoreboard: leaderboard);
    } else {
      mineSweeperProvider.setMyScoreboard(myScoreboard: null);
    }
    return response.statusCode;
  }

  Future<int> addPlayerScore(
    MzansiProfileProvider profileProvider,
    MihMineSweeperProvider mineSweeperProvider,
    String game_time,
    double game_score,
  ) async {
    DateTime now = DateTime.now();
    String formattedDateTime = now.toString();
    var response = await http.post(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/minesweeper/leaderboard/player_score/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": profileProvider.user!.app_id,
        "difficulty": mineSweeperProvider.difficulty,
        "game_time": game_time,
        "game_score": game_score,
        "played_date": formattedDateTime,
      }),
    );
    return response.statusCode;
  }
}
