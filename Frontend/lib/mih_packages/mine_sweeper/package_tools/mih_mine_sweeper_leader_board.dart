import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/builders/build_minesweeper_leaderboard_list.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_minesweeper_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihMineSweeperLeaderBoard extends StatefulWidget {
  const MihMineSweeperLeaderBoard({super.key});

  @override
  State<MihMineSweeperLeaderBoard> createState() =>
      _MihMineSweeperLeaderBoardState();
}

class _MihMineSweeperLeaderBoardState extends State<MihMineSweeperLeaderBoard> {
  TextEditingController filterController = TextEditingController();
  bool isLoading = true;
  Future<void> initialiseLeaderboard() async {
    MihMineSweeperProvider mineSweeperProvider =
        context.read<MihMineSweeperProvider>();
    filterController.text = mineSweeperProvider.difficulty;
    KenLogger.success("getting data");
    await MihMinesweeperServices().getTop20Leaderboard(mineSweeperProvider);
    List<ImageProvider<Object>?> userPictures = [];
    String userPicUrl = "";
    for (final ranking in mineSweeperProvider.leaderboard!) {
      userPicUrl = await MihFileApi.getMinioFileUrl(ranking.proPicUrl);
      userPictures.add(CachedNetworkImageProvider(userPicUrl));
    }
    mineSweeperProvider.setLeaderboardUserPictures(
        leaderboardUserPictures: userPictures);
    setState(() {
      isLoading = false;
    });
  }

  void refreshLeaderBoard(
      MihMineSweeperProvider mineSweeperProvider, String difficulty) {
    setState(() {
      isLoading = true;
    });
    mineSweeperProvider.setDifficulty(difficulty);
    mineSweeperProvider.setLeaderboard(leaderboard: null);
    mineSweeperProvider.setMyScoreboard(myScoreboard: null);
    initialiseLeaderboard();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initialiseLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Consumer<MihMineSweeperProvider>(
      builder: (BuildContext context,
          MihMineSweeperProvider mineSweeperProvider, Widget? child) {
        return RefreshIndicator(
          onRefresh: () async {
            refreshLeaderBoard(mineSweeperProvider, filterController.text);
          },
          child: MihPackageToolBody(
            borderOn: false,
            bodyItem: getBody(width),
          ),
        );
      },
    );
  }

  Widget getBody(double width) {
    return Consumer<MihMineSweeperProvider>(
      builder: (BuildContext context,
          MihMineSweeperProvider mineSweeperProvider, Widget? child) {
        if (isLoading) {
          return Center(
            child: Mihloadingcircle(),
          );
        } else {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: MihDropdownField(
                        controller: filterController,
                        hintText: "Leaderboards",
                        dropdownOptions: const [
                          "Very Easy",
                          "Easy",
                          "Intermediate",
                          "Hard",
                        ],
                        requiredText: true,
                        editable: true,
                        enableSearch: false,
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                        onSelected: (selection) {
                          refreshLeaderBoard(mineSweeperProvider, selection!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              !isLoading && mineSweeperProvider.leaderboard!.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          Icon(
                            MihIcons.mineSweeper,
                            size: 165,
                            color: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Be the first on the leaderboard.",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: MihColors.getSecondaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: MihColors.getSecondaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                                ),
                                children: [
                                  TextSpan(text: "Press "),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      FontAwesomeIcons.bomb,
                                      size: 20,
                                      color: MihColors.getSecondaryColor(
                                          MzansiInnovationHub.of(context)!
                                                  .theme
                                                  .mode ==
                                              "Dark"),
                                    ),
                                  ),
                                  TextSpan(text: " and start a new game"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(child: BuildMinesweeperLeaderboardList()),
            ],
          );
        }
      },
    );
  }
}
