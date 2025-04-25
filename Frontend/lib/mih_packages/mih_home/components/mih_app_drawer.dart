import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import '../../../main.dart';
import '../../../mih_objects/app_user.dart';
import '../../../mih_objects/arguments.dart';
import 'package:supertokens_flutter/supertokens.dart';

class MIHAppDrawer extends StatefulWidget {
  final AppUser signedInUser;
  final ImageProvider<Object>? propicFile;

  const MIHAppDrawer({
    super.key,
    required this.signedInUser,
    required this.propicFile,
  });

  @override
  State<MIHAppDrawer> createState() => _MIHAppDrawerState();
}

class _MIHAppDrawerState extends State<MIHAppDrawer> {
  final proPicController = TextEditingController();
  late Widget profilePictureLoaded;
  Future<bool> signOut() async {
    await SuperTokens.signOut(completionHandler: (error) {
      // handle error if any
    });
    return true;
  }

  Widget displayProPic() {
    // return MIHProfilePicture(
    //         profilePictureFile: widget.propicFile,
    //         proPicController: proPicController,
    //         proPic: null,
    //         width: 45,
    //         radius: 21,
    //         editable: false,
    //         onChange: (newProPic) {},
    //       ),
    //print(widget.propicFile);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(
          '/mzansi-profile',
          arguments:
              AppProfileUpdateArguments(widget.signedInUser, widget.propicFile),
        );
      },
      child: MihCircleAvatar(
        imageFile: widget.propicFile,
        width: 60,
        editable: false,
        fileNameController: proPicController,
        onChange: (_) {},
        userSelectedfile: null,
        frameColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        backgroundColor:
            MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      ),
      // MIHProfilePicture(
      //   profilePictureFile: widget.propicFile,
      //   proPicController: proPicController,
      //   proPic: null,
      //   width: 60,
      //   radius: 27,
      //   drawerMode: true,
      //   editable: false,
      //   frameColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
      //   onChange: (newProPic) {},
      // ),

      // Stack(
      //   alignment: Alignment.center,
      //   fit: StackFit.loose,
      //   children: [
      //     CircleAvatar(
      //       backgroundColor:
      //           MzanziInnovationHub.of(context)!.theme.primaryColor(),
      //       backgroundImage: widget.propicFile,
      //       //'https://media.licdn.com/dms/image/D4D03AQGd1-QhjtWWpA/profile-displayphoto-shrink_400_400/0/1671698053061?e=2147483647&v=beta&t=a3dJI5yxs5-KeXjj10LcNCFuC9IOfa8nNn3k_Qyr0CA'),
      //       radius: 27,
      //     ),
      //     SizedBox(
      //       width: 60,
      //       child: Image(image: logoFrame),
      //     )
      //   ],
      // ),
    );
  }

  @override
  void dispose() {
    proPicController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      profilePictureLoaded = displayProPic();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // precacheImage(
    //     MzanziInnovationHub.of(context)!.theme.logoImage().image, context);
    return SafeArea(
      child: Drawer(
        //backgroundColor:  MzanziInnovationHub.of(context)!.theme.primaryColor(),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              //fit: StackFit.passthrough,
              children: [
                Column(
                  // reverse: false,
                  // padding: EdgeInsets.zero,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                      child: SizedBox(
                        height: 400,
                        width: constraints.maxWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            profilePictureLoaded,
                            Text(
                              "${widget.signedInUser.fname} ${widget.signedInUser.lname}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .primaryColor(),
                              ),
                            ),
                            Text(
                              "@${widget.signedInUser.username}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .primaryColor(),
                              ),
                            ),
                            Text(
                              widget.signedInUser.type.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .primaryColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ListTile(
                    //   title: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     children: [
                    //       Icon(
                    //         Icons.home_outlined,
                    //         color:
                    //             MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    //       ),
                    //       const SizedBox(width: 25.0),
                    //       Text(
                    //         "Home",
                    //         style: TextStyle(
                    //           //fontWeight: FontWeight.bold,
                    //           color: MzanziInnovationHub.of(context)!
                    //               .theme
                    //               .secondaryColor(),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   onTap: () {
                    //     Navigator.of(context)
                    //         .pushNamedAndRemoveUntil('/', (route) => false);
                    //   },
                    // ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.policy,
                                  color: MzanziInnovationHub.of(context)!
                                      .theme
                                      .secondaryColor(),
                                ),
                                const SizedBox(width: 25.0),
                                Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    color: MzanziInnovationHub.of(context)!
                                        .theme
                                        .secondaryColor(),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/about',
                                arguments: 1,
                              );
                            },
                          ),
                          ListTile(
                            title: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.design_services_rounded,
                                  color: MzanziInnovationHub.of(context)!
                                      .theme
                                      .secondaryColor(),
                                ),
                                const SizedBox(width: 25.0),
                                Text(
                                  "Terms of Service",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    color: MzanziInnovationHub.of(context)!
                                        .theme
                                        .secondaryColor(),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/about',
                                arguments: 2,
                              );
                            },
                          ),
                          ListTile(
                            title: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: MzanziInnovationHub.of(context)!
                                      .theme
                                      .secondaryColor(),
                                ),
                                const SizedBox(width: 25.0),
                                Text(
                                  "Sign Out",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    color: MzanziInnovationHub.of(context)!
                                        .theme
                                        .secondaryColor(),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              await SuperTokens.signOut(
                                  completionHandler: (error) {
                                print(error);
                              });
                              if (await SuperTokens.doesSessionExist() ==
                                  false) {
                                Navigator.of(context).pop();
                                Navigator.of(context).popAndPushNamed(
                                  '/',
                                  arguments: AuthArguments(true, false),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  width: 30,
                  height: 30,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (MzanziInnovationHub.of(context)?.theme.mode ==
                            "Dark") {
                          //darkm = !darkm;
                          MzanziInnovationHub.of(context)!
                              .changeTheme(ThemeMode.light);
                          //print("Dark Mode: $darkm");
                        } else {
                          //darkm = !darkm;
                          MzanziInnovationHub.of(context)!
                              .changeTheme(ThemeMode.dark);
                          //print("Dark Mode: $darkm");
                        }
                        Navigator.of(context).pop();
                        Navigator.of(context).popAndPushNamed(
                          '/',
                          arguments: AuthArguments(true, false),
                        );
                        // Navigator.of(context).popAndPushNamed('/',);
                      });
                    },
                    child: Icon(
                      MihIcons.mihLogo,
                      color:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       if (MzanziInnovationHub.of(context)?.theme.mode == "Dark") {
                  //         //darkm = !darkm;
                  //         MzanziInnovationHub.of(context)!.changeTheme(ThemeMode.light);
                  //         //print("Dark Mode: $darkm");
                  //       } else {
                  //         //darkm = !darkm;
                  //         MzanziInnovationHub.of(context)!.changeTheme(ThemeMode.dark);
                  //         //print("Dark Mode: $darkm");
                  //       }
                  //       Navigator.of(context).popAndPushNamed('/');
                  //     });
                  //   },
                  //   icon: Icon(
                  //     Icons.light_mode,
                  //     color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  //     size: 35,
                  //   ),
                  // ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
