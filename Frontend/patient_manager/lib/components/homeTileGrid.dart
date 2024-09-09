import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:patient_manager/components/homeTile.dart';
import 'package:patient_manager/components/inputsAndButtons/mihSearchInput.dart';
import 'package:patient_manager/components/mihAppDrawer.dart';
import 'package:patient_manager/components/popUpMessages/mihDeleteMessage.dart';
import 'package:patient_manager/components/popUpMessages/mihLoadingCircle.dart';
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
  final ImageProvider<Object>? propicFile;
  const HomeTileGrid({
    super.key,
    required this.signedInUser,
    required this.businessUser,
    required this.business,
    required this.propicFile,
  });

  @override
  State<HomeTileGrid> createState() => _HomeTileGridState();
}

class _HomeTileGridState extends State<HomeTileGrid> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<HomeTile> persHTList = [];
  late List<HomeTile> busHTList = [];
  late List<List<HomeTile>> pbswitch;
  late bool businessUserSwitch;
  int _selectedIndex = 0;
  String appSearch = "";
  final baseAPI = AppEnviroment.baseApiUrl;

  void setAppsNewPersonal(List<HomeTile> tileList) {
    if (widget.signedInUser.fname == "") {
      tileList.add(HomeTile(
        onTap: () {
          Navigator.of(context).pushNamed('/user-profile',
              arguments: AppProfileUpdateArguments(
                  widget.signedInUser, widget.propicFile));
        },
        tileName: "Setup Profie",
        tileIcon: Icon(
          Icons.perm_identity,
          color: getSec(),
          size: 200,
        ),
        p: getPrim(),
        s: getSec(),
      ));
    }
  }

  void setAppsNewBusiness(List<HomeTile> tileList) {
    tileList.add(HomeTile(
      onTap: () {
        Navigator.of(context).popAndPushNamed(
          '/business-profile/set-up',
          arguments: widget.signedInUser,
        );
      },
      tileName: "Setup Business",
      tileIcon: Icon(
        Icons.add_business_outlined,
        color: getSec(),
        size: 200,
      ),
      p: getPrim(),
      s: getSec(),
    ));
  }

  void setAppsPersonal(List<HomeTile> tileList) {
    ImageProvider logo = MzanziInnovationHub.of(context)!.theme.logoImage();
    tileList.add(HomeTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/user-profile',
          arguments:
              AppProfileUpdateArguments(widget.signedInUser, widget.propicFile),
        );
      },
      tileName: "Mzansi Profile",
      tileIcon: Image(image: logo),
      p: getPrim(),
      s: getSec(),
    ));
    tileList.add(HomeTile(
      onTap: () {
        Navigator.of(context).pushNamed('/patient-profile',
            arguments: PatientViewArguments(
                widget.signedInUser, null, null, null, "personal"));
      },
      tileName: "Patient Profile",
      tileIcon: Icon(
        Icons.medication,
        color: getSec(),
        size: 200,
      ),
      p: getPrim(),
      s: getSec(),
    ));
    tileList.add(HomeTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/access-review',
          arguments: widget.signedInUser,
        );
      },
      tileName: "Access Review",
      tileIcon: Icon(
        Icons.check_box_outlined,
        color: getSec(),
        size: 200,
      ),
      p: getPrim(),
      s: getSec(),
    ));
  }

  void setAppsBusiness(List<HomeTile> tileList) {
    if (widget.businessUser!.access == "Full") {
      tileList.add(HomeTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/business-profile',
            arguments: BusinessArguments(
              widget.signedInUser,
              widget.businessUser,
              widget.business,
            ),
          );
        },
        tileName: "Business Profile",
        tileIcon: Icon(
          Icons.business,
          color: getSec(),
          size: 200,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(HomeTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/business-profile/manage',
            arguments: BusinessArguments(
              widget.signedInUser,
              widget.businessUser,
              widget.business,
            ),
          );
        },
        tileName: "Manage Team",
        tileIcon: Icon(
          Icons.people_outline,
          color: getSec(),
          size: 200,
        ),
        p: getPrim(),
        s: getSec(),
      ));
    }
    if (widget.business!.type == "Doctors Office") {
      tileList.add(HomeTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/patient-manager',
            arguments: BusinessArguments(
              widget.signedInUser,
              widget.businessUser,
              widget.business,
            ),
          );
        },
        tileName: "Manage Patient",
        tileIcon: Icon(
          Icons.medication,
          color: getSec(),
          size: 200,
        ),
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
        tileIcon: Icon(
          Icons.change_circle,
          color: getSec(),
          size: 200,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(HomeTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/business-profile/set-up',
            arguments: widget.signedInUser,
          );
        },
        tileName: "Setup Bus - Dev",
        tileIcon: Icon(
          Icons.add_business_outlined,
          color: getSec(),
          size: 200,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(HomeTile(
        onTap: () {
          Navigator.of(context).pushNamed('/patient-profile/set-up',
              arguments: widget.signedInUser);
        },
        tileName: "Add Pat - Dev",
        tileIcon: Icon(
          Icons.add_circle_outline,
          color: getSec(),
          size: 200,
        ),
        p: getPrim(),
        s: getSec(),
      ));

      tileList.add(HomeTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              // return const MIHWarningMessage(warningType: "No Access");
              return const MIHWarningMessage(warningType: "Expired Access");
            },
          );
        },
        tileName: "Warn - Dev",
        tileIcon: Icon(
          Icons.warning_amber_rounded,
          color: getSec(),
          size: 200,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(HomeTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              // return const MIHErrorMessage(errorType: "Input Error");
              // return const MIHErrorMessage(errorType: "Password Requirements");
              // return const MIHErrorMessage(errorType: "Invalid Username");
              // return const MIHErrorMessage(errorType: "Invalid Email");
              // return const MIHErrorMessage(errorType: "User Exists");
              // return const MIHErrorMessage(errorType: "Password Match");
              // return const MIHErrorMessage(errorType: "Invalid Credentials");
              return const MIHErrorMessage(errorType: "Internet Connection");
            },
          );
        },
        tileName: "Error - Dev",
        tileIcon: Icon(
          Icons.error_outline_outlined,
          color: getSec(),
          size: 200,
        ),
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
        tileIcon: Icon(
          Icons.check_circle_outline_outlined,
          color: getSec(),
          size: 200,
        ),
        p: getPrim(),
        s: getSec(),
      ));

      tileList.add(HomeTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              // return MIHDeleteMessage(deleteType: "Note", onTap: () {});
              return MIHDeleteMessage(deleteType: "File", onTap: () {});
            },
          );
        },
        tileName: "Delete - Dev",
        tileIcon: Icon(
          Icons.delete_forever_outlined,
          color: getSec(),
          size: 200,
        ),
        p: getPrim(),
        s: getSec(),
      ));
    }
  }

  List<HomeTile> searchApp(List<HomeTile> appList, String searchString) {
    if (searchString == "") {
      return appList;
    } else {
      List<HomeTile> temp = [];
      for (var item in appList) {
        if (item.tileName.toLowerCase().contains(appSearch.toLowerCase())) {
          temp.add(item);
        }
      }
      return temp;
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

  void onDragStart(DragStartDetails startDrag) {
    Scaffold.of(context).openDrawer();
    print(startDrag.globalPosition.dx);
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
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
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    //final double height = size.height;
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        drawer: MIHAppDrawer(
          signedInUser: widget.signedInUser,
          propicFile: widget.propicFile,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    "Mzanzi Innovation Hub",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        flex: 4,
                        child: KeyboardListener(
                          focusNode: _focusNode,
                          autofocus: true,
                          onKeyEvent: (event) async {
                            if (event is KeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.enter) {
                              setState(() {
                                appSearch = searchController.text;
                              });
                            }
                          },
                          child: SizedBox(
                            child: MIHSearchField(
                              controller: searchController,
                              hintText: "Search Apps",
                              required: false,
                              editable: true,
                              onTap: () {
                                setState(() {
                                  appSearch = searchController.text;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: IconButton(
                          //padding: const EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              appSearch = "";
                              searchController.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.filter_alt_off,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.only(
                        left: width / 10,
                        right: width / 10,
                        //bottom: height / 5,
                        top: 20,
                      ),
                      // physics: ,
                      // shrinkWrap: true,
                      itemCount:
                          searchApp(pbswitch[_selectedIndex], appSearch).length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              mainAxisSpacing: 15, maxCrossAxisExtent: 200),
                      itemBuilder: (context, index) {
                        return searchApp(
                            pbswitch[_selectedIndex], appSearch)[index];
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                left: 5,
                width: 50,
                height: 50,
                child: Builder(
                  builder: (context) => IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        appSearch = "";
                        searchController.clear();
                      });
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(
                      Icons.apps,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        //),
        //   ],
        // ),
        bottomNavigationBar: Visibility(
          visible: isBusinessUser(widget.signedInUser),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GNav(
              //hoverColor: Colors.lightBlueAccent,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
      ),
    );
  }
}
