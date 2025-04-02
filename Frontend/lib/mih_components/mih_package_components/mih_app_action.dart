import 'package:flutter/material.dart';

class MihAppAction extends StatefulWidget {
  final void Function()? onTap;
  final double iconSize;
  final Widget icon;
  const MihAppAction({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.onTap,
  });

  @override
  State<MihAppAction> createState() => _MihAppActionState();
}

class _MihAppActionState extends State<MihAppAction> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.iconSize,
      padding: const EdgeInsets.all(0),
      onPressed: widget.onTap,
      icon: widget.icon,
    );
  }
}
