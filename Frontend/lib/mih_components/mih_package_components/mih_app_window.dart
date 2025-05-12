import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';

class MihAppWindow extends StatefulWidget {
  final String windowTitle;
  final Widget windowBody;
  final Widget? windowTools;
  // final List<SpeedDialChild> menuOptions;
  final void Function() onWindowTapClose;
  final bool fullscreen;
  const MihAppWindow({
    super.key,
    required this.fullscreen,
    required this.windowTitle,
    this.windowTools,
    // required this.menuOptions,
    required this.onWindowTapClose,
    required this.windowBody,
  });

  @override
  State<MihAppWindow> createState() => _MihAppWindowState();
}

class _MihAppWindowState extends State<MihAppWindow> {
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

  Widget getWindowHeader() {
    return Container(
      // color: Colors.green,
      alignment: Alignment.center,
      height: 50,
      child: Row(
        children: [
          widget.windowTools != null ? widget.windowTools! : Container(),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              // color: Colors.pink,
              child: Text(
                widget.windowTitle,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: windowTitleSize,
                  fontWeight: FontWeight.bold,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
            ),
          ),
          Container(
            // color: Colors.white,
            alignment: Alignment.center,
            child: IconButton(
              iconSize: 35,
              onPressed: () {
                widget.onWindowTapClose();
              },
              icon: Icon(
                Icons.close,
                color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              ),
            ),
          ),
        ],
      ),
    );
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
      child: Container(
        decoration: BoxDecoration(
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              width: 5.0),
        ),
        child: widget.fullscreen
            ? Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  getWindowHeader(),
                  Expanded(
                      child: SingleChildScrollView(child: widget.windowBody)),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getWindowHeader(),
                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(
                          left: horizontralWindowPadding,
                          right: horizontralWindowPadding,
                          bottom: vertticalWindowPadding,
                        ),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: windowHeight * 0.85,
                              maxWidth: windowWidth * 0.85,
                            ),
                            child: MihSingleChildScroll(
                                child: widget.windowBody))),
                  ),
                ],
              ),
      ),
    );
  }
}
