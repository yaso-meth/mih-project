import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';

class MihRouteError extends StatefulWidget {
  const MihRouteError({
    super.key,
  });

  @override
  State<MihRouteError> createState() => _MihRouteErrorState();
}

class _MihRouteErrorState extends State<MihRouteError> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      packageActionButton: getErrorAction(),
      packageTools: getErrorTools(),
      packageToolTitles: ["Invalid Path"],
      packageToolBodies: getErrorToolBody(),
      selectedBodyIndex: _selectedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selectedIndex = newValue;
        });
        //print("Index: $_selectedIndex");
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
        _selectedIndex = 0;
      });
    };
    return MihPackageTools(
      tools: temp,
      selectedIndex: _selectedIndex,
    );
  }

  List<Widget> getErrorToolBody() {
    List<Widget> toolBodies = [
      MihPackageToolBody(
        backgroundColor: MihColors.primary(),
        borderOn: true,
        bodyItem: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Oops! Wrong Turn.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MihColors.secondary(),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.link_off_rounded,
              size: 150,
              color: MihColors.secondary(),
            ),
            SizedBox(
              width: 700,
              child: Text(
                "It looks like you've taken a wrong turn and ended up on a package that doesn't exist within the MIH App.\n\nDon't worry, getting back is easy. Just click the button below or the MIH Logo to return to the correct path.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MihColors.secondary(),
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
              buttonColor: MihColors.green(),
              width: 300,
              child: Text(
                "Back to MIH",
                style: TextStyle(
                  color: MihColors.primary(),
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
            //           color: MihColors.red(
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
