import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:gif/gif.dart';

class Mihloadingcircle extends StatefulWidget {
  const Mihloadingcircle({super.key});

  @override
  State<Mihloadingcircle> createState() => _MihloadingcircleState();
}

class _MihloadingcircleState extends State<Mihloadingcircle>
    with TickerProviderStateMixin {
  late final GifController _controller;

  @override
  void initState() {
    _controller = GifController(vsync: this);
    //_controller.animateTo(26);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider loading =
        MzanziInnovationHub.of(context)!.theme.loadingImage();
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              width: 5.0),
        ),
        child: Gif(
          image: loading,
          controller:
              _controller, // if duration and fps is null, original gif fps will be used.
          fps: 15,
          //duration: const Duration(seconds: 3),
          autostart: Autostart.loop,
          placeholder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          onFetchCompleted: () {
            _controller.reset();
            _controller.forward();
          },
        ),
      ),

      //   Center(
      //       child: MzanziInnovationHub.of(context)!.theme.loadingImage()),
      // ),
    );
  }
}
