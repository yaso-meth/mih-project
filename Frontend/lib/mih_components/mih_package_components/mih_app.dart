import 'package:mzansi_innovation_hub/mih_packages/mih_home/components/mih_app_drawer.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_tools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

// ignore: must_be_immutable
class MihApp extends StatefulWidget {
  final Widget appActionButton;
  final MihAppTools appTools;
  final List<Widget> appBody;
  final MIHAppDrawer? actionDrawer;
  int selectedbodyIndex;
  final Function(int) onIndexChange;
  MihApp({
    super.key,
    required this.appActionButton,
    required this.appTools,
    required this.appBody,
    this.actionDrawer,
    required this.selectedbodyIndex,
    required this.onIndexChange,
  });

  @override
  State<MihApp> createState() => _MihAppState();
}

class _MihAppState extends State<MihApp> {
  late PageController _pageController;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  void didUpdateWidget(covariant MihApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedbodyIndex != widget.selectedbodyIndex) {
      _pageController.animateToPage(
        widget.selectedbodyIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.selectedbodyIndex);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: widget.actionDrawer,
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
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.appBody.length,
                  itemBuilder: (context, index) {
                    return widget.appBody[index];
                  },
                  onPageChanged: (index) {
                    setState(() {
                      widget.selectedbodyIndex = index;
                      widget.onIndexChange(widget.selectedbodyIndex);
                    });
                  },
                ),
              ),
              // Expanded(
              //     child: SwipeDetector(
              //   onSwipeLeft: (offset) {
              //     if (widget.selectedbodyIndex <
              //         widget.appTools.tools.length - 1) {
              //       setState(() {
              //         widget.selectedbodyIndex += 1;
              //         widget.onIndexChange(widget.selectedbodyIndex);
              //       });
              //     }
              //     // print("swipe left");
              //   },
              //   onSwipeRight: (offset) {
              //     if (widget.selectedbodyIndex > 0) {
              //       setState(() {
              //         widget.selectedbodyIndex -= 1;
              //         widget.onIndexChange(widget.selectedbodyIndex);
              //       });
              //     }
              //     // print("swipe right");
              //   },
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: widget.appBody[widget.selectedbodyIndex],
              //       )
              //     ],
              //   ),
              // )),
            ],
          ),
        ),
      ),
    );
  }
}
