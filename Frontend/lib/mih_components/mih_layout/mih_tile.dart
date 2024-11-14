import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'mih_window.dart';

class MIHTile extends StatefulWidget {
  final String tileName;
  final String? videoYTLink;
  final Widget tileIcon;
  final void Function() onTap;
  // final Widget tileIcon;
  final Color p;
  final Color s;

  const MIHTile({
    super.key,
    required this.onTap,
    required this.tileName,
    this.videoYTLink,
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
  late YoutubePlayerController videoController;

  String getVideID() {
    if (widget.videoYTLink != null) {
      return YoutubePlayer.convertUrlToId(widget.videoYTLink!) as String;
    } else {
      return "";
    }
  }

  // void listener() {
  //   if (_isPlayerReady && mounted && !videoController.value.isFullScreen) {
  //     setState(() {
  //       _playerState = videoController.value.playerState;
  //       _videoMetaData = videoController.metadata;
  //     });
  //   }
  // }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    mainC = widget.p;
    secondC = widget.s;

    videoController = YoutubePlayerController(
        initialVideoId: getVideID(),
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: true,
          isLive: false,
        ));
    super.initState();
  }

  void displayHint() {
    if (widget.videoYTLink != null) {
      showDialog(
        context: context,
        builder: (context) {
          return MIHWindow(
            fullscreen: false,
            windowTitle: widget.tileName,
            windowTools: const [],
            onWindowTapClose: () {
              Navigator.pop(context);
            },
            windowBody: [
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: videoController,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.amber,
                  progressColors: ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.amberAccent,
                  ),
                ),
                builder: (context, player) {
                  return player;
                },
              ),
            ],
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
          // Material(
          //   color: mainC,
          //   borderRadius: BorderRadius.circular(80),
          //   child: Ink(
          //     // width: 200,
          //     // height: 200,
          //     padding: const EdgeInsets.all(20),
          //     child: InkWell(
          //       onTap: widget.onTap,
          //       hoverDuration: Duration(seconds: 2),
          //       highlightColor:
          //           MzanziInnovationHub.of(context)!.theme.messageTextColor(),
          //       child: SizedBox(
          //         height: 200,
          //         width: 200,
          //         child: widget.tileIcon,
          //       ),
          //     ),
          //   ),
          // ),
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
