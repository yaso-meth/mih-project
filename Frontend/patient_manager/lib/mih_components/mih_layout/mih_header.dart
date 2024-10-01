import 'package:flutter/material.dart';

class MIHHeader extends StatefulWidget {
  final MainAxisAlignment headerAlignment;
  final List<Widget> headerItems;
  const MIHHeader({
    super.key,
    required this.headerAlignment,
    required this.headerItems,
  });

  @override
  State<MIHHeader> createState() => _MIHHeaderState();
}

class _MIHHeaderState extends State<MIHHeader> {
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
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: widget.headerAlignment,
        mainAxisSize: MainAxisSize.max,
        children: widget.headerItems,
      ),
    );
  }
}
