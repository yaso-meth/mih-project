import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/components/mih_app_drawer.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

// ignore: must_be_immutable
class MihPackage extends StatefulWidget {
  final Widget appActionButton;
  final MihPackageTools appTools;
  final List<Widget> appBody;
  final MIHAppDrawer? actionDrawer;
  int selectedbodyIndex;
  final Function(int) onIndexChange;
  MihPackage({
    super.key,
    required this.appActionButton,
    required this.appTools,
    required this.appBody,
    this.actionDrawer,
    required this.selectedbodyIndex,
    required this.onIndexChange,
  });

  @override
  State<MihPackage> createState() => _MihPackageState();
}

class _MihPackageState extends State<MihPackage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;

  void unfocusAll() {
    FocusScope.of(context).unfocus();
  }

  Future<void> _peakAnimation() async {
    int currentPage = widget.selectedbodyIndex;
    double peakOffset = _pageController.position.viewportDimension * 0.075;
    double currentOffset =
        _pageController.page! * _pageController.position.viewportDimension;
    int nextPage =
        currentPage + 1 < widget.appBody.length ? currentPage + 1 : currentPage;
    if (nextPage != currentPage) {
      await Future.delayed(const Duration(milliseconds: 300));
      await _pageController.animateTo(
        currentOffset + peakOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      // await Future.delayed(const Duration(milliseconds: 100));
      await _pageController.animateTo(
        currentPage * _pageController.position.viewportDimension,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _animationController.dispose();
  }

  @override
  void didUpdateWidget(covariant MihPackage oldWidget) {
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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    if (!MzanziInnovationHub.of(context)!.theme.kIsWeb) {
      // Trigger the peak animation on start (or call this elsewhere)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _peakAnimation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: unfocusAll,
      child: Scaffold(
        drawer: widget.actionDrawer,
        body: SafeArea(
          bottom: false,
          minimum: EdgeInsets.only(bottom: 0),
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
                const SizedBox(height: 5),
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
      ),
    );
  }
}
