import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:provider/provider.dart';

class MihMineSweeperStartGameWindow extends StatefulWidget {
  final void Function()? onPressed;
  const MihMineSweeperStartGameWindow({
    super.key,
    required this.onPressed,
  });

  @override
  State<MihMineSweeperStartGameWindow> createState() =>
      _MihMineSweeperStartGameWindowState();
}

class _MihMineSweeperStartGameWindowState
    extends State<MihMineSweeperStartGameWindow> {
  TextEditingController modeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void applyGameSettings(MihMineSweeperProvider mihMineSweeperProvider) {
    mihMineSweeperProvider.setDifficulty(modeController.text);
    switch (mihMineSweeperProvider.difficulty) {
      case ("Very Easy"):
        mihMineSweeperProvider.setRowCount(6);
        mihMineSweeperProvider.setCoulmnCount(6);
        mihMineSweeperProvider.setTotalMines(5);
        // mihMineSweeperProvider.setRowCount(5);
        // mihMineSweeperProvider.setCoulmnCount(5);
        // mihMineSweeperProvider.setTotalMines(3);
        break;
      case ("Easy"):
        mihMineSweeperProvider.setRowCount(8);
        mihMineSweeperProvider.setCoulmnCount(8);
        mihMineSweeperProvider.setTotalMines(10);
        // mihMineSweeperProvider.setRowCount(10);
        // mihMineSweeperProvider.setCoulmnCount(10);
        // mihMineSweeperProvider.setTotalMines(15);
        break;
      case ("Intermediate"):
        mihMineSweeperProvider.setRowCount(10);
        mihMineSweeperProvider.setCoulmnCount(10);
        mihMineSweeperProvider.setTotalMines(18);
        // mihMineSweeperProvider.setRowCount(15);
        // mihMineSweeperProvider.setCoulmnCount(10);
        // mihMineSweeperProvider.setTotalMines(23);
        break;
      case ("Hard"):
        mihMineSweeperProvider.setRowCount(12);
        mihMineSweeperProvider.setCoulmnCount(10);
        mihMineSweeperProvider.setTotalMines(30);
        // mihMineSweeperProvider.setRowCount(20);
        // mihMineSweeperProvider.setCoulmnCount(10);
        // mihMineSweeperProvider.setTotalMines(30);
        break;
      default:
        break;
    }
  }

  String getModeConfig() {
    switch (modeController.text) {
      case ("Very Easy"):
        return "Columns: 6\nRows: 6\nBombs: 5";
      case ("Easy"):
        return "Columns: 8\nRows: 8\nBombs: 10";
      case ("Intermediate"):
        return "Columns: 10\nRows: 10\nBombs: 18";
      case ("Hard"):
        return "Columns: 10\nRows: 12\nBombs: 30";
      default:
        return "Error";
    }
  }

  void _onModeChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    modeController.removeListener(_onModeChanged);
    modeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    modeController.text = context.read<MihMineSweeperProvider>().difficulty;
    modeController.addListener(_onModeChanged);
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "New Game Settings",
      onWindowTapClose: () {
        context.pop();
      },
      windowBody: Consumer<MihMineSweeperProvider>(
        builder: (BuildContext context,
            MihMineSweeperProvider mihMineSweeperProvider, Widget? child) {
          return Column(
            children: [
              MihForm(
                formKey: _formKey,
                formFields: [
                  MihDropdownField(
                    controller: modeController,
                    hintText: "Difficulty",
                    dropdownOptions: [
                      "Very Easy",
                      "Easy",
                      "Intermediate",
                      "Hard"
                    ],
                    requiredText: true,
                    editable: true,
                    enableSearch: false,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    getModeConfig(),
                    style: TextStyle(
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: MihButton(
                      onPressed: () {
                        applyGameSettings(mihMineSweeperProvider);
                        context.pop();
                        widget.onPressed?.call();
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
          );
        },
      ),
    );
  }
}
