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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(widget.drawerTitle as String),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
          ListTile(
            title: Text("Home"),
            onTap: () {
              Navigator.of(context).pushNamed('/home');
            },
          )
        ],
      ),
    );
  }
}
