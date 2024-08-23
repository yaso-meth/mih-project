import 'package:flutter/material.dart';
import 'package:patient_manager/components/homeTile.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/mihAppDrawer.dart';
import 'package:patient_manager/components/popUpMessages/mihDeleteMessage.dart';
import 'package:patient_manager/components/mihLoadingCircle.dart';
import 'package:patient_manager/components/popUpMessages/mihWarningMessage.dart';
import 'package:patient_manager/components/popUpMessages/mihErrorMessage.dart';
import 'package:patient_manager/components/popUpMessages/mihSuccessMessage.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/business.dart';
import 'package:patient_manager/objects/businessUser.dart';

class HomeTileGrid extends StatefulWidget {
  final AppUser signedInUser;
  final BusinessUser? businessUser;
  final Business? business;
  const HomeTileGrid({
    super.key,
    required this.signedInUser,
    required this.businessUser,
    required this.business,
  });

  @override
  State<HomeTileGrid> createState() => _HomeTileGridState();
}

class _HomeTileGridState extends State<HomeTileGrid> {
  late List<List<dynamic>> personalTileList = [];
  late List<List<dynamic>> businessTileList = [];
  late List<List<dynamic>> devTileList = [];
  late List<List<List<dynamic>>> pbswitch;
  late bool businessUserSwitch;
  int _selectedIndex = 0;
  final baseAPI = AppEnviroment.baseApiUrl;

  void setAppsNewPersonal(List<List<dynamic>> tileList) {
    if (widget.signedInUser.fname == "") {
      tileList.add(
        [
          Icons.perm_identity,
          "Setup Profie",
          () {
            Navigator.of(context)
                .popAndPushNamed('/profile', arguments: widget.signedInUser);
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
          Navigator.of(context).popAndPushNamed(
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
          //comeback here
          Navigator.of(context).popAndPushNamed('/patient-profile',
              arguments: PatientViewArguments(
                  widget.signedInUser, null, null, null, "personal"));
          // Navigator.popAndPushNamed(context, '/patient-manager',
          //     arguments: widget.userEmail);
        }
      ],
    );
    tileList.add(
      [
        Icons.check_box_outlined,
        "Access Review",
        () {
          Navigator.of(context).popAndPushNamed(
            '/patient-access-review',
            arguments: widget.signedInUser,
          );
          // Navigator.popAndPushNamed(context, '/patient-manager',
          //     arguments: widget.userEmail);
        }
      ],
    );
  }

  void setAppsBusiness(List<List<dynamic>> tileList) {
    if (widget.businessUser!.access == "Full") {
      tileList.add(
        [
          Icons.business,
          "Business Profile",
          () {
            Navigator.of(context).popAndPushNamed(
              '/business-profile',
              arguments: BusinessArguments(
                widget.signedInUser,
                widget.businessUser,
                widget.business,
              ),
            );
            // Navigator.popAndPushNamed(context, '/patient-manager',
            //     arguments: widget.userEmail);
          }
        ],
      );
    }
    if (widget.business!.type == "Doctors Office") {
      tileList.add(
        [
          Icons.medication,
          "Manage Patient",
          () {
            Navigator.of(context).popAndPushNamed(
              '/patient-manager',
              arguments: BusinessArguments(
                widget.signedInUser,
                widget.businessUser,
                widget.business,
              ),
            );
            // Navigator.popAndPushNamed(context, '/patient-manager',
            //     arguments: widget.userEmail);
          }
        ],
      );
    }
  }

  void setAppsDev(List<List<dynamic>> tileList) {
    if (AppEnviroment.getEnv() == "Dev") {
      tileList.add(
        [
          Icons.change_circle,
          "Loading - Dev",
          () {
            showDialog(
              context: context,
              builder: (context) {
                return const Mihloadingcircle();
              },
            );
          }
        ],
      );
      tileList.add(
        [
          Icons.add_business_outlined,
          "Setup Bus - Dev",
          () {
            Navigator.of(context).popAndPushNamed(
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
          Navigator.of(context).popAndPushNamed('/patient-manager/add',
              arguments: widget.signedInUser);
        }
      ]);
      tileList.add(
        [
          Icons.perm_identity,
          "Upd Prof - Dev",
          () {
            Navigator.of(context)
                .popAndPushNamed('/profile', arguments: widget.signedInUser);
            // Navigator.popAndPushNamed(context, '/patient-manager',
            //     arguments: widget.userEmail);
          }
        ],
      );
      tileList.add([
        Icons.warning_amber_rounded,
        "Warn - Dev",
        () {
          showDialog(
            context: context,
            builder: (context) {
              return const MIHWarningMessage(warningType: "No Access");
            },
          );
        }
      ]);
      tileList.add([
        Icons.error_outline_outlined,
        "Error - Dev",
        () {
          showDialog(
            context: context,
            builder: (context) {
              return const MIHErrorMessage(errorType: "Invalid Username");
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
              return const MIHSuccessMessage(
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
    }
  }

  List<List<List<dynamic>>> setApps(List<List<dynamic>> personalTileList,
      List<List<dynamic>> businessTileList) {
    //print(widget.businessUser);
    if (widget.signedInUser.fname == "") {
      //print("New personal user");
      setAppsNewPersonal(personalTileList);
    } else if (widget.signedInUser.type == "personal") {
      //print("existing personal user");
      setAppsPersonal(personalTileList);
    } else if (widget.businessUser == null) {
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
    return [personalTileList, businessTileList];
    // pbswitch.add(personalTileList);
    // pbswitch.add(businessTileList);
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

  String getHeading(int index) {
    if (index == 0) {
      return "Personal Apps";
    } else {
      return "Business Apps";
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    pbswitch = setApps(personalTileList, businessTileList);
    businessUserSwitch = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MIHAppBar(barTitle: "Mzansi Innovation\nHub"),
      drawer: MIHAppDrawer(
        signedInUser: widget.signedInUser,
      ),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (!businessUserSwitch) {
                    setState(() {
                      businessUserSwitch = true;
                      _selectedIndex = 1;
                    });
                  } else {
                    setState(() {
                      businessUserSwitch = false;
                      _selectedIndex = 0;
                    });
                  }
                },
                icon: const Icon(
                  Icons.swap_horizontal_circle_outlined,
                  size: 35,
                ),
              ),
            ],
          ),
          Text(
            getHeading(_selectedIndex),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: GridView.builder(
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
        ],
      ),

      // bottomNavigationBar: Visibility(
      //   visible: isBusinessUser(widget.signedInUser),
      //   child: Padding(
      //     padding: const EdgeInsets.all(15.0),
      //     child: GNav(
      //       //hoverColor: Colors.lightBlueAccent,
      //       color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      //       iconSize: 35.0,
      //       activeColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
      //       tabBackgroundColor:
      //           MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      //       //gap: 20,
      //       //padding: EdgeInsets.all(15),
      //       tabs: [
      //         GButton(
      //           icon: Icons.perm_identity,
      //           text: "Personal",
      //           onPressed: () {
      //             setState(() {
      //               _selectedIndex = 0;
      //             });
      //           },
      //         ),
      //         GButton(
      //           icon: Icons.business_center,
      //           text: "Business",
      //           onPressed: () {
      //             setState(() {
      //               _selectedIndex = 1;
      //             });
      //           },
      //         ),
      //       ],
      //       selectedIndex: _selectedIndex,
      //     ),
      //   ),
      // ),
    );
  }
}
