import 'package:flutter/material.dart';

class MihPackageAction extends StatefulWidget {
  final void Function()? onTap;
  final double iconSize;
  final Widget icon;
  const MihPackageAction({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.onTap,
  });

  @override
  State<MihPackageAction> createState() => _MihPackageActionState();
}

class _MihPackageActionState extends State<MihPackageAction> {
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
