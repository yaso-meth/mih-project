import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MIHAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  final String barTitle;

  const MIHAppBar({super.key, required this.barTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 8,
      shadowColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      title: Text(
        barTitle,
      ),
      centerTitle: true,
    );
  }
}
