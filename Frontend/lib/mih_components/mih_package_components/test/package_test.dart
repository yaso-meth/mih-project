import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih-app_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';

class PackageTest extends StatefulWidget {
  const PackageTest({super.key});

  @override
  State<PackageTest> createState() => _PackageTestState();
}

class _PackageTestState extends State<PackageTest> {
  int _selcetedIndex = 0;

  MihAppAction getAction() {
    return MihAppAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).popAndPushNamed(
          '/',
          arguments: AuthArguments(true, false),
        );
      },
    );
  }

  MihAppTools getTools() {
    Map<Widget, void Function()?> temp = Map();
    temp[const Icon(Icons.arrow_back)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    temp[const Icon(Icons.arrow_forward)] = () {
      setState(() {
        _selcetedIndex = 1;
      });
    };
    return MihAppTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  void showAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return MihAppAlert(
          alertIcon: Icon(
            Icons.warning_amber_rounded,
            size: 100,
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
          ),
          alertTitle: "Oops! Looks like some fields are missing.",
          alertBody: Column(
            children: [
              Text(
                "We noticed that some required fields are still empty. To ensure your request is processed smoothly, please fill out all the highlighted fields before submitting the form again.",
                style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Here's a quick tip: ",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: MzanziInnovationHub.of(context)!
                                .theme
                                .errorColor())),
                    const TextSpan(text: "Look for fields with an asterisk ("),
                    TextSpan(
                        text: "*",
                        style: TextStyle(
                            color: MzanziInnovationHub.of(context)!
                                .theme
                                .errorColor())),
                    const TextSpan(
                        text: ") next to them, as these are mandatory."),
                  ],
                ),
              ),
            ],
          ),
          alertColour: MzanziInnovationHub.of(context)!.theme.errorColor(),
        );
      },
    );
  }

  void showFullScreenWindow() {
    showDialog(
      context: context,
      builder: (context) {
        return MihAppWindow(
          fullscreen: true,
          windowTitle: "Test",
          windowTools: const [],
          onWindowTapClose: () {
            Navigator.pop(context);
          },
          windowBody: [
            Text(
              "Window test",
              style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        );
      },
    );
  }

  void showNormalWindow() {
    showDialog(
      context: context,
      builder: (context) {
        return MihAppWindow(
          fullscreen: false,
          windowTitle: "Test",
          windowTools: const [],
          onWindowTapClose: () {
            Navigator.pop(context);
          },
          windowBody: [
            Text(
              "Window test",
              style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        );
      },
    );
  }

  List<MihAppToolBody> getToolBody() {
    List<MihAppToolBody> toolBodies = [
      MihAppToolBody(
        borderOn: true,
        bodyItem: MihSingleChildScroll(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Hello",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              const SizedBox(height: 10),
              MihFloatingMenu(children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.add,
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  label: "Add",
                  labelBackgroundColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  labelStyle: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  backgroundColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  onTap: () {},
                )
              ]),
              Container(
                color: Colors.black,
                width: 200,
                height: 200,
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                child: IconButton.filled(
                  onPressed: () {},
                  icon: Icon(
                    MihIcons.mihLogo,
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      MihAppToolBody(
        borderOn: false,
        bodyItem: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "World!!!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
          ],
        ),
      ),
    ];
    return toolBodies;
  }

  @override
  Widget build(BuildContext context) {
    return MihApp(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      selectedbodyIndex: _selcetedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selcetedIndex = newValue;
        });
        print("Index: $_selcetedIndex");
      },
    );
  }
}
