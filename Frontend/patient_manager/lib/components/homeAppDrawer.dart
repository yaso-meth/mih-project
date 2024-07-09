import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/theme/mihTheme.dart';

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
      backgroundColor: MyTheme().primaryColor(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyTheme().secondaryColor(),
            ),
            child: Text(
              widget.userEmail,
              style: TextStyle(color: MyTheme().primaryColor()),
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: MyTheme().secondaryColor(),
                ),
                SizedBox(width: 25.0),
                Text(
                  "Sign Out",
                  style: TextStyle(color: MyTheme().secondaryColor()),
                ),
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
