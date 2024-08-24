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
  late List<HomeTile> persHTList = [];
  late List<HomeTile> busHTList = [];
  late List<List<HomeTile>> pbswitch;
  late bool businessUserSwitch;
  int _selectedIndex = 0;
  final baseAPI = AppEnviroment.baseApiUrl;

  void setAppsNewPersonal(List<HomeTile> tileList) {
    if (widget.signedInUser.fname == "") {
      tileList.add(HomeTile(
        onTap: () {
          Navigator.of(context)
              .popAndPushNamed('/profile', arguments: widget.signedInUser);
        },
        tileName: "Setup Profie",
        tileIcon: Icons.perm_identity,
        p: getPrim(),
        s: getSec(),
      ));
    }
  }

  void setAppsNewBusiness(List<HomeTile> tileList) {
    tileList.add(HomeTile(
      onTap: () {
        Navigator.of(context).popAndPushNamed(
          '/business/add',
          arguments: widget.signedInUser,
        );
      },
      tileName: "Setup Business",
      tileIcon: Icons.add_business_outlined,
      p: getPrim(),
      s: getSec(),
    ));
  }

  void setAppsPersonal(List<HomeTile> tileList) {
    tileList.add(HomeTile(
      onTap: () {
        Navigator.of(context).popAndPushNamed('/patient-profile',
            arguments: PatientViewArguments(
                widget.signedInUser, null, null, null, "personal"));
      },
      tileName: "Patient Profile",
      tileIcon: Icons.medication,
      p: getPrim(),
      s: getSec(),
    ));
    tileList.add(HomeTile(
      onTap: () {
        Navigator.of(context).popAndPushNamed(
          '/patient-access-review',
          arguments: widget.signedInUser,
        );
      },
      tileName: "Access Review",
      tileIcon: Icons.check_box_outlined,
      p: getPrim(),
      s: getSec(),
    ));
  }

  void setAppsBusiness(List<HomeTile> tileList) {
    if (widget.businessUser!.access == "Full") {
      tileList.add(HomeTile(
        onTap: () {
          Navigator.of(context).popAndPushNamed(
            '/business-profile',
            arguments: BusinessArguments(
              widget.signedInUser,
              widget.businessUser,
              widget.business,
            ),
          );
        },
        tileName: "Business Profile",
        tileIcon: Icons.business,
        p: getPrim(),
        s: getSec(),
      ));
    }
    if (widget.business!.type == "Doctors Office") {
      tileList.add(HomeTile(
        onTap: () {
          Navigator.of(context).popAndPushNamed(
            '/patient-manager',
            arguments: BusinessArguments(
              widget.signedInUser,
              widget.businessUser,
              widget.business,
            ),
          );
        },
        tileName: "Manage Patient",
        tileIcon: Icons.medication,
        p: getPrim(),
        s: getSec(),
      ));
    }
  }

  void setAppsDev(List<HomeTile> tileList) {
    if (AppEnviroment.getEnv() == "Dev") {
      tileList.add(HomeTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return const Mihloadingcircle();
            },
          );
        },
        tileName: "Loading - Dev",
        tileIcon: Icons.change_circle,
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(HomeTile(
        onTap: () {
          Navigator.of(context).popAndPushNamed(
            '/business/add',
            arguments: widget.signedInUser,
          );
        },
        tileName: "Setup Bus - Dev",
        tileIcon: Icons.add_business_outlined,
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(HomeTile(
        onTap: () {
          Navigator.of(context).popAndPushNamed('/patient-manager/add',
              arguments: widget.signedInUser);
        },
        tileName: "Add Pat - Dev",
        tileIcon: Icons.add_circle_outline,
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(HomeTile(
        onTap: () {
          Navigator.of(context)
              .popAndPushNamed('/profile', arguments: widget.signedInUser);
        },
        tileName: "Upd Prof - Dev",
        tileIcon: Icons.perm_identity,
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(HomeTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return const MIHWarningMessage(warningType: "No Access");
            },
          );
        },
        tileName: "Warn - Dev",
        tileIcon: Icons.warning_amber_rounded,
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(HomeTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return const MIHErrorMessage(errorType: "Invalid Username");
            },
          );
        },
        tileName: "Error - Dev",
        tileIcon: Icons.error_outline_outlined,
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(HomeTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return const MIHSuccessMessage(
                  successType: "Success",
                  successMessage:
                      "Congratulations! Your account has been created successfully. You are log in and can start exploring.\n\nPlease note: more apps will appear once you update your profile.");
            },
          );
        },
        tileName: "Success - Dev",
        tileIcon: Icons.check_circle_outline_outlined,
        p: getPrim(),
        s: getSec(),
      ));

      tileList.add(HomeTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return MIHDeleteMessage(deleteType: "File", onTap: () {});
            },
          );
        },
        tileName: "Delete - Dev",
        tileIcon: Icons.delete_forever_outlined,
        p: getPrim(),
        s: getSec(),
      ));
    }
  }

  List<List<HomeTile>> setApps(
      List<HomeTile> personalTileList, List<HomeTile> businessTileList) {
    if (widget.signedInUser.fname == "") {
      setAppsNewPersonal(personalTileList);
    } else if (widget.signedInUser.type == "personal") {
      setAppsPersonal(personalTileList);
    } else if (widget.businessUser == null) {
      setAppsPersonal(personalTileList);
      setAppsNewBusiness(businessTileList);
    } else {
      setAppsPersonal(personalTileList);
      setAppsBusiness(businessTileList);
    }
    if (AppEnviroment.getEnv() == "Dev") {
      setAppsDev(personalTileList);
      setAppsDev(businessTileList);
    }
    return [personalTileList, businessTileList];
  }

  Color getPrim() {
    return MzanziInnovationHub.of(context)!.theme.secondaryColor();
  }

  Color getSec() {
    return MzanziInnovationHub.of(context)!.theme.primaryColor();
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
    setState(() {
      pbswitch = setApps(persHTList, busHTList);
      businessUserSwitch = false;
    });

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
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
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
              itemBuilder: (context, index) {
                return pbswitch[_selectedIndex][index];
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
