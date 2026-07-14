import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/builders/build_my_scoreboard_list.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MyScoreBoard extends StatefulWidget {
  const MyScoreBoard({super.key});

  @override
  State<MyScoreBoard> createState() => _MihMineSweeperLeaderBoardState();
}

class _MihMineSweeperLeaderBoardState extends State<MyScoreBoard> {
  TextEditingController filterController = TextEditingController();

  void refreshLeaderBoard(MzansiProfileProvider profileProvider,
      MihMineSweeperProvider mineSweeperProvider, String difficulty) {
    mineSweeperProvider.setDifficulty(difficulty);
    mineSweeperProvider.syncWithMihServerData(
        profileProvider, mineSweeperProvider);
  }

  @override
  void initState() {
    super.initState();
    MihMineSweeperProvider mineSweeperProvider =
        context.read<MihMineSweeperProvider>();
    filterController.text = mineSweeperProvider.difficulty;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Consumer2<MzansiProfileProvider, MihMineSweeperProvider>(
      builder: (
        BuildContext context,
        MzansiProfileProvider profileProvider,
        MihMineSweeperProvider mineSweeperProvider,
        Widget? child,
      ) {
        return RefreshIndicator(
          onRefresh: () async {
            refreshLeaderBoard(
                profileProvider, mineSweeperProvider, filterController.text);
          },
          child: MihPackageToolBody(
            backgroundColor: MihColors.primary(),
            borderOn: false,
            bodyItem: getBody(width),
          ),
        );
      },
    );
  }

  Widget getBody(double width) {
    return Consumer2<MzansiProfileProvider, MihMineSweeperProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          MihMineSweeperProvider mineSweeperProvider, Widget? child) {
        if (mineSweeperProvider.myScoreboard == null) {
          return Center(
            child: Mihloadingcircle(),
          );
        } else {
          return Column(
            children: [
              Center(
                child: MihCircleAvatar(
                  imageFile: profileProvider.userProfilePicture,
                  width: 150,
                  expandable: true,
                  editable: false,
                  fileNameController: null,
                  userSelectedfile: null,
                  frameColor: MihColors.secondary(),
                  backgroundColor: MihColors.primary(),
                  onChange: (selectedImage) {},
                  key: ValueKey(profileProvider.userProfilePicUrl),
                ),
              ),
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
                        hintText: "Scoreboards",
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
                          refreshLeaderBoard(
                              profileProvider, mineSweeperProvider, selection!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              mineSweeperProvider.myScoreboard!.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          Icon(
                            MihIcons.mihMinesweeper,
                            size: 165,
                            color: MihColors.secondary(),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "You have played and ${mineSweeperProvider.difficulty} yet.",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: MihColors.secondary(),
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
                                  color: MihColors.secondary(),
                                ),
                                children: [
                                  TextSpan(text: "Press "),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      MihIcons.minesweeper,
                                      size: 20,
                                      color: MihColors.secondary(),
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
                  : Expanded(child: BuildMyScoreBoardList()),
            ],
          );
        }
      },
    );
  }
}
