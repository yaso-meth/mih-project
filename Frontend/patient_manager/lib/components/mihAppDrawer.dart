import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
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
  late Widget profilePictureLoaded;
  Future<bool> signOut() async {
    await SuperTokens.signOut(completionHandler: (error) {
      // handle error if any
    });
    return true;
  }

  Widget displayProPic() {
    //print(widget.propicFile);
    ImageProvider logoFrame =
        MzanziInnovationHub.of(context)!.theme.logoFrame();
    if (widget.propicFile != null) {
      return Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: [
          CircleAvatar(
            backgroundColor:
                MzanziInnovationHub.of(context)!.theme.primaryColor(),
            backgroundImage: widget.propicFile,
            //'https://media.licdn.com/dms/image/D4D03AQGd1-QhjtWWpA/profile-displayphoto-shrink_400_400/0/1671698053061?e=2147483647&v=beta&t=a3dJI5yxs5-KeXjj10LcNCFuC9IOfa8nNn3k_Qyr0CA'),
            radius: 27,
          ),
          SizedBox(
            width: 60,
            child: Image(image: logoFrame),
          )
        ],
      );
    } else {
      return SizedBox(
        width: 60,
        child: Image(image: logoFrame),
      );
    }
  }

  @override
  void dispose() {
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
    ImageProvider logoThemeSwitch =
        MzanziInnovationHub.of(context)!.theme.logoImage();
    return Drawer(
      //backgroundColor:  MzanziInnovationHub.of(context)!.theme.primaryColor(),
      child: Stack(children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
              child: SizedBox(
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                      widget.signedInUser.type,
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
            ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.home_outlined,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                  const SizedBox(width: 25.0),
                  Text(
                    "Home",
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
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
            ),
            ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.logout,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
                await SuperTokens.signOut(completionHandler: (error) {
                  print(error);
                });
                if (await SuperTokens.doesSessionExist() == false) {
                  Navigator.of(context).popAndPushNamed('/');
                }
              },
            )
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
                if (MzanziInnovationHub.of(context)?.theme.mode == "Dark") {
                  //darkm = !darkm;
                  MzanziInnovationHub.of(context)!.changeTheme(ThemeMode.light);
                  //print("Dark Mode: $darkm");
                } else {
                  //darkm = !darkm;
                  MzanziInnovationHub.of(context)!.changeTheme(ThemeMode.dark);
                  //print("Dark Mode: $darkm");
                }
                Navigator.of(context).popAndPushNamed('/');
              });
            },
            child: Image(image: logoThemeSwitch),
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
      ]),
    );
  }
}
