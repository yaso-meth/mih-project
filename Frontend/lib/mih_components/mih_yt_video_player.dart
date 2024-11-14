import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MIHYTVideoPlayer extends StatefulWidget {
  final String videoYTLink;
  const MIHYTVideoPlayer({
    super.key,
    required this.videoYTLink,
  });

  @override
  State<MIHYTVideoPlayer> createState() => _MIHYTVideoPlayerState();
}

class _MIHYTVideoPlayerState extends State<MIHYTVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  void initState() {
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        enableCaption: false,
        showControls: true,
        mute: false,
        showFullscreenButton: false,
        loop: false,
      ),
    );
    _controller.loadVideoById(videoId: widget.videoYTLink);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      aspectRatio: 16 / 9,
    );
  }
}
