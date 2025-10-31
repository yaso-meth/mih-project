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
  Color getMedalColor(int index) {
    switch (index) {
      case (0):
        return MihColors.getGoldColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark");
      case (1):
        return MihColors.getSilverColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark");
      case (2):
        return MihColors.getBronze(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark");
      default:
        return MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
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
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 20),
              child: Row(
                children: [
                  Text(
                    "#${index + 1}",
                    style: TextStyle(
                      fontSize: 25,
                      color: getMedalColor(index),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Score: ${mineSweeperProvider.myScoreboard![index].game_score}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: getMedalColor(index),
                        ),
                      ),
                      Text(
                        "Time: ${mineSweeperProvider.myScoreboard![index].game_time}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          // fontWeight: FontWeight.bold,
                          color: getMedalColor(index),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
