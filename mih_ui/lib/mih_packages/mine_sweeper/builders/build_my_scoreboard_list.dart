import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
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
        return MihColors.gold();
      case (1):
        return MihColors.silver();
      case (2):
        return MihColors.bronze();
      default:
        return MihColors.secondary();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Consumer2<MzansiProfileProvider, MihMineSweeperProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          MihMineSweeperProvider mineSweeperProvider, Widget? child) {
        return ListView.separated(
          separatorBuilder: (BuildContext context, index) {
            return SizedBox(
              height: 3,
            );
          },
          itemCount: mineSweeperProvider.myScoreboard!.length,
          itemBuilder: (context, index) {
            return Material(
              color: getMedalColor(index),
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 20),
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        "#${index + 1}",
                        style: TextStyle(
                          fontSize: 25,
                          color: MihColors.primary(),
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
                              color: MihColors.primary(),
                            ),
                          ),
                          Text(
                            "Time: ${mineSweeperProvider.myScoreboard![index].game_time}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                              color: MihColors.primary(),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
