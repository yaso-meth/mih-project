import 'package:mzansi_innovation_hub/main.dart';
import 'package:flutter/material.dart';

class MihPackageAlert extends StatefulWidget {
  final Widget alertIcon;
  final String alertTitle;
  final Widget alertBody;
  final Color alertColour;
  const MihPackageAlert({
    super.key,
    required this.alertIcon,
    required this.alertTitle,
    required this.alertBody,
    required this.alertColour,
  });

  @override
  State<MihPackageAlert> createState() => _MihPackageAlertState();
}

class _MihPackageAlertState extends State<MihPackageAlert> {
  late double popUpWidth;
  late double? popUpheight;
  late double popUpTitleSize;
  late double popUpSubtitleSize;
  late double popUpBodySize;
  late double popUpIconSize;
  late double popUpPaddingSize;
  Size? size;

  void checkScreenSize() {
    if (MzansiInnovationHub.of(context)!.theme.screenType == "desktop") {
      setState(() {
        popUpWidth = (size!.width / 4) * 2;
        popUpheight = null;
        popUpTitleSize = 25.0;
        popUpSubtitleSize = 20.0;
        popUpBodySize = 15;
        popUpPaddingSize = 25.0;
        popUpIconSize = 100;
      });
    } else {
      setState(() {
        popUpWidth = size!.width - (size!.width * 0.1);
        popUpheight = null;
        popUpTitleSize = 20.0;
        popUpSubtitleSize = 18.0;
        popUpBodySize = 15;
        popUpPaddingSize = 15.0;
        popUpIconSize = 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    checkScreenSize();
    return Dialog(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(popUpPaddingSize),
            width: popUpWidth,
            height: popUpheight,
            decoration: BoxDecoration(
              color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(color: widget.alertColour, width: 5.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.alertIcon,
                  //const SizedBox(height: 5),
                  Text(
                    widget.alertTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.alertColour,
                      fontSize: popUpTitleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  widget.alertBody,
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            width: 50,
            height: 50,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: MzansiInnovationHub.of(context)!.theme.errorColor(),
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
