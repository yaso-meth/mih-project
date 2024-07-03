import 'package:flutter/material.dart';

class HomeTile extends StatelessWidget {
  final String tileName;
  final String tileDescription;
  final void Function() onTap;
  // final Widget tileIcon;

  const HomeTile({
    super.key,
    required this.onTap,
    required this.tileName,
    required this.tileDescription,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 20,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.abc),
                title: Text(
                  tileName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(tileDescription),
              ),
            ),
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
