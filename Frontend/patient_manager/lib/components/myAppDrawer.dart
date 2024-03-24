import 'package:flutter/material.dart';

class MyAppDrawer extends StatefulWidget {
  final String drawerTitle;

  const MyAppDrawer({super.key, required this.drawerTitle});

  @override
  State<MyAppDrawer> createState() => _MyAppDrawerState();
}

class _MyAppDrawerState extends State<MyAppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer();
  }
}
