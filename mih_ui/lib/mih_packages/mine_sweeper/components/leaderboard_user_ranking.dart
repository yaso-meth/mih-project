import 'package:flutter/material.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaderboardUserRanking extends StatelessWidget {
  final int index;
  final String proPicUrl;
  final String username;
  final dynamic gameScore;
  final String gameTime;
  final bool isCurrentUser;
  final Future<ImageProvider<Object>?> Function(String) getUserPicture;

  const LeaderboardUserRanking({
    super.key,
    required this.index,
    required this.proPicUrl,
    required this.username,
    required this.gameScore,
    required this.gameTime,
    required this.isCurrentUser,
    required this.getUserPicture,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserPicture(proPicUrl),
      builder: (context, asyncSnapshot) {
        bool isLoading =
            asyncSnapshot.connectionState == ConnectionState.waiting;

        KenLogger.success("URL: ${asyncSnapshot.data.toString()}");
        return Skeletonizer(
          enabled: isLoading,
          enableSwitchAnimation: true,
          effect: ShimmerEffect(
            baseColor: MihColors.highlight(),
            highlightColor: MihColors.secondary(),
          ),
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "#${index + 1}",
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
                const SizedBox(width: 10),
                MihCircleAvatar(
                  key: ValueKey(asyncSnapshot.data
                      .toString()), // Use ValueKey for stable identity
                  imageFile: asyncSnapshot.data,
                  width: 60,
                  expandable: true,
                  editable: false,
                  fileNameController: null,
                  userSelectedfile: null,
                  frameColor: MihColors.secondary(),
                  backgroundColor: MihColors.primary(),
                  onChange: null,
                ),
              ],
            ),
            title: Text(
              "$username${isCurrentUser ? " (You)" : ""}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MihColors.secondary(),
              ),
            ),
            subtitle: Text(
              "Score: $gameScore\nTime: $gameTime",
              style: TextStyle(
                fontSize: 18,
                color: MihColors.secondary(),
              ),
            ),
          ),
        );
      },
    );
  }
}
