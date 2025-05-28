import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_yt_video_player.dart';
import 'package:flutter/material.dart';

class MIHTile extends StatefulWidget {
  final String tileName;
  final String? videoID;
  final Widget tileIcon;
  final void Function() onTap;
  // final Widget tileIcon;
  final Color p;
  final Color s;

  const MIHTile({
    super.key,
    required this.onTap,
    required this.tileName,
    this.videoID,
    required this.tileIcon,
    required this.p,
    required this.s,
  });

  @override
  State<MIHTile> createState() => _MIHTileState();
}

class _MIHTileState extends State<MIHTile> {
  late Color mainC;
  late Color secondC;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    mainC = widget.p;
    secondC = widget.s;
    super.initState();
  }

  void displayHint() {
    if (widget.videoID != null) {
      showDialog(
        context: context,
        builder: (context) {
          return MihPackageWindow(
            fullscreen: false,
            windowTitle: widget.tileName,
            onWindowTapClose: () {
              Navigator.pop(context);
            },
            windowBody: Column(
              children: [
                MIHYTVideoPlayer(videoYTLink: widget.videoID!),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     "Tile Name: ${widget.tileName}\nTitle Type: ${widget.tileIcon.runtimeType.toString()}");
    return FittedBox(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            //alignment: Alignment.center,
            width: 250,
            height: 250,
            duration: const Duration(seconds: 2),
            child: Material(
              color: mainC,
              // shadowColor:
              //     MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              // elevation: 5,
              borderRadius: BorderRadius.circular(80),
              child: InkWell(
                borderRadius: BorderRadius.circular(80),
                // ho
                onTap: widget.onTap,
                onLongPress: () {
                  displayHint();
                },
                // hoverDuration: ,
                splashColor:
                    MzanziInnovationHub.of(context)!.theme.highlightColor(),
                highlightColor:
                    MzanziInnovationHub.of(context)!.theme.highlightColor(),
                child: widget.tileIcon,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: Text(
              widget.tileName,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
