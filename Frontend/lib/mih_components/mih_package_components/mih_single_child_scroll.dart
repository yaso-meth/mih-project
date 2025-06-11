import 'package:flutter/material.dart';

class MihSingleChildScroll extends StatefulWidget {
  final Widget child;
  const MihSingleChildScroll({
    super.key,
    required this.child,
  });

  @override
  State<MihSingleChildScroll> createState() => _MihSingleChildScrollState();
}

class _MihSingleChildScrollState extends State<MihSingleChildScroll> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      minimum: EdgeInsets.only(bottom: 5),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: widget.child,
        ),
      ),
    );
  }
}
