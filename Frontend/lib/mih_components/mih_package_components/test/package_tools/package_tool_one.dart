import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih-app_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';

class PackageToolOne extends StatefulWidget {
  const PackageToolOne({super.key});

  @override
  State<PackageToolOne> createState() => _PackageToolOneState();
}

class _PackageToolOneState extends State<PackageToolOne> {
  void showTestFullWindow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihAppWindow(
          fullscreen: true,
          windowTitle: "Test Full",
          onWindowTapClose: () {
            Navigator.of(context).pop();
          },
          windowBody: Text("Testing Window Body"),
        );
      },
    );
  }

  void showTestWindow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihAppWindow(
          fullscreen: false,
          windowTitle: "Test No Full",
          onWindowTapClose: () {
            Navigator.of(context).pop();
          },
          windowBody: Text("Testing Window Body"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
        Positioned(
          right: 0,
          bottom: 0,
          child: MihFloatingMenu(
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.add,
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  label: "Show New Window",
                  labelBackgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  labelStyle: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  onTap: () {
                    showTestWindow();
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.add,
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  label: "Show New Full Window",
                  labelBackgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  labelStyle: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  onTap: () {
                    showTestFullWindow();
                  },
                ),
              ]),
        )
      ],
    );
  }
}
