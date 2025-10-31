class MinesweeperPlayerScore {
  String app_id;
  String username;
  String proPicUrl;
  String difficulty;
  String game_time;
  double game_score;
  DateTime played_date;

  MinesweeperPlayerScore({
    required this.app_id,
    required this.username,
    required this.proPicUrl,
    required this.difficulty,
    required this.game_time,
    required this.game_score,
    required this.played_date,
  });

  factory MinesweeperPlayerScore.fromJson(Map<String, dynamic> json) {
    return MinesweeperPlayerScore(
      app_id: json['app_id'],
      username: json['username'],
      proPicUrl: json['proPicUrl'],
      difficulty: json['difficulty'],
      game_time: json['game_time'],
      game_score: json['game_score'],
      played_date: DateTime.parse(json['played_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_id': app_id,
      'username': username,
      'proPicUrl': proPicUrl,
      'difficulty': difficulty,
      'game_time': game_score,
      'played_date': played_date.toIso8601String(),
    };
  }
}
