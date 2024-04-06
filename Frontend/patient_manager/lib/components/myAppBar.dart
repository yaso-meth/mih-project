import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  final String barTitle;

  const MyAppBar({super.key, required this.barTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      elevation: 8,
      shadowColor: Colors.black,
      actions: [
        IconButton(
          onPressed: () {
            client.auth.signOut();
            Navigator.of(context).pushNamed('/');
          },
          icon: const Icon(Icons.logout),
          iconSize: 35,
          color: Colors.black,
        ),
      ],
      title: Text(
        barTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }
}
