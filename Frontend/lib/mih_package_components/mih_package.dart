import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_scack_bar.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/components/mih_app_drawer.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MihPackage extends StatefulWidget {
  final Widget appActionButton;
  final MihPackageTools appTools;
  final List<Widget> appBody;
  final List<String> appToolTitles;
  final MIHAppDrawer? actionDrawer;
  int selectedbodyIndex;
  final Function(int) onIndexChange;
  MihPackage({
    super.key,
    required this.appActionButton,
    required this.appTools,
    required this.appBody,
    required this.appToolTitles,
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
  DateTime? lastPressedAt;

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
      await Future.delayed(const Duration(milliseconds: 100));
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
    // if (!MzansiInnovationHub.of(context)!.theme.kIsWeb) {
    //   // Trigger the peak animation on start (or call this elsewhere)
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _peakAnimation();
    //   });
    // }
    if (!MzansiInnovationHub.of(context)!.theme.kIsWeb) {
      // Trigger the peak animation only AFTER the route transition is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ModalRoute? currentRoute = ModalRoute.of(context);
        if (currentRoute != null) {
          currentRoute.animation?.addStatusListener((status) {
            if (status == AnimationStatus.completed && mounted) {
              // Ensure the widget is still mounted and the animation is completed
              _peakAnimation();
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: unfocusAll,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (GoRouterState.of(context).name == 'mihHome' ||
              GoRouterState.of(context).name == 'mihAuthentication') {
            if (lastPressedAt == null ||
                DateTime.now().difference(lastPressedAt!) >
                    const Duration(seconds: 2)) {
              // First press: show a message and update the timestamp.
              lastPressedAt = DateTime.now();
              ScaffoldMessenger.of(context).showSnackBar(
                MihSnackBar(
                  child: Text("Press back again to exit"),
                ),
              );
            } else {
              // Second press within 2 seconds: exit the app.
              KenLogger.warning('Exiting app...'); // Your custom logger
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }
          } else {
            context.goNamed(
              'mihHome',
              extra: true,
            );
          }
        },
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.appActionButton,
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          // alignment: Alignment.center,
                          // alignment: Alignment.centerRight,
                          alignment: Alignment.centerLeft,
                          // color: Colors.black,
                          child: FittedBox(
                            child: Text(
                              widget.appToolTitles[widget.selectedbodyIndex],
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      widget.appTools,
                      const SizedBox(width: 5),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
