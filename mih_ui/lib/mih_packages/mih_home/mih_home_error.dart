import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';

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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      packageActionButton: getErrorAction(),
      packageTools: getErrorTools(),
      packageToolTitles: ["Connection Error"],
      packageToolBodies: getErrorToolBody(widget.errorMessage),
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
        _selectedIndex = 0;
      });
    };
    return MihPackageTools(
      tools: temp,
      selectedIndex: _selectedIndex,
    );
  }

  List<Widget> getErrorToolBody(String error) {
    List<Widget> toolBodies = [
      MihPackageToolBody(
        backgroundColor: MihColors.primary(),
        borderOn: true,
        bodyItem: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Connection Error",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MihColors.secondary(),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.power_off_outlined,
              size: 150,
              color: MihColors.secondary(),
            ),
            SizedBox(
              width: 500,
              child: Text(
                "Looks like we ran into an issue getting your data.\nPlease check you internet connection and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MihColors.secondary(),
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
              buttonColor: MihColors.green(),
              width: 300,
              child: Text(
                "Refresh",
                style: TextStyle(
                  color: MihColors.primary(),
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
                      color: MihColors.red(),
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
