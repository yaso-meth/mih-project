import 'package:flutter/material.dart';

class MIHButton extends StatefulWidget {
  final void Function() onTap;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;

  const MIHButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.buttonColor,
    required this.textColor,
  });

  @override
  State<MIHButton> createState() => _MIHButtonState();
}

class _MIHButtonState extends State<MIHButton> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        widget.buttonText,
        style: TextStyle(
          //fontWeight: FontWeight.bold,
          fontSize: 20,
          color: widget.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
