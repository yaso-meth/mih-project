import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
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
    return Consumer2<MzansiProfileProvider, MihMineSweeperProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          MihMineSweeperProvider mineSweeperProvider, Widget? child) {
        return ListView.separated(
          separatorBuilder: (BuildContext context, index) {
            return SizedBox(
              height: 3,
            );
          },
          itemCount: mineSweeperProvider.leaderboard!.length,
          itemBuilder: (context, index) {
            return Material(
              color: getMedalColor(index),
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                splashColor: Color.lerp(
                  MihColors.bluishPurple(),
                  Colors.black,
                  0.01,
                ),
                hoverColor: MihColors.highlight(),
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
                    mineSweeperProvider.leaderboard![index].proPicUrl
                                .endsWith('/') ||
                            mineSweeperProvider.leaderboard![index].proPicUrl ==
                                ''
                        ? Icon(
                            MihIcons.mihIDontKnow,
                            size: 80,
                            color: MihColors.secondary(),
                          )
                        : MihCircleAvatar(
                            imageFile: CachedNetworkImageProvider(
                                MihFileApi.getMinioFileUrlV2(mineSweeperProvider
                                    .leaderboard![index].proPicUrl)),
                            width: 80,
                            expandable: true,
                            editable: false,
                            fileNameController: null,
                            userSelectedfile: null,
                            frameColor: MihColors.primary(),
                            backgroundColor: getMedalColor(index),
                            onChange: null,
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
                            color: MihColors.primary(),
                          ),
                        ),
                        Text(
                          "Score: ${mineSweeperProvider.leaderboard![index].game_score}\nTime: ${mineSweeperProvider.leaderboard![index].game_time}",
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
            );
          },
        );
      },
    );
  }
}
