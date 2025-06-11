import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_yt_video_player.dart';
import 'package:flutter/material.dart';

class MihPackageTile extends StatefulWidget {
  final String appName;
  final String? ytVideoID;
  final Widget appIcon;
  final void Function() onTap;
  final double iconSize;
  final Color primaryColor;
  final Color secondaryColor;
  const MihPackageTile({
    super.key,
    required this.onTap,
    required this.appName,
    this.ytVideoID,
    required this.appIcon,
    required this.iconSize,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  State<MihPackageTile> createState() => _MihPackageTileState();
}

class _MihPackageTileState extends State<MihPackageTile> {
  void displayHint() {
    if (widget.ytVideoID != null) {
      showDialog(
        context: context,
        builder: (context) {
          return MihPackageWindow(
            fullscreen: false,
            windowTitle: widget.appName,
            // windowTools: const [],
            onWindowTapClose: () {
              Navigator.pop(context);
            },
            windowBody: MIHYTVideoPlayer(
              videoYTLink: widget.ytVideoID!,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.topCenter,
      // color: Colors.black,
      // width: widget.iconSize,
      // height: widget.iconSize + widget.iconSize / 3,
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: null, // Do this later
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double iconHeight = constraints.maxWidth;
                  return Container(
                    width: iconHeight,
                    height: iconHeight,
                    child:
                        FittedBox(fit: BoxFit.fitHeight, child: widget.appIcon),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              flex: 1,
              child: FittedBox(
                child: Text(
                  widget.appName,
                  textAlign: TextAlign.center,
                  // softWrap: true,
                  // overflow: TextOverflow.visible,
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
