import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_banner_ad.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/components/board_square.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/components/mih_mine_sweeper_start_game_window.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/components/mine_tile.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_minesweeper_services.dart';
import 'package:provider/provider.dart';

class MineSweeperGame extends StatefulWidget {
  const MineSweeperGame({super.key});

  @override
  State<MineSweeperGame> createState() => _MineSweeperGameState();
}

class _MineSweeperGameState extends State<MineSweeperGame> {
  List<List<BoardSquare>> board = [];
  bool isGameOver = false;
  bool isGameWon = false;
  int squaresLeft = -1;
  Timer? _timer;
  int _milliseconds = 0;
  bool _isRunning = false;
  static const int millisecondsPerUpdate = 100;

  double timeStringToTotalSeconds(String timeString) {
    try {
      List<String> parts = timeString.split(':');
      if (parts.length != 4) {
        return 0.0;
      }
      double hours = double.parse(parts[0]);
      double minutes = double.parse(parts[1]);
      double seconds = double.parse(parts[2]);
      double milliseconds = double.parse(parts[3]);
      double totalSeconds =
          (hours * 3600) + (minutes * 60) + seconds + (milliseconds / 100);
      return totalSeconds;
    } catch (e) {
      print("Error parsing time string: $e");
      return 0.0;
    }
  }

  double calculateGameScore(MihMineSweeperProvider mihMineSweeperProvider) {
    int scoreConst = 10000;
    double dificusltyMultiplier;
    switch (mihMineSweeperProvider.difficulty) {
      case ("Very Easy"):
        dificusltyMultiplier = 0.5;
        break;
      case ("Easy"):
        dificusltyMultiplier = 1.0;
        break;
      case ("Intermediate"):
        dificusltyMultiplier = 2.5;
        break;
      case ("Hard"):
        dificusltyMultiplier = 5.0;
        break;
      default:
        dificusltyMultiplier = 0.0;
        break;
    }
    double rawScore = (scoreConst * dificusltyMultiplier) /
        timeStringToTotalSeconds(_formatTime());

    String scoreString = rawScore.toStringAsFixed(5);
    return double.parse(scoreString);
  }

