import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';

class MihButton extends StatefulWidget {
  final void Function() onPressed;
  final Color buttonColor;
  final double width;
  final double? height;
  final double? borderRadius;
  final Widget child;

  const MihButton({
    super.key,
    required this.onPressed,
    required this.buttonColor,
    required this.width,
    this.height,
    this.borderRadius,
    required this.child,
  });

  @override
  State<MihButton> createState() => _MihButtonState();
}

class _MihButtonState extends State<MihButton> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: AnimatedButton(
        width: widget.width,
        height: widget.height ?? 50.0,
        borderRadius: widget.borderRadius ?? 25.0,
        color: widget.buttonColor,
        shadowDegree: ShadowDegree.light,
        duration: 30,
        onPressed: widget.onPressed,
        child: FittedBox(child: widget.child),
      ),
    );
  }
}
