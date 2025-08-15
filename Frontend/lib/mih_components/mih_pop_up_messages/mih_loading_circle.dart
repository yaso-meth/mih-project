import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import '../../main.dart';
import 'package:gif_view/gif_view.dart';

class Mihloadingcircle extends StatefulWidget {
  final String? message;
  const Mihloadingcircle({super.key, this.message});

  @override
  State<Mihloadingcircle> createState() => _MihloadingcircleState();
}

class _MihloadingcircleState extends State<Mihloadingcircle> {
  // final GifController _controller = GifController();
  late double popUpPaddingSize;
  late double popUpWidth;
  late double? popUpheight;

  late double width;
  late double height;

  void checkScreenSize() {
    if (MzansiInnovationHub.of(context)!.theme.screenType == "desktop") {
      setState(() {
        popUpWidth = 250;
        popUpheight = 250;
        popUpPaddingSize = 25.0;
      });
    } else {
      setState(() {
        popUpWidth = 250;
        popUpheight = 250;
        popUpPaddingSize = 15.0;
      });
    }
  }

  @override
  void initState() {
    //_controller.animateTo(26);
    super.initState();
    checkScreenSize();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Container(
              padding: EdgeInsets.all(popUpPaddingSize),
              // width: 250,
              // height: 275,
              decoration: BoxDecoration(
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GifView.asset(
                    MzansiInnovationHub.of(context)!
                        .theme
                        .loadingImageLocation(),
                    height: 200,
                    width: 200,
                    frameRate: 30,
                  ),
                  widget.message != null
                      ? Text(
                          widget.message!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : SizedBox(),
                ],
              )),
        ),
      ),
    );
  }
}
