import 'package:flutter/material.dart';

class MihToggle extends StatefulWidget {
  final String hintText;
  final bool initialPostion;
  final Color fillColor;
  final Color secondaryFillColor;
  final void Function(bool) onChange;
  const MihToggle({
    super.key,
    required this.hintText,
    required this.initialPostion,
    required this.fillColor,
    required this.secondaryFillColor,
    required this.onChange,
  });

  @override
  State<MihToggle> createState() => _MihToggleState();
}

class _MihToggleState extends State<MihToggle> {
  late bool togglePosition;

  @override
  void initState() {
    super.initState();
    setState(() {
      togglePosition = widget.initialPostion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            widget.hintText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.fillColor,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Switch(
          value: widget.initialPostion,
          activeColor: widget.secondaryFillColor,
          activeTrackColor: widget.fillColor,
          inactiveThumbColor: widget.fillColor,
          inactiveTrackColor: widget.secondaryFillColor,
          onChanged: widget.onChange,
        ),
      ],
    );
  }
}
