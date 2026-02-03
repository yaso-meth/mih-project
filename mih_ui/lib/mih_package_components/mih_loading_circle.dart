import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import '../main.dart';

class Mihloadingcircle extends StatefulWidget {
  final String? message;
  const Mihloadingcircle({
    super.key,
    this.message,
  });

  @override
  State<Mihloadingcircle> createState() => _MihloadingcircleState();
}

class _MihloadingcircleState extends State<Mihloadingcircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late double width;
  late double height;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
          milliseconds: 500), // Duration for one pulse (grow and shrink)
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 200,
      end: 200 * 0.5, // Pulse to 50% of the initial size
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Smooth start and end of the pulse
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Container(
              padding: EdgeInsets.all(15),
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
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Icon(
                          MihIcons.mihLogo,
                          size: _animation
                              .value, // The size changes based on the animation value
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        );
                      },
                    ),
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
