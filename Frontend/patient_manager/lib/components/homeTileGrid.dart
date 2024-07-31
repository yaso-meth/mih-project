import 'package:flutter/material.dart';
import 'package:patient_manager/components/homeTile.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';

class HomeTileGrid extends StatefulWidget {
  final AppUser signedInUser;
  const HomeTileGrid({
    super.key,
    required this.signedInUser,
  });

  @override
  State<HomeTileGrid> createState() => _HomeTileGridState();
}

class _HomeTileGridState extends State<HomeTileGrid> {
  late List<List<dynamic>> tileList = [];

  void setApps(List<List<dynamic>> tileList) {
    if (widget.signedInUser.fname == "") {
      tileList.add(
        [
          Icons.perm_identity,
          "Update Profie",
          () {
            Navigator.of(context)
                .pushNamed('/profile', arguments: widget.signedInUser);
            // Navigator.popAndPushNamed(context, '/patient-manager',
            //     arguments: widget.userEmail);
          }
        ],
      );
    } else if (widget.signedInUser.type == "personal") {
      tileList.add(
        [
          Icons.medication,
          "Patient Profile",
          () {
            Navigator.of(context)
                .pushNamed('/patient-profile', arguments: widget.signedInUser);
            // Navigator.popAndPushNamed(context, '/patient-manager',
            //     arguments: widget.userEmail);
          }
        ],
      );
    } else {
      //business
      tileList.add(
        [
          Icons.medication,
          "Patient Manager",
          () {
            Navigator.of(context).pushNamed('/patient-manager',
                arguments: widget.signedInUser.email);
            // Navigator.popAndPushNamed(context, '/patient-manager',
            //     arguments: widget.userEmail);
          }
        ],
      );
    }

    if (AppEnviroment.getEnv() == "Dev") {
      tileList.add([
        Icons.add,
        "Add Pat - Dev",
        () {
          Navigator.of(context).pushNamed('/patient-manager/add',
              arguments: widget.signedInUser);
        }
      ]);
      tileList.add([
        Icons.password,
        "Pass Req - Dev",
        () {
          showDialog(
            context: context,
            builder: (context) {
              return const MyErrorMessage(errorType: "Password Requirements");
            },
          );
        }
      ]);
      tileList.add([Icons.abc, "Test 3", () {}]);
      tileList.add([Icons.abc, "Test 4", () {}]);
      tileList.add([Icons.abc, "Test 5", () {}]);
      tileList.add([Icons.abc, "Test 6", () {}]);
    }
  }

  @override
  void initState() {
    //print("Home tile gird widget: ${widget.userEmail}");
    setApps(tileList);
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
