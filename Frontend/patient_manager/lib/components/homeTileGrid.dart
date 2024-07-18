import 'package:flutter/material.dart';
import 'package:patient_manager/components/homeTile.dart';
import 'package:patient_manager/main.dart';

class HomeTileGrid extends StatefulWidget {
  final String userEmail;
  const HomeTileGrid({super.key, required this.userEmail});

  @override
  State<HomeTileGrid> createState() => _HomeTileGridState();
}

class _HomeTileGridState extends State<HomeTileGrid> {
  late List<List<dynamic>> tileList;

  @override
  void initState() {
    //print("Home tile gird widget: ${widget.userEmail}");
    tileList = [
      [
        Icons.medication,
        "Patient Manager",
        () {
          // Navigator.of(context)
          //     .pushNamed('/patient-manager', arguments: widget.userEmail);
          Navigator.popAndPushNamed(context, '/patient-manager',
              arguments: widget.userEmail);
        }
      ],
      [Icons.abc, "Test 1", () {}],
      [Icons.abc, "Test 2", () {}],
      [Icons.abc, "Test 3", () {}],
      [Icons.abc, "Test 4", () {}],
      [Icons.abc, "Test 5", () {}],
      [Icons.abc, "Test 6", () {}],
    ];
    super.initState();
  }

  Color getPrim() {
    return MzanziInnovationHub.of(context)!.theme.secondaryColor();
  }

  Color getSec() {
    return MzanziInnovationHub.of(context)!.theme.primaryColor();
  }

  Widget buildtile(tile) {
    //setColor();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: HomeTile(
        onTap: tile[2],
        tileIcon: tile[0],
        tileName: tile[1],
        p: getPrim(),
        s: getSec(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Container(
      width: width,
      height: height,
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(width / 6, height / 16, width / 6,
            0), //EdgeInsets.symmetric(horizontal: width / 6),
        itemCount: tileList.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200),
        //const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          var tile = tileList[index];
          //setState(() {});
          return buildtile(tile);
        },
      ),
    );
  }
}
