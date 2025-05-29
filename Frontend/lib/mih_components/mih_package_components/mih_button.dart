import 'package:flutter/material.dart';

class MihButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color buttonColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? elevation; // 0 = flat, higher = more shadow
  final Widget child;

  const MihButton({
    super.key,
    required this.onPressed,
    required this.buttonColor,
    this.width,
    this.height,
    this.borderRadius,
    this.elevation,
    required this.child,
  });
  Color _darkerColor(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final Color effectiveButtonColor = onPressed == null
        ? buttonColor.withValues(alpha: 0.6) // Example disabled color
        : buttonColor;
    final Color rippleColor = _darkerColor(effectiveButtonColor, 0.1);
    final double radius = borderRadius ?? 25.0;
    final double effectiveElevation =
        onPressed == null ? 0.0 : (elevation ?? 4.0);
    return MouseRegion(
      cursor: onPressed == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: Material(
        color: effectiveButtonColor,
        borderRadius: BorderRadius.circular(radius),
        elevation: effectiveElevation,
        shadowColor: Colors.black,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          splashColor: rippleColor,
          highlightColor: rippleColor.withValues(alpha: 0.2),
          hoverColor: rippleColor.withValues(alpha: 0.3),
          onTap: onPressed,
          child: Container(
            width: width,
            height: height,
            padding: (width == null || height == null)
                ? const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                : null,
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}
