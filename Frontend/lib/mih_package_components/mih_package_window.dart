import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihPackageWindow extends StatefulWidget {
  final String? windowTitle;
  final Widget windowBody;
  final List<SpeedDialChild>? menuOptions;
  final void Function()? onWindowTapClose;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool? borderOn;
  final bool fullscreen;
  const MihPackageWindow({
    super.key,
    required this.fullscreen,
    required this.windowTitle,
    this.menuOptions,
    required this.onWindowTapClose,
    required this.windowBody,
    this.borderOn,
    this.backgroundColor,
    this.foregroundColor,
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
    if (MzansiInnovationHub.of(context)!.theme.screenType == "desktop") {
      setState(() {
        windowTitleSize = 25;
        horizontralWindowPadding = width / 7;
        vertticalWindowPadding = 10;
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

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.onWindowTapClose != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
              left: 5.0,
            ),
            child: MihButton(
              width: 40,
              height: 40,
              elevation: 10,
              onPressed: widget.onWindowTapClose,
              buttonColor: MihColors.getRedColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              child: Icon(
                Icons.close,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
          ),
        if (widget.windowTitle != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                widget.windowTitle!,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: windowTitleSize,
                  fontWeight: FontWeight.bold,
                  color: widget.foregroundColor ??
                      MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                ),
              ),
            ),
          ),
        if (widget.menuOptions != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
              right: 5.0,
            ),
            child: SizedBox(
              width: 40,
              child: MihFloatingMenu(
                iconSize: 40,
                animatedIcon: AnimatedIcons.menu_close,
                direction: SpeedDialDirection.down,
                children: widget.menuOptions != null ? widget.menuOptions! : [],
              ),
            ),
          ),
      ],
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
      child: Material(
        elevation: 10,
        shadowColor: Colors.black,
        color: widget.backgroundColor ??
            MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        borderRadius: BorderRadius.circular(25.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            border: widget.borderOn == null || !widget.borderOn!
                ? null
                : Border.all(
                    color: widget.foregroundColor ??
                        MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                    width: 5.0),
          ),
          child: widget.fullscreen
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    getHeader(),
                    const SizedBox(height: 5),
                    Expanded(
                        child: SingleChildScrollView(child: widget.windowBody)),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getHeader(),
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
                          child: MihSingleChildScroll(child: widget.windowBody),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
