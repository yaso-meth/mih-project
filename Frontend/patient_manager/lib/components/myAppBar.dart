import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final String barTitle;

  const MyAppBar({super.key, required this.barTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      elevation: 8,
      shadowColor: Colors.black,
      title: Text(
        barTitle,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }
}
