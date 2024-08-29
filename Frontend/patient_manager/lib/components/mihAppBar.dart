import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MIHAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String barTitle;
  final ImageProvider<Object>? propicFile;
  const MIHAppBar({
    super.key,
    required this.barTitle,
    required this.propicFile,
  });

  @override
  State<MIHAppBar> createState() => _MIHAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}

class _MIHAppBarState extends State<MIHAppBar> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 8,
      shadowColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      // actions: [
      //   IconButton(
      //     icon: const Icon(
      //       Icons.home,
      //       size: 40,
      //     ),
      //     onPressed: () {
      //       //   Navigator.pushNamedAndRemoveUntil(
      //       //     context,
      //       //     '/home',
      //       //   );
      //       Navigator.of(context)
      //           .pushNamedAndRemoveUntil('/home', (route) => false);
      //     },
      //   )
      // ],
      title: Text(
        widget.barTitle,
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
    );
  }
}
