import 'package:flutter/material.dart';
import 'package:patient_manager/components/homeTile.dart';

class HomeTileGrid extends StatefulWidget {
  final String userEmail;
  const HomeTileGrid({super.key, required this.userEmail});

  @override
  State<HomeTileGrid> createState() => _HomeTileGridState();
}

class _HomeTileGridState extends State<HomeTileGrid> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    double width = size.width;
    double height = size.height;
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    // final double itemWidth = size.width / 5;
    List<List<dynamic>> tileList = [
      [
        Icons.medication,
        "Patient Manager",
        () {
          Navigator.of(context)
              .pushNamed('/patient-manager', arguments: widget.userEmail);
        }
      ],
      [Icons.abc, "Test 1", () {}],
      [Icons.abc, "Test 2", () {}],
      [Icons.abc, "Test 3", () {}],
      [Icons.abc, "Test 4", () {}],
      [Icons.abc, "Test 5", () {}],
      [Icons.abc, "Test 6", () {}],
    ];

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(width / 6, height / 16, width / 6,
          0), //EdgeInsets.symmetric(horizontal: width / 6),
      itemCount: tileList.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200),
      //const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: HomeTile(
            onTap: tileList[index][2],
            tileIcon: tileList[index][0],
            tileName: tileList[index][1],
          ),
        );
      },
    );
  }
}
