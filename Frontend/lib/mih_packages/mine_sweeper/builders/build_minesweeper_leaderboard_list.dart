import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:provider/provider.dart';

class BuildMinesweeperLeaderboardList extends StatefulWidget {
  const BuildMinesweeperLeaderboardList({super.key});

  @override
  State<BuildMinesweeperLeaderboardList> createState() =>
      _BuildMinesweeperLeaderboardListState();
}

class _BuildMinesweeperLeaderboardListState
    extends State<BuildMinesweeperLeaderboardList> {
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
          itemCount: mineSweeperProvider.leaderboard!.length,
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
                  MihCircleAvatar(
                    key: UniqueKey(),
                    imageFile:
                        mineSweeperProvider.leaderboardUserPictures.isNotEmpty
                            ? mineSweeperProvider.leaderboardUserPictures[index]
                            : null,
                    width: 80,
                    editable: false,
                    fileNameController: null,
                    userSelectedfile: null,
                    frameColor: getMedalColor(index),
                    backgroundColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    onChange: () {},
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${mineSweeperProvider.leaderboard![index].username}${profileProvider.user!.username == mineSweeperProvider.leaderboard![index].username ? " (You)" : ""}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: getMedalColor(index),
                        ),
                      ),
                      Text(
                        "Score: ${mineSweeperProvider.leaderboard![index].game_score}\nTime: ${mineSweeperProvider.leaderboard![index].game_time}",
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
