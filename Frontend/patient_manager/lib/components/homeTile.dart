import 'package:flutter/material.dart';
import 'package:patient_manager/theme/mihTheme.dart';

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
        color: MyTheme().secondaryColor(),
        elevation: 20,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListTile(
                  leading: Icon(
                    Icons.abc,
                    color: MyTheme().primaryColor(),
                  ),
                  title: Text(
                    tileName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyTheme().primaryColor(),
                    ),
                  ),
                  subtitle: Text(
                    tileDescription,
                    style: TextStyle(color: MyTheme().primaryColor()),
                  )),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.arrow_forward,
                      color: MyTheme().secondaryColor(),
                    ),
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
