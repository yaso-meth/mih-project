import 'package:flutter/material.dart';
import 'package:patient_manager/components/homeTile.dart';

class HomeTileGrid extends StatelessWidget {
  void navigateToPage() {}

  const HomeTileGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 1000,
        child: GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: MediaQuery.of(context).size.width / 600,
          crossAxisCount: 3,
          children: [
            HomeTile(
              onTap: navigateToPage,
              tileName: "Patient Manager",
              tileDescription:
                  "This is a digital solution for doctors Offices to manage their patients",
            ),
            HomeTile(
              onTap: navigateToPage,
              tileName: "Patient Manager",
              tileDescription:
                  "This is a digital solution for doctors Offices to manage their patients",
            ),
            HomeTile(
              onTap: navigateToPage,
              tileName: "Patient Manager",
              tileDescription:
                  "This is a digital solution for doctors Offices to manage their patients",
            ),
          ],
        ),
      ),
    );
  }
}
