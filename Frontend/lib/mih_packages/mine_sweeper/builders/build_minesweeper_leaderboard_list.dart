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
          itemCount: mineSweeperProvider.leaderboard!.length,
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
                  const SizedBox(width: 10),
                  MihCircleAvatar(
                    key: UniqueKey(),
                    imageFile:
                        mineSweeperProvider.leaderboardUserPictures.isNotEmpty
                            ? mineSweeperProvider.leaderboardUserPictures[index]
                            : null,
                    width: 60,
                    editable: false,
                    fileNameController: null,
                    userSelectedfile: null,
                    frameColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    backgroundColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    onChange: () {},
                  ),
                ],
              ),
              title: Text(
                "${mineSweeperProvider.leaderboard![index].username}${profileProvider.user!.username == mineSweeperProvider.leaderboard![index].username ? " (You)" : ""}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
              subtitle: Text(
                "Score: ${mineSweeperProvider.leaderboard![index].game_score}\nTime: ${mineSweeperProvider.leaderboard![index].game_time}",
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
