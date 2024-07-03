import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class HomeAppDrawer extends StatefulWidget {
  final String userEmail;

  const HomeAppDrawer({super.key, required this.userEmail});

  @override
  State<HomeAppDrawer> createState() => _HomeAppDrawerState();
}

class _HomeAppDrawerState extends State<HomeAppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text(widget.userEmail),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 25.0),
                Text("Sign Out"),
              ],
            ),
            onTap: () {
              client.auth.signOut();
              Navigator.of(context).pushNamed('/');
            },
          )
        ],
      ),
    );
  }
}
