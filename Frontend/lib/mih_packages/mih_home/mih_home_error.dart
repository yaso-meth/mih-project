import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihHomeError extends StatefulWidget {
  final String errorMessage;
  const MihHomeError({
    super.key,
    required this.errorMessage,
  });

  @override
  State<MihHomeError> createState() => _MihHomeErrorState();
}

class _MihHomeErrorState extends State<MihHomeError> {
  int _selcetedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getErrorAction(),
      appTools: getErrorTools(),
      appToolTitles: ["Connection Error"],
      appBody: getErrorToolBody(widget.errorMessage),
      selectedbodyIndex: _selcetedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selcetedIndex = newValue;
        });
        //print("Index: $_selcetedIndex");
      },
    );
  }

  MihPackageAction getErrorAction() {
    return MihPackageAction(
      icon: const Icon(Icons.refresh),
      iconSize: 35,
      onTap: () {
        context.goNamed(
          'mihHome',
          extra: true,
        );
      },
    );
  }

  MihPackageTools getErrorTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.power_off_outlined)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getErrorToolBody(String error) {
    List<Widget> toolBodies = [
      MihPackageToolBody(
        borderOn: true,
        bodyItem: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Connection Error",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.power_off_outlined,
              size: 150,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            SizedBox(
              width: 500,
              child: Text(
                "Looks like we ran into an issue getting your data.\nPlease check you internet connection and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            MihButton(
              onPressed: () {
                context.goNamed(
                  'mihHome',
                  extra: true,
                );
              },
              buttonColor: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              width: 300,
              child: Text(
                "Refresh",
                style: TextStyle(
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 500,
                child: SelectionArea(
                  child: Text(
                    "Error: $error",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: MihColors.getRedColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ];
    return toolBodies;
  }
}
