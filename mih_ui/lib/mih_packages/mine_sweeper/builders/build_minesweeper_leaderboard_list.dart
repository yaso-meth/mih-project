import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
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
    final double width = MediaQuery.sizeOf(context).width;
    return Consumer2<MzansiProfileProvider, MihMineSweeperProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          MihMineSweeperProvider mineSweeperProvider, Widget? child) {
        return ListView.separated(
          separatorBuilder: (BuildContext context, index) {
            return Divider(
              color: MihColors.secondary(),
            );
          },
          itemCount: mineSweeperProvider.leaderboard!.length,
          itemBuilder: (context, index) {
            return FutureBuilder(
                future: mineSweeperProvider.leaderboardUserPicturesUrl[index],
                builder: (context, asyncSnapshot) {
                  ImageProvider<Object>? imageFile;
                  bool loading = true;
                  if (asyncSnapshot.connectionState == ConnectionState.done) {
                    loading = false;
                    if (asyncSnapshot.hasData) {
                      imageFile = asyncSnapshot.requireData != ""
                          ? CachedNetworkImageProvider(
                              asyncSnapshot.requireData)
                          : null;
                    } else {
                      imageFile = null;
                    }
                  } else {
                    imageFile = null;
                  }
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
                        loading
                            ? Icon(
                                MihIcons.mihRing,
                                size: 80,
                                color: MihColors.secondary(),
                              )
                            : imageFile == null
                                ? Icon(
                                    MihIcons.mihIDontKnow,
                                    size: 80,
                                    color: MihColors.secondary(),
                                  )
                                : MihCircleAvatar(
                                    key: UniqueKey(),
                                    imageFile: imageFile,
                                    width: 80,
                                    expandable: true,
                                    editable: false,
                                    fileNameController: null,
                                    userSelectedfile: null,
                                    frameColor: getMedalColor(index),
                                    backgroundColor: MihColors.primary(),
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
                });
          },
        );
      },
    );
  }
}
