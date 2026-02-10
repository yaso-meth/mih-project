import 'package:flutter/material.dart';

class MihSingleChildScroll extends StatefulWidget {
  final Widget child;
  final bool? scrollbarOn;
  const MihSingleChildScroll({
    super.key,
    required this.child,
    this.scrollbarOn,
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
        behavior: ScrollConfiguration.of(context)
            .copyWith(scrollbars: widget.scrollbarOn ?? false),
        child: SingleChildScrollView(
          child: widget.child,
        ),
      ),
    );
  }
}
