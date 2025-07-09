import 'package:flutter/material.dart';
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
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
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
      child: Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: 250,
          height: 275,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                width: 5.0),
          ),
          child: Column(
            children: [
              GifView.asset(
                MzanziInnovationHub.of(context)!.theme.loadingImageLocation(),
                height: 200,
                width: 200,
                frameRate: 30,
              ),
              widget.message != null
                  ? Text(
                      widget.message!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : SizedBox(),
            ],
          )),
    );
  }
}
