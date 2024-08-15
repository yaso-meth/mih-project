import 'package:flutter/material.dart';

class MIHButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          //fontWeight: FontWeight.bold,
          fontSize: 20,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
