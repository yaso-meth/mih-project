import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:provider/provider.dart';

class BuildMyScoreBoardList extends StatefulWidget {
  const BuildMyScoreBoardList({super.key});

  @override
  State<BuildMyScoreBoardList> createState() =>
      _BuildMinesweeperLeaderboardListState();
}

class _BuildMinesweeperLeaderboardListState
    extends State<BuildMyScoreBoardList> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<MzansiProfileProvider, MihMineSweeperProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          MihMineSweeperProvider mineSweeperProvider, Widget? child) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, index) {
            return Divider(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            );
          },
          itemCount: mineSweeperProvider.myScoreboard!.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "#${index + 1}",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
              title: Text(
                "Score: ${mineSweeperProvider.myScoreboard![index].game_score}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
              subtitle: Text(
                "Time: ${mineSweeperProvider.myScoreboard![index].game_time}",
                style: TextStyle(
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
