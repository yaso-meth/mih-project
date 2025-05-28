import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MihPackageTools extends StatefulWidget {
  final Map<Widget, void Function()?> tools;
  int selcetedIndex;
  MihPackageTools({
    super.key,
    required this.tools,
    required this.selcetedIndex,
  });

  @override
  State<MihPackageTools> createState() => _MihPackageToolsState();
}

class _MihPackageToolsState extends State<MihPackageTools> {
  List<Widget> getTools() {
    List<Widget> temp = [];
    int index = 0;
    widget.tools.forEach((icon, onTap) {
      temp.add(
        Visibility(
          visible: widget.selcetedIndex != index,
          child: IconButton(
            onPressed: onTap,
            icon: icon,
          ),
        ),
      );
      temp.add(
        Visibility(
          visible: widget.selcetedIndex == index,
          child: IconButton.filled(
            onPressed: onTap,
            icon: icon,
          ),
        ),
      );
      index += 1;
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: getTools(),
    );
  }
}
