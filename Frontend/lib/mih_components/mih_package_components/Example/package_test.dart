import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/Example/package_tools/package_tool_one.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/Example/package_tools/package_tool_two.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';

class PackageTest extends StatefulWidget {
  const PackageTest({super.key});

  @override
  State<PackageTest> createState() => _PackageTestState();
}

class _PackageTestState extends State<PackageTest> {
  int _selcetedIndex = 0;

  MihPackageAction getAction() {
    return MihPackageAction(
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
    temp[const Icon(Icons.inbox)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    temp[const Icon(Icons.outbond)] = () {
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

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      const PackageToolOne(),
      const PackageToolTwo(),
    ];
    return toolBodies;
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
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
