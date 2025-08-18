import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import '../../../main.dart';
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
    return GestureDetector(
      onTap: () {
        context.goNamed(
          'mzansiProfileManage',
          extra: AppProfileUpdateArguments(
            widget.signedInUser,
            widget.propicFile,
          ),
        );
      },
      child: MihCircleAvatar(
        imageFile: widget.propicFile,
        width: 60,
        editable: false,
        fileNameController: proPicController,
        onChange: (_) {},
        userSelectedfile: null,
        frameColor: MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        backgroundColor: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      ),
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
    //     MzansiInnovationHub.of(context)!.theme.logoImage().image, context);
    return SafeArea(
      child: Drawer(
        //backgroundColor:  MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
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
                                color: MihColors.getPrimaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
                                        "Dark"),
                              ),
                            ),
                            Text(
                              "@${widget.signedInUser.username}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: MihColors.getPrimaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
                                        "Dark"),
                              ),
                            ),
                            Text(
                              widget.signedInUser.type.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: MihColors.getPrimaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
                                        "Dark"),
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
                    //             MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    //       ),
                    //       const SizedBox(width: 25.0),
                    //       Text(
                    //         "Home",
                    //         style: TextStyle(
                    //           //fontWeight: FontWeight.bold,
                    //           color: MzansiInnovationHub.of(context)!
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
                                  color: MihColors.getSecondaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                                ),
                                const SizedBox(width: 25.0),
                                Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    color: MihColors.getSecondaryColor(
                                        MzansiInnovationHub.of(context)!
                                                .theme
                                                .mode ==
                                            "Dark"),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              context.goNamed("aboutMih", extra: 1);
                            },
                          ),
                          ListTile(
                            title: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.design_services_rounded,
                                  color: MihColors.getSecondaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                                ),
                                const SizedBox(width: 25.0),
                                Text(
                                  "Terms of Service",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    color: MihColors.getSecondaryColor(
                                        MzansiInnovationHub.of(context)!
                                                .theme
                                                .mode ==
                                            "Dark"),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              context.goNamed("aboutMih", extra: 2);
                            },
                          ),
                          ListTile(
                            title: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: MihColors.getSecondaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                                ),
                                const SizedBox(width: 25.0),
                                Text(
                                  "Sign Out",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    color: MihColors.getSecondaryColor(
                                        MzansiInnovationHub.of(context)!
                                                .theme
                                                .mode ==
                                            "Dark"),
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
                                context.goNamed(
                                  'home',
                                  extra: AuthArguments(
                                    true,
                                    true,
                                  ),
                                );
                                // Navigator.of(context).pop();
                                // Navigator.of(context).popAndPushNamed(
                                //   '/',
                                //   arguments: AuthArguments(true, false),
                                // );
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
                        if (MzansiInnovationHub.of(context)?.theme.mode ==
                            "Dark") {
                          //darkm = !darkm;
                          MzansiInnovationHub.of(context)!
                              .changeTheme(ThemeMode.light);
                          //print("Dark Mode: $darkm");
                        } else {
                          //darkm = !darkm;
                          MzansiInnovationHub.of(context)!
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
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       if (MzansiInnovationHub.of(context)?.theme.mode == "Dark") {
                  //         //darkm = !darkm;
                  //         MzansiInnovationHub.of(context)!.changeTheme(ThemeMode.light);
                  //         //print("Dark Mode: $darkm");
                  //       } else {
                  //         //darkm = !darkm;
                  //         MzansiInnovationHub.of(context)!.changeTheme(ThemeMode.dark);
                  //         //print("Dark Mode: $darkm");
                  //       }
                  //       Navigator.of(context).popAndPushNamed('/');
                  //     });
                  //   },
                  //   icon: Icon(
                  //     Icons.light_mode,
                  //     color: MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
