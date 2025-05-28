import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';

class MihPackageWindow extends StatefulWidget {
  final String windowTitle;
  final Widget windowBody;
  final List<SpeedDialChild>? menuOptions;
  final void Function() onWindowTapClose;
  final bool fullscreen;
  const MihPackageWindow({
    super.key,
    required this.fullscreen,
    required this.windowTitle,
    this.menuOptions,
    required this.onWindowTapClose,
    required this.windowBody,
  });

  @override
  State<MihPackageWindow> createState() => _MihPackageWindowState();
}

class _MihPackageWindowState extends State<MihPackageWindow> {
  late double windowTitleSize;
  late double horizontralWindowPadding;
  late double vertticalWindowPadding;
  late double windowWidth;
  late double windowHeight;
  late double width;
  late double height;

  void checkScreenSize() {
    // print("screen width: $width");
    // print("screen height: $height");
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      setState(() {
        windowTitleSize = 25;
        horizontralWindowPadding = width / 7;
        vertticalWindowPadding = 25;
        windowWidth = width;
        windowHeight = height;
      });
    } else {
      setState(() {
        windowTitleSize = 20;
        horizontralWindowPadding = 10;
        vertticalWindowPadding = 10;
        windowWidth = width;
        windowHeight = height;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      width = size.width;
      height = size.height;
    });
    checkScreenSize();
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: horizontralWindowPadding,
        vertical: vertticalWindowPadding,
      ),
      insetAnimationCurve: Easing.emphasizedDecelerate,
      insetAnimationDuration: Durations.short1,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  width: 5.0),
            ),
            child: widget.fullscreen
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              widget.windowTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: windowTitleSize,
                                fontWeight: FontWeight.bold,
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .secondaryColor(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                          child:
                              SingleChildScrollView(child: widget.windowBody)),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              widget.windowTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: windowTitleSize,
                                fontWeight: FontWeight.bold,
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .secondaryColor(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 25,
                            right: 25,
                            bottom: vertticalWindowPadding,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: windowHeight * 0.85,
                              maxWidth: windowWidth * 0.85,
                            ),
                            child:
                                MihSingleChildScroll(child: widget.windowBody),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              // color: Colors.white,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(25), // Optional: rounds the corners
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(
                        60, 0, 0, 0), // 0.2 opacity = 51 in alpha (255 * 0.2)
                    spreadRadius: -2,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      MzanziInnovationHub.of(context)!.theme.errorColor()),
                ),
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                iconSize: 20,
                onPressed: () {
                  widget.onWindowTapClose();
                },
                icon: const Icon(
                  Icons.close,
                ),
              ),
            ),
          ),
          Visibility(
            visible:
                widget.menuOptions != null || widget.menuOptions!.isNotEmpty,
            child: Positioned(
              top: 10,
              right: 10,
              child: MihFloatingMenu(
                iconSize: 40,
                animatedIcon: AnimatedIcons.menu_close,
                direction: SpeedDialDirection.down,
                children: widget.menuOptions != null ? widget.menuOptions! : [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
