import 'package:flutter/material.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:redacted/redacted.dart';

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
        return ListTile(
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
            "$username${isCurrentUser ? " (You)" : ""}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
          ).redacted(context: context, redact: isLoading),
          subtitle: Text(
            "Score: $gameScore\nTime: $gameTime",
            style: TextStyle(
              fontSize: 18,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
          ).redacted(context: context, redact: isLoading),
        );
      },
    );
  }
}
