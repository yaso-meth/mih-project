import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MineSweeperQuickStartGuide extends StatefulWidget {
  const MineSweeperQuickStartGuide({super.key});

  @override
  State<MineSweeperQuickStartGuide> createState() =>
      _MineSweeperQuickStartGuideState();
}

class _MineSweeperQuickStartGuideState
    extends State<MineSweeperQuickStartGuide> {
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      ),
    );
  }

  Widget _buildRulePoint({
    required String title,
    required List<String> points,
    required Color color,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          ...points
              .map((point) => Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '• $point',
                      style: TextStyle(
                        fontSize: 16,
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildNumberClue(String clue, String explanation) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('• ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 16,
                    color: MihColors.getOrangeColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark")),
                children: <TextSpan>[
                  TextSpan(
                      text: 'If you see a $clue: ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: explanation),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyPoint(String title, String explanation,
      {bool isAction = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                  fontSize: 16,
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark")),
              children: <TextSpan>[
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontWeight: isAction ? FontWeight.bold : FontWeight.normal,
                    color: isAction
                        ? MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode !=
                                "Dark")
                        : MihColors.getPurpleColor(
                            MzansiInnovationHub.of(context)!.theme.mode !=
                                "Dark"),
                  ),
                ),
                TextSpan(text: isAction ? ' $explanation' : ': $explanation'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipPoint(String title, String explanation) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('• ',
              style: TextStyle(
                  fontSize: 18,
                  color: MihColors.getBronze(
                      MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
                  fontWeight: FontWeight.bold)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 16,
                    color: MihColors.getBronze(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark")),
                children: <TextSpan>[
                  TextSpan(
                      text: title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: explanation),
                ],
              ),
            ),
          ),
        ],
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
              style: TextStyle(fontSize: 16),
            ),
            // const Divider(height: 30),
            const SizedBox(height: 15),
            // --- 1. Two Main Actions ---
            Container(
              decoration: BoxDecoration(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode != "Darl"),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildSectionTitle('1. Two Main Actions (Your Controls)'),
                  const SizedBox(height: 8),
                  _buildRulePoint(
                    title: 'Quick Tap (or Click): This is the Dig action.',
                    points: [
                      'Goal: To uncover a square and see a number clue.',
                      'Risk: If you click a mine, the game ends!',
                    ],
                    color: MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
                  ),
                  _buildRulePoint(
                    title:
                        'Tap and Hold (or Long Press): This is the Flag action (🚩).',
                    points: [
                      'Goal: To safely mark a square that you are **certain** is a mine.',
                      'Benefit: You cannot accidentally click a square that is flagged.',
                    ],
                    color: MihColors.getRedColor(
                        MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // --- 2. The Golden Rule: Reading the Numbers ---
            Container(
              decoration: BoxDecoration(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode != "Darl"),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildSectionTitle('2. The Golden Rule: Reading the Numbers'),
                  const SizedBox(height: 8),
                  Text(
                    'The number tells you exactly how many mines are touching that square (including sides and corners).',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode !=
                              "Darl"),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildNumberClue('Blank Space (a \'0\')',
                      'Zero (0) mines are touching it. All surrounding squares are safe, and the game will open them for you automatically.'),
                  _buildNumberClue('\'1\'',
                      'Only **one** mine is touching this square. You must find and flag that single mine.'),
                  _buildNumberClue('\'3\'',
                      'Three mines are touching this square. You must find and flag all three.'),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // --- 3. The Winning Strategy ---
            Container(
              decoration: BoxDecoration(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode != "Darl"),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildSectionTitle(
                      '3. The Winning Strategy (The Deduction Loop)'),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'The game is won by uncovering every single safe square and correctly flagging all the mines. Use this two-step loop to clear the board:',
                      style: TextStyle(
                        fontSize: 18,
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode !=
                                "Darl"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSubSectionTitle('A. Find the Mines (Where to Flag 🚩)'),
                  _buildStrategyPoint(
                      'Look for a number that only has one choice for a mine.',
                      'Example: If a \'1\' is touching only one hidden square, that hidden square **must** be the mine.'),
                  _buildStrategyPoint('Action:',
                      'Tap and Hold to place a **Flag** on the square you are sure is a mine.',
                      isAction: true),
                  const SizedBox(height: 12),
                  _buildSubSectionTitle(
                      'B. Find the Safe Squares (Where to Dig)'),
                  _buildStrategyPoint(
                      'Look for a number that has been \'satisfied\' by your flags.',
                      'Example: You see a \'2\'. You have already placed two 🚩 flags touching it. The \'2\' is satisfied.'),
                  _buildStrategyPoint('Action:',
                      'Quick Tap any of the remaining hidden squares touching that \'satisfied\' number. They **must be safe** because the mine requirement has already been met.',
                      isAction: true),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // --- Key Beginner Tip ---
            Container(
              decoration: BoxDecoration(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode != "Darl"),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildSectionTitle('✨ Key Beginner Tips'),
                  const SizedBox(height: 8),
                  _buildTipPoint('Start on the Edges and Corners:',
                      'Numbers on the edge or corner of the board are easier to solve because they have fewer surrounding squares to check.'),
                  _buildTipPoint('Don\'t Guess:',
                      'If you are down to two squares and either one could be the mine, look somewhere else on the board for a guaranteed, safe move.'),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
