import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:patient_manager/components/homeTile.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/mihAppDrawer.dart';
import 'package:patient_manager/components/mihDeleteMessage.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/mySuccessMessage.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/businessUser.dart';
import 'package:supertokens_flutter/http.dart' as http;

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
  late List<List<dynamic>> personalTileList = [];
  late List<List<dynamic>> businessTileList = [];
  late List<List<dynamic>> devTileList = [];
  List<List<List<dynamic>>> pbswitch = [];
  int _selectedIndex = 0;
  final baseAPI = AppEnviroment.baseApiUrl;
  late Future<BusinessUser?> futureBusinessUser;
  BusinessUser? businessUser;

  Future<BusinessUser?> getBusinessUserDetails() async {
    var response = await http
        .get(Uri.parse("$baseAPI/business-user/${widget.signedInUser.app_id}"));
    if (response.statusCode == 200) {
      String body = response.body;
      var decodedData = jsonDecode(body);
      BusinessUser business_User = BusinessUser.fromJson(decodedData);
      return business_User;
    } else {
      return null;
    }
  }

  void setAppsNewPersonal(List<List<dynamic>> tileList) {
    if (widget.signedInUser.fname == "") {
      tileList.add(
        [
          Icons.perm_identity,
          "Setup Profie",
          () {
            Navigator.of(context)
                .pushNamed('/profile', arguments: widget.signedInUser);
            // Navigator.popAndPushNamed(context, '/patient-manager',
            //     arguments: widget.userEmail);
          }
        ],
      );
    }
  }

  void setAppsNewBusiness(List<List<dynamic>> tileList) {
    tileList.add(
      [
        Icons.add_business_outlined,
        "Setup Business",
        () {
          Navigator.of(context).pushNamed(
            '/business/add',
            arguments: widget.signedInUser,
          );
        }
      ],
    );
  }

  void setAppsPersonal(List<List<dynamic>> tileList) {
    tileList.add(
      [
        Icons.medication,
        "Patient Profile",
        () {
          Navigator.of(context).pushNamed('/patient-profile',
              arguments: PatientViewArguments(widget.signedInUser, "personal"));
          // Navigator.popAndPushNamed(context, '/patient-manager',
          //     arguments: widget.userEmail);
        }
      ],
    );
  }

  void setAppsBusiness(List<List<dynamic>> tileList) {
    tileList.add(
      [
        Icons.business,
        "Business Profile",
        () {
          Navigator.of(context).pushNamed(
            '/business-profile',
            arguments: widget.signedInUser,
          );
          // Navigator.popAndPushNamed(context, '/patient-manager',
          //     arguments: widget.userEmail);
        }
      ],
    );
    tileList.add(
      [
        Icons.medication,
        "Manage Patient",
        () {
          Navigator.of(context).pushNamed('/patient-manager',
              arguments: widget.signedInUser.email);
          // Navigator.popAndPushNamed(context, '/patient-manager',
          //     arguments: widget.userEmail);
        }
      ],
    );
  }

  void setAppsDev(List<List<dynamic>> tileList) {
    if (AppEnviroment.getEnv() == "Dev") {
      tileList.add(
        [
          Icons.add_business_outlined,
          "Setup Bus - Dev",
          () {
            Navigator.of(context).pushNamed(
              '/business/add',
              arguments: widget.signedInUser,
            );
          }
        ],
      );
      tileList.add([
        Icons.add_circle_outline,
        "Add Pat - Dev",
        () {
          Navigator.of(context).pushNamed('/patient-manager/add',
              arguments: widget.signedInUser);
        }
      ]);
      tileList.add(
        [
          Icons.perm_identity,
          "Upd Prof - Dev",
          () {
            Navigator.of(context)
                .pushNamed('/profile', arguments: widget.signedInUser);
            // Navigator.popAndPushNamed(context, '/patient-manager',
            //     arguments: widget.userEmail);
          }
        ],
      );
      tileList.add([
        Icons.error_outline_outlined,
        "Error - Dev",
        () {
          showDialog(
            context: context,
            builder: (context) {
              return const MyErrorMessage(errorType: "Invalid Username");
            },
          );
        }
      ]);
      tileList.add([
        Icons.check_circle_outline_outlined,
        "Success - Dev",
        () {
          showDialog(
            context: context,
            builder: (context) {
              return const MySuccessMessage(
                  successType: "Success",
                  successMessage:
                      "Congratulations! Your account has been created successfully. You are log in and can start exploring.\n\nPlease note: more apps will appear once you update your profile.");
            },
          );
        }
      ]);
      tileList.add([
        Icons.delete_forever_outlined,
        "Delete - Dev",
        () {
          showDialog(
            context: context,
            builder: (context) {
              return MIHDeleteMessage(deleteType: "File", onTap: () {});
            },
          );
        }
      ]);

      tileList.add([Icons.abc, "Test 5", () {}]);
      tileList.add([Icons.abc, "Test 6", () {}]);
    }
  }

  Future<void> setApps(List<List<dynamic>> personalTileList,
      List<List<dynamic>> businessTileList) async {
    //print(businessUser);
    if (widget.signedInUser.fname == "") {
      //print("New personal user");
      setAppsNewPersonal(personalTileList);
    } else if (widget.signedInUser.type == "personal") {
      //print("existing personal user");
      setAppsPersonal(personalTileList);
    } else if (businessUser == null) {
      //print("new business user");
      setAppsPersonal(personalTileList);
      setAppsNewBusiness(businessTileList);
    } else {
      //business
      //print("existing business user");
      setAppsPersonal(personalTileList);
      setAppsBusiness(businessTileList);
    }
    if (AppEnviroment.getEnv() == "Dev") {
      //print("Dev Enviroment");
      setAppsDev(personalTileList);
      setAppsDev(businessTileList);
    }
    pbswitch.add(personalTileList);
    pbswitch.add(businessTileList);
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

  bool isBusinessUser(AppUser signedInUser) {
    if (signedInUser.type == "personal") {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    futureBusinessUser = getBusinessUserDetails().then((results) {
      //print(results);
      setState(() {
        businessUser = results;
        setApps(personalTileList, businessTileList);
      });
      return null;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return FutureBuilder(
      future: futureBusinessUser,
      builder: (BuildContext context, AsyncSnapshot<BusinessUser?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: const MIHAppBar(barTitle: "Mzansi Innovation Hub"),
            drawer: MIHAppDrawer(
              signedInUser: widget.signedInUser,
              logo: MzanziInnovationHub.of(context)!.theme.logoImage(), //logo,
            ),
            body: Container(
              width: width,
              height: height,
              child: GridView.builder(
                padding: EdgeInsets.fromLTRB(width / 6, height / 16, width / 6,
                    0), //EdgeInsets.symmetric(horizontal: width / 6),
                itemCount: pbswitch[_selectedIndex].length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200),
                //const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (context, index) {
                  var tile = pbswitch[_selectedIndex][index];
                  //setState(() {});
                  return buildtile(tile);
                },
              ),
            ),
            bottomNavigationBar: Visibility(
              visible: isBusinessUser(widget.signedInUser),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: GNav(
                  //hoverColor: Colors.lightBlueAccent,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  iconSize: 35.0,
                  activeColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  tabBackgroundColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  //gap: 20,
                  //padding: EdgeInsets.all(15),
                  tabs: [
                    GButton(
                      icon: Icons.perm_identity,
                      text: "Personal",
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.business_center,
                      text: "Business",
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
