import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MyAppBar extends StatelessWidget {
  final String barTitle;

  const MyAppBar({super.key, required this.barTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      elevation: 8,
      shadowColor: Colors.black,
      leading: IconButton(
        onPressed: () {
          client.auth.signOut();
          Navigator.of(context).pushNamed('/');
        },
        icon: const Icon(Icons.logout),
        iconSize: 35,
        color: Colors.black,
      ),
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
