import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';

class MihFloatingMenu extends StatefulWidget {
  final IconData? icon;
  final double? iconSize;
  final AnimatedIconData? animatedIcon;
  final SpeedDialDirection? direction;
  final List<SpeedDialChild> children;
  const MihFloatingMenu({
    super.key,
    this.icon,
    this.iconSize,
    this.animatedIcon,
    this.direction,
    required this.children,
  });

  @override
  State<MihFloatingMenu> createState() => _MihFloatingMenuState();
}

class _MihFloatingMenuState extends State<MihFloatingMenu> {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: widget.icon,
      buttonSize: Size(widget.iconSize ?? 56.0, widget.iconSize ?? 56.0),
      animatedIcon: widget.animatedIcon,
      direction: widget.direction ?? SpeedDialDirection.up,
      activeIcon: Icons.close,
      backgroundColor: MzansiInnovationHub.of(context)!.theme.successColor(),
      activeBackgroundColor:
          MzansiInnovationHub.of(context)!.theme.errorColor(),
      foregroundColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      children: widget.children,
      onOpen: () => debugPrint('OPENING DIAL'),
      onClose: () => debugPrint('DIAL CLOSED'),
    );
  }
}
