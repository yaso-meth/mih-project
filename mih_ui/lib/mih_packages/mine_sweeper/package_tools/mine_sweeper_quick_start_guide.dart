import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MineSweeperQuickStartGuide extends StatefulWidget {
  const MineSweeperQuickStartGuide({super.key});

  @override
  State<MineSweeperQuickStartGuide> createState() =>
      _MineSweeperQuickStartGuideState();
}

class _MineSweeperQuickStartGuideState
    extends State<MineSweeperQuickStartGuide> {
  double titleSize = 22.0;
  double subtitleSize = 20.0;
  double pointsSize = 18.0;

  Widget sectionOne() {
    return Container(
      decoration: BoxDecoration(
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode != "Darl"),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Title
            Text(
              "1. Two Main Actions\n(Your Controls)",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            const SizedBox(height: 8),
            //Part One
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Quick Tap (or Click): This is the Dig action.',
                    style: TextStyle(
                      color: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode !=
                              "Dark"),
                      fontWeight: FontWeight.bold,
                      fontSize: subtitleSize,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '• Goal:',
                        style: TextStyle(
                          color: MihColors.getGreenColor(
                              MzansiInnovationHub.of(context)!.theme.mode !=
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: ' To uncover a square and see a number clue.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '• Risk:',
                        style: TextStyle(
                          color: MihColors.getRedColor(
                              MzansiInnovationHub.of(context)!.theme.mode !=
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: ' If you click a mine, the game ends!',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            //Part Two
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text:
                        'Tap and Hold (or Long Press): This is the Flag action (🚩).',
                    style: TextStyle(
                      color: MihColors.getRedColor(
                          MzansiInnovationHub.of(context)!.theme.mode !=
                              "Dark"),
                      fontWeight: FontWeight.bold,
                      fontSize: subtitleSize,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '• Goal:',
                        style: TextStyle(
                          color: MihColors.getGreenColor(
                              MzansiInnovationHub.of(context)!.theme.mode !=
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: ' To safely mark a square that you are',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: ' certain',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: ' is a mine.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '• Risk:',
                        style: TextStyle(
                          color: MihColors.getRedColor(
                              MzansiInnovationHub.of(context)!.theme.mode !=
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' Accidental placement of flags will cause confusion.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '• Benefit:',
                        style: TextStyle(
                          color: MihColors.getGreenColor(
                              MzansiInnovationHub.of(context)!.theme.mode !=
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' You cannot accidentally click a square that is flagged.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTwo() {
    return Container(
      decoration: BoxDecoration(
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode != "Darl"),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Title
            Text(
              "2. The Golden Rule\n(Reading the Numbers)",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            const SizedBox(height: 8),
            //Part One
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text:
                        'The number tells you exactly how many mines are touching that square (including sides and corners).',
                    style: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontWeight: FontWeight.normal,
                      fontSize: subtitleSize,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "• If you see a Blank Space (a '0'):",
                        style: TextStyle(
                          color: MihColors.getOrangeColor(
                              MzansiInnovationHub.of(context)!.theme.mode !=
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: " Zero (0) ",
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' mines are touching it. All surrounding squares are safe, and the game will open them for you automatically.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "• If you see a '1':",
                        style: TextStyle(
                          color: MihColors.getOrangeColor(
                              MzansiInnovationHub.of(context)!.theme.mode !=
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: ' Only ',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: 'one',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' mine is touching this square. You must find and flag that single mine.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "• If you see a '3':",
                        style: TextStyle(
                          color: MihColors.getOrangeColor(
                              MzansiInnovationHub.of(context)!.theme.mode !=
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: " Three ",
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text:
                            'mines are touching this square. You must find and flag all three.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionThree() {
    return Container(
      decoration: BoxDecoration(
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode != "Darl"),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Title
            Text(
              "3. The Winning Strategy\n(The Deduction Loop)",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            const SizedBox(height: 8),
            //Part One
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text:
                        'The game is won by uncovering every single safe square and correctly flagging all the mines. Use this two-step loop to clear the board:',
                    style: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontWeight: FontWeight.normal,
                      fontSize: subtitleSize,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'A. Find the Mines (Where to Flag 🚩)',
                    style: TextStyle(
                      color: MihColors.getPurpleColor(
                          MzansiInnovationHub.of(context)!.theme.mode !=
                              "Dark"),
                      fontWeight: FontWeight.bold,
                      fontSize: subtitleSize,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '• Goal:',
                        style: TextStyle(
                          color: MihColors.getGreenColor(
                              MzansiInnovationHub.of(context)!.theme.mode !=
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' Look for a number that only has one choice for a mine. e.g. If a \'1\' is touching only one hidden square, that hidden square',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: ' must ',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: 'be the mine.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '• Action:',
                        style: TextStyle(
                          color: MihColors.getRedColor(
                              MzansiInnovationHub.of(context)!.theme.mode !=
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: ' Tap and Hold to place a',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: ' Flag ',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: 'on the square you are sure is a mine.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            //Part Two
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'B. Find the Safe Squares (Where to Dig)',
                    style: TextStyle(
                      color: MihColors.getPurpleColor(
                          MzansiInnovationHub.of(context)!.theme.mode !=
                              "Dark"),
                      fontWeight: FontWeight.bold,
                      fontSize: subtitleSize,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '• Goal:',
                        style: TextStyle(
                          color: MihColors.getGreenColor(
                              MzansiInnovationHub.of(context)!.theme.mode !=
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' Look for a number that has been \'satisfied\' by your flags. e.g. You see a \'2\' and you have already placed two 🚩 flags touching it. The \'2\' is satisfied.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '• Action:',
                        style: TextStyle(
                          color: MihColors.getRedColor(
                              MzansiInnovationHub.of(context)!.theme.mode !=
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' Quick Tap any of the remaining hidden squares touching that \'satisfied\' number. They',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text: ' must be safe ',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text:
                            'because the mine requirement has already been met.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionFour() {
    return Container(
      decoration: BoxDecoration(
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode != "Darl"),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Title
            Text(
              "✨ Key Beginner Tips",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "• Start on the Edges and Corners: ",
                        style: TextStyle(
                          color: MihColors.getBronze(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Numbers on the edge or corner of the board are easier to solve because they have fewer surrounding squares to check.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "• Don't Guess: ",
                        style: TextStyle(
                          color: MihColors.getBronze(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.bold,
                          fontSize: pointsSize,
                        ),
                      ),
                      TextSpan(
                        text:
                            'If you are down to two squares and either one could be the mine, look somewhere else on the board for a guaranteed, safe move.',
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.normal,
                          fontSize: pointsSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(width),
    );
  }

  Widget getBody(double width) {
    return MihSingleChildScroll(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 20),
        child: Column(
          children: [
            const Text(
              'Simple Rules and Strategy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Minesweeper is a puzzle game where you use numbers to figure out where the hidden bombs (mines) are located.',
              style: TextStyle(fontSize: 18),
            ),
            // const Divider(height: 30),
            const SizedBox(height: 15),
            sectionOne(),
            const SizedBox(height: 15),
            sectionTwo(),
            const SizedBox(height: 15),
            sectionThree(),
            const SizedBox(height: 15),
            sectionFour(),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
