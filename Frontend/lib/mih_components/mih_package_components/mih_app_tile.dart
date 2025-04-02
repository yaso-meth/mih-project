import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih_app_window.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_yt_video_player.dart';
import 'package:flutter/material.dart';

class MihAppTile extends StatefulWidget {
  final String appName;
  final String? ytVideoID;
  final Widget appIcon;
  final void Function() onTap;
  final double iconSize;
  final Color primaryColor;
  final Color secondaryColor;
  const MihAppTile({
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
  State<MihAppTile> createState() => _MihAppTileState();
}

class _MihAppTileState extends State<MihAppTile> {
  void displayHint() {
    if (widget.ytVideoID != null) {
      showDialog(
        context: context,
        builder: (context) {
          return MihAppWindow(
            fullscreen: false,
            windowTitle: widget.appName,
            windowTools: const [],
            onWindowTapClose: () {
              Navigator.pop(context);
            },
            windowBody: [
              MIHYTVideoPlayer(
                videoYTLink: widget.ytVideoID!,
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double borderRadius = widget.iconSize * 0.15;
    return Container(
      alignment: Alignment.topCenter,
      // color: Colors.black,
      // width: widget.iconSize,
      // height: widget.iconSize + widget.iconSize / 3,
      child: Column(
        children: [
          Flexible(
            flex: 3,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double iconHeight = constraints.maxWidth;
                return AnimatedContainer(
                  height: iconHeight,
                  duration: const Duration(seconds: 2),
                  child: Material(
                    color: widget.primaryColor,
                    // shadowColor:
                    //     MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    // elevation: 5,
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(borderRadius),
                      // ho
                      onTap: widget.onTap,
                      onLongPress: () {
                        displayHint();
                      },
                      // hoverDuration: ,
                      splashColor: MzanziInnovationHub.of(context)!
                          .theme
                          .highlightColor(),
                      highlightColor: MzanziInnovationHub.of(context)!
                          .theme
                          .highlightColor(),
                      child: FittedBox(child: widget.appIcon),
                    ),
                  ),
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
    );
  }
}
