import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/components/board_square.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/components/mine_tile.dart';
import 'package:provider/provider.dart';

class MineSweeperGame extends StatefulWidget {
  const MineSweeperGame({super.key});

  @override
  State<MineSweeperGame> createState() => _MineSweeperGameState();
}

class _MineSweeperGameState extends State<MineSweeperGame> {
  TextEditingController modeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<List<BoardSquare>> board = [];
  bool isGameOver = false;
  bool isGameWon = false;
  int squaresLeft = -1;
  bool _isFirstLoad = true;

  void showStartGameWindow(MihMineSweeperProvider mihMineSweeperProvider) {
    showDialog(
        context: context,
        builder: (context) {
          return MihPackageWindow(
            fullscreen: false,
            windowTitle: "New Game Settings",
            onWindowTapClose: () {
              context.pop();
            },
            windowBody: Column(
              children: [
                MihForm(
                  formKey: _formKey,
                  formFields: [
                    MihDropdownField(
                      controller: modeController,
                      hintText: "Difficulty",
                      dropdownOptions: ["Easy", "Normal", "Hard"],
                      requiredText: true,
                      editable: true,
                      enableSearch: false,
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: MihButton(
                        onPressed: () {
                          setState(
                              () => initializeBoard(mihMineSweeperProvider));
                          Navigator.of(context).pop();
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "Start Game",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

  void handleTap(MihMineSweeperProvider mihMineSweeperProvider, int r, int c) {
    if (isGameOver || board[r][c].isOpened || board[r][c].isFlagged) {
      return;
    }
    // 1. Check for bomb (LOSS)
    if (board[r][c].hasBomb) {
      setState(() {
        board[r][c].isOpened = true;
        isGameOver = true;
        // lose alert
        showDialog(
          context: context,
          builder: (context) {
            return MihPackageAlert(
              alertIcon: Icon(
                FontAwesomeIcons.bomb,
                color: MihColors.getRedColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                size: 100,
              ),
              alertTitle: "Better Luck Next Time",
              alertBody: Column(
                children: [
                  Text(
                    "Your lost this game of MIH MineSweeper!!!",
                    style: TextStyle(
                      fontSize: 15,
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
                          setState(
                              () => initializeBoard(mihMineSweeperProvider));
                          Navigator.of(context).pop();
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
    _checkWinCondition(mihMineSweeperProvider);
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
  void _checkWinCondition(MihMineSweeperProvider mihMineSweeperProvider) {
    // Game is won if all non-mine squares are opened.
    if (squaresLeft <= mihMineSweeperProvider.totalMines) {
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
            alertTitle: "Congradulations",
            alertBody: Column(
              children: [
                Text(
                  "Your won this game of MIH MineSweeper!!!",
                  style: TextStyle(
                    fontSize: 15,
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
                        setState(() => initializeBoard(mihMineSweeperProvider));
                        Navigator.of(context).pop();
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
                  ],
                ),
              ],
            ),
            alertColour: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          );
        },
      );
    }
  }

  Color? getDifficultyColor() {
    String mode = modeController.text;
    switch (mode) {
      case "Easy":
        return MihColors.getGreenColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark",
        );
      case "Normal":
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
  void initState() {
    super.initState();
    modeController.text = "Easy";
    // showStartGameWindow(context.read<MihMineSweeperProvider>());
    // initializeBoard();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This method is safe for calling showDialog or reading provider values.
    if (_isFirstLoad) {
      // 1. Get the provider safely.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final mihMineSweeperProvider = context.read<MihMineSweeperProvider>();
        // board = List.generate(
        //   mihMineSweeperProvider.rowCount,
        //   (i) => List.generate(
        //     mihMineSweeperProvider.columnCount,
        //     (j) => BoardSquare(),
        //   ),
        // );
        // 2. Show the dialog to get initial game settings.
        // The user selection in the dialog will call initializeBoard().
        showStartGameWindow(mihMineSweeperProvider);
      });
      // 3. Set flag to prevent showing the dialog on subsequent dependency changes
      _isFirstLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MihMineSweeperProvider>(
      builder: (BuildContext context,
          MihMineSweeperProvider mihMineSweeperProvider, Widget? child) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            MihSingleChildScroll(
              child: board.isEmpty && squaresLeft < 0
                  // Start Up Message before setting up game
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
                            "Welcom to MIH MineSweeper, the first game of MIH.",
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
                                      Icons.menu,
                                      size: 20,
                                      color: MihColors.getSecondaryColor(
                                          MzansiInnovationHub.of(context)!
                                                  .theme
                                                  .mode ==
                                              "Dark"),
                                    ),
                                  ),
                                  TextSpan(text: " to start a new game."),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
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
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  modeController.text,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: getDifficultyColor(),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                                onTap: () =>
                                    handleTap(mihMineSweeperProvider, r, c),
                                onLongPress: () => handleLongPress(r, c),
                              );
                            },
                          ),
                        ),
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
                        Icons.add,
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                      label: board.isEmpty && squaresLeft < 0
                          ? "Start Game"
                          : "Reset Game",
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
                    )
                  ]),
            )
          ],
        );
      },
    );
  }
}
