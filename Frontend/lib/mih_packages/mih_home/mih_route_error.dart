import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihRouteError extends StatefulWidget {
  const MihRouteError({
    super.key,
  });

  @override
  State<MihRouteError> createState() => _MihRouteErrorState();
}

class _MihRouteErrorState extends State<MihRouteError> {
  int _selcetedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getErrorAction(),
      appTools: getErrorTools(),
      appToolTitles: ["Invalid Path"],
      appBody: getErrorToolBody(),
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
      icon: const Icon(MihIcons.mihLogo),
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
    temp[const Icon(Icons.link_off_rounded)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getErrorToolBody() {
    List<Widget> toolBodies = [
      MihPackageToolBody(
        borderOn: true,
        bodyItem: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Oops! Wrong Turn.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.link_off_rounded,
              size: 150,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            SizedBox(
              width: 700,
              child: Text(
                "It looks like you've taken a wrong turn and ended up on a package that doesn't exist within the MIH App.\n\nDon't worry, getting back is easy. Just click the button below or the MIH Logo to return to the correct path.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
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
                "Back to MIH",
                style: TextStyle(
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // const SizedBox(height: 15),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: SizedBox(
            //     width: 500,
            //     child: SelectionArea(
            //       child: Text(
            //         "Error: $error",
            //         textAlign: TextAlign.left,
            //         style: TextStyle(
            //           color: MihColors.getRedColor(
            //               MzansiInnovationHub.of(context)!.theme.mode ==
            //                   "Dark"),
            //           fontSize: 15,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      )
    ];
    return toolBodies;
  }
}
