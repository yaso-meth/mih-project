import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

// ignore: must_be_immutable
class MihApp extends StatefulWidget {
  final MihAppAction appActionButton;
  final MihAppTools appTools;
  final List<Widget> appBody;
  int selectedbodyIndex;
  final onIndexChange;
  MihApp({
    super.key,
    required this.appActionButton,
    required this.appTools,
    required this.appBody,
    required this.selectedbodyIndex,
    required this.onIndexChange,
  });

  @override
  State<MihApp> createState() => _MihAppState();
}

class _MihAppState extends State<MihApp> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          //color: Colors.black,
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.appActionButton,
                  Flexible(child: widget.appTools),
                ],
              ),
              Expanded(
                  child: SwipeDetector(
                onSwipeLeft: (offset) {
                  if (widget.selectedbodyIndex <
                      widget.appTools.tools.length - 1) {
                    setState(() {
                      widget.selectedbodyIndex += 1;
                      widget.onIndexChange(widget.selectedbodyIndex);
                    });
                  }
                  // print("swipe left");
                },
                onSwipeRight: (offset) {
                  if (widget.selectedbodyIndex > 0) {
                    setState(() {
                      widget.selectedbodyIndex -= 1;
                      widget.onIndexChange(widget.selectedbodyIndex);
                    });
                  }
                  // print("swipe right");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: widget.appBody[widget.selectedbodyIndex],
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
