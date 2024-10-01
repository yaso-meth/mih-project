import 'package:flutter/material.dart';

class MIHAction extends StatefulWidget {
  final void Function()? onTap;
  final double iconSize;
  final Widget icon;
  const MIHAction({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.onTap,
  });

  @override
  State<MIHAction> createState() => _MIHActionState();
}

class _MIHActionState extends State<MIHAction> {
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
    return Positioned(
      top: 5,
      left: 5,
      width: 50,
      height: 50,
      child: IconButton(
        iconSize: widget.iconSize,
        padding: const EdgeInsets.all(0),
        onPressed: widget.onTap,
        icon: widget.icon,
      ),
    );
  }
}