  void startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: millisecondsPerUpdate),
        (timer) {
      setState(() {
        _milliseconds += millisecondsPerUpdate; // Increment by the interval
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void resetTimer() {
    stopTimer(); // Stop the timer first
    setState(() {
      _milliseconds = 0; // Reset the time to zero
    });
  }

  String _formatTime() {
    Duration duration = Duration(milliseconds: _milliseconds);
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);
    final int centiseconds = (duration.inMilliseconds.remainder(1000)) ~/ 10;
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    String centiStr = centiseconds.toString().padLeft(2, '0');
    return '$hoursStr:$minutesStr:$secondsStr:$centiStr';
  }

  void showStartGameWindow(
    MihMineSweeperProvider mihMineSweeperProvider,
  ) {
    // easy - 10 * 10 & 15 bombs
    // Intermediate - 10 * 15 & 23 bombs
    // Hard - 10 * 20 & 30 bombs
    showDialog(
        context: context,
        builder: (context) {
          return MihMineSweeperStartGameWindow(
            onPressed: () {
              resetTimer();
              mihMineSweeperProvider
                  .setDifficulty(mihMineSweeperProvider.difficulty);
              setState(() => initializeBoard(mihMineSweeperProvider));
            },
          );
        });
  }

// --- GAME INITIALIZATION LOGIC ---
  void initializeBoard(MihMineSweeperProvider mihMineSweeperProvider) {
    // 1. Create a board of empty squares
    board = List.generate(
      mihMineSweeperProvider.rowCount,
      (i) => List.generate(
        mihMineSweeperProvider.columnCount,
        (j) => BoardSquare(),
      ),
    );
    // 2. Place bombs randomly
    placeBombs(mihMineSweeperProvider);
    // 3. Calculate the number of bombs around each non-mine square
    calculateBombsAround(mihMineSweeperProvider);
    // Reset state variables
    squaresLeft =
        mihMineSweeperProvider.rowCount * mihMineSweeperProvider.columnCount;
    isGameOver = false;
    isGameWon = false;
    // You'd typically add a call to setState here, but it's in initState.
    startTimer();
  }

  void placeBombs(MihMineSweeperProvider mihMineSweeperProvider) {
    final Random random = Random();
    int bombsPlaced = 0;

    while (bombsPlaced < mihMineSweeperProvider.totalMines) {
      int r = random.nextInt(mihMineSweeperProvider.rowCount);
      int c = random.nextInt(mihMineSweeperProvider.columnCount);

      if (!board[r][c].hasBomb) {
        board[r][c].hasBomb = true;
        bombsPlaced++;
      }
    }
  }

  void calculateBombsAround(MihMineSweeperProvider mihMineSweeperProvider) {
    for (int r = 0; r < mihMineSweeperProvider.rowCount; r++) {
      for (int c = 0; c < mihMineSweeperProvider.columnCount; c++) {
        if (!board[r][c].hasBomb) {
          int count = 0;

          // Check the 8 neighbors
          for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
              if (i == 0 && j == 0) continue; // Skip the current square

              int neighborR = r + i;
              int neighborC = c + j;

              // Check if neighbor is within bounds
              if (neighborR >= 0 &&
                  neighborR < mihMineSweeperProvider.rowCount &&
                  neighborC >= 0 &&
                  neighborC < mihMineSweeperProvider.columnCount) {
                if (board[neighborR][neighborC].hasBomb) {
                  count++;
                }
              }
            }
          }
          board[r][c].bombsAround = count;
        }
      }
    }
  }

  // Handles recursive opening of zero-squares
  void _expandZeros(
      MihMineSweeperProvider mihMineSweeperProvider, int r, int c) {
    if (r < 0 ||
        r >= mihMineSweeperProvider.rowCount ||
        c < 0 ||
        c >= mihMineSweeperProvider.columnCount ||
        board[r][c].isOpened) {
      return;
    }

    BoardSquare square = board[r][c];

    // Open the current square
    square.isOpened = true;
    squaresLeft--;

    // If it's a zero square, recursively call for neighbors
    if (square.bombsAround == 0) {
      // Check all 8 neighbors (not just 4 sides, for standard Minesweeper expansion)
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          _expandZeros(mihMineSweeperProvider, r + i, c + j);
        }
      }
    }
  }

  Future<void> handleTap(MzansiProfileProvider profileProvider,
      MihMineSweeperProvider mihMineSweeperProvider, int r, int c) async {
    if (isGameOver || board[r][c].isOpened || board[r][c].isFlagged) {
      return;
    }
    // 1. Check for bomb (LOSS)
    if (board[r][c].hasBomb) {
      stopTimer();
      setState(() {
        board[r][c].isOpened = true;
        isGameOver = true;
        // lose alert
        showDialog(
          context: context,
          builder: (context) {
            return MihPackageAlert(
              alertIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  FontAwesomeIcons.bomb,
                  color: MihColors.getRedColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  size: 100,
                ),
              ),
              alertTitle: "Better Luck Next Time",
              alertBody: Column(
                children: [
                  Text(
                    "Your lost this game of MIH Minesweeper!!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please feel free to start a New Game or check out the Leader Board to find out who's the best in Mzansi.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      MihButton(
                        onPressed: () {
                          context.pop();
                          showStartGameWindow(mihMineSweeperProvider);
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "New Game",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MihButton(
                        onPressed: () {
                          context.pop();
                          mihMineSweeperProvider.setToolIndex(1);
                        },
                        buttonColor: MihColors.getOrangeColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "Leader Board",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              alertColour: MihColors.getRedColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            );
          },
        );
      });
      return;
    }
    // 2. Open square and handle expansion (RECURSION)
    if (board[r][c].bombsAround == 0) {
      // Start recursive expansion
      _expandZeros(mihMineSweeperProvider, r, c);
    } else {
      // Just open the single square
      board[r][c].isOpened = true;
      squaresLeft--;
    }
    // 3. Check for win
    _checkWinCondition(profileProvider, mihMineSweeperProvider);
    // Update the UI
    setState(() {});
  }

  void handleLongPress(int r, int c) {
    if (isGameOver || board[r][c].isOpened) {
      return;
    }
    setState(() {
      // Toggle the flag status
      board[r][c].isFlagged = !board[r][c].isFlagged;
    });
  }

  // --- GAME ACTION LOGIC ---
  Future<void> _checkWinCondition(
    MzansiProfileProvider profileProvider,
    MihMineSweeperProvider mihMineSweeperProvider,
  ) async {
    // Game is won if all non-mine squares are opened.
    if (squaresLeft <= mihMineSweeperProvider.totalMines) {
      stopTimer();
      isGameWon = true;
      isGameOver = true;
      // win alert
      showDialog(
        context: context,
        builder: (context) {
          return MihPackageAlert(
            alertIcon: Icon(
              Icons.celebration,
              color: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              size: 100,
            ),
            alertTitle: "Congratulations",
            alertBody: Column(
              children: [
                Text(
                  "Your won this game of MIH Minesweeper!!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
                const SizedBox(height: 10),
                // Text(
                //   "You took ${_formatTime()} to complete the game on ${mihMineSweeperProvider.difficulty} mode.",
                //   style: TextStyle(
                //     fontSize: 15,
                //     color: MihColors.getSecondaryColor(
                //         MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                //   ),
                // ),
                // const SizedBox(height: 10),
                Text(
                  "Time Taken: ${_formatTime().replaceAll("00:", "")}",
                  style: TextStyle(
                    fontSize: 20,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Score: ${calculateGameScore(mihMineSweeperProvider)}",
                  style: TextStyle(
                    fontSize: 20,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    MihButton(
                      onPressed: () {
                        context.pop();
                        showStartGameWindow(mihMineSweeperProvider);
                      },
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        "New Game",
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MihButton(
                      onPressed: () {
                        context.pop();
                        mihMineSweeperProvider.setToolIndex(1);
                      },
                      buttonColor: MihColors.getOrangeColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        "Leader Board",
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            alertColour: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          );
        },
      );
      showDialog(
          context: context,
          builder: (context) {
            return Mihloadingcircle(
              message: "Uploading your score",
            );
          });
      await MihMinesweeperServices().addPlayerScore(
        profileProvider,
        mihMineSweeperProvider,
        _formatTime().replaceAll("00:", ""),
        calculateGameScore(mihMineSweeperProvider),
      );
      context.pop();
    }
  }

  Color? getDifficultyColor(MihMineSweeperProvider mihMineSweeperProvider) {
    String mode = mihMineSweeperProvider.difficulty;
    switch (mode) {
      case "Very Easy":
        return MihColors.getGreenColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark",
        );
      case "Easy":
        return MihColors.getGreenColor(
          MzansiInnovationHub.of(context)!.theme.mode != "Dark",
        );
      case "Intermediate":
        return MihColors.getOrangeColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark",
        );
      case "Hard":
        return MihColors.getRedColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark",
        );
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // UBongani was here during the MIH Live
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return Consumer2<MzansiProfileProvider, MihMineSweeperProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          MihMineSweeperProvider mihMineSweeperProvider, Widget? child) {
        return Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  MihSingleChildScroll(
                    child: board.isEmpty && squaresLeft < 0
                        // Start Up Message before setting up game
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 50),
                                Icon(
                                  MihIcons.mineSweeper,
                                  size: 165,
                                  color: MihColors.getSecondaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Welcom to Minesweeper, the first game of MIH.",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: MihColors.getSecondaryColor(
                                        MzansiInnovationHub.of(context)!
                                                .theme
                                                .mode ==
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
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: Icon(
                                            Icons.menu,
                                            size: 20,
                                            color: MihColors.getSecondaryColor(
                                                MzansiInnovationHub.of(context)!
                                                        .theme
                                                        .mode ==
                                                    "Dark"),
                                          ),
                                        ),
                                        TextSpan(
                                            text:
                                                " to start a new game or learn how to play the minesweeper."),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        // Display Game Board when game started
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Display game status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        'Mines: ${mihMineSweeperProvider.totalMines}',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        _formatTime().replaceAll("00:", ""),
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                mihMineSweeperProvider.difficulty,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: getDifficultyColor(
                                      mihMineSweeperProvider),
                                ),
                              ),

                              // const SizedBox(
                              //   height: 30,
                              // ),
                              // The Board Grid
                              SizedBox(
                                width: mihMineSweeperProvider.columnCount *
                                    40.0, // Control size based on columns
                                height: mihMineSweeperProvider.rowCount *
                                    40.0, // Control size based on rows
                                child: GridView.builder(
                                  physics:
                                      const NeverScrollableScrollPhysics(), // Prevent scrolling
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        mihMineSweeperProvider.columnCount,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 0,
                                  ),
                                  itemCount: mihMineSweeperProvider.rowCount *
                                      mihMineSweeperProvider.columnCount,
                                  itemBuilder: (context, index) {
                                    int r = index ~/
                                        mihMineSweeperProvider
                                            .columnCount; // Integer division for row
                                    int c = index %
                                        mihMineSweeperProvider
                                            .columnCount; // Remainder for column

                                    return MineTile(
                                      square: board[r][c],
                                      onTap: () => handleTap(profileProvider,
                                          mihMineSweeperProvider, r, c),
                                      onLongPress: () => handleLongPress(r, c),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 30),
                              // const SizedBox(height: 100),
                            ],
                          ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: MihFloatingMenu(
                        animatedIcon: AnimatedIcons.menu_close,
                        children: [
                          SpeedDialChild(
                            child: Icon(
                              Icons.rule_rounded,
                              color: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                            ),
                            label: "Learn how to play",
                            labelBackgroundColor: MihColors.getGreenColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            labelStyle: TextStyle(
                              color: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: MihColors.getGreenColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            onTap: () {
                              mihMineSweeperProvider.setToolIndex(3);
                            },
                          ),
                          SpeedDialChild(
                            child: Icon(
                              Icons.add,
                              color: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                            ),
                            label: "Start New Game",
                            labelBackgroundColor: MihColors.getGreenColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            labelStyle: TextStyle(
                              color: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: MihColors.getGreenColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            onTap: () {
                              showStartGameWindow(mihMineSweeperProvider);
                            },
                          ),
                        ]),
                  )
                ],
              ),
            ),
            _timer != null ? MihBannerAd() : SizedBox(),
            SizedBox(height: 15),
          ],
        );
      },
    );
  }
}
