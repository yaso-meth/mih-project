import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:supertokens_flutter/supertokens.dart';

class MIHAppDrawer extends StatefulWidget {
  final AppUser signedInUser;
  //final AssetImage logo;
  const MIHAppDrawer({
    super.key,
    required this.signedInUser,
    //required this.logo,
  });

  @override
  State<MIHAppDrawer> createState() => _MIHAppDrawerState();
}

class _MIHAppDrawerState extends State<MIHAppDrawer> {
  //String endpointUserData = "${AppEnviroment.baseApiUrl}/users/profile/";
  //late Future<AppUser> signedInUser;
  //late Image logo;

  // Future<AppUser> getUserDetails() async {
  //   //print("pat man drawer: " + endpointUserData + widget.userEmail);
  //   var response =
  //       await http.get(Uri.parse(endpointUserData + widget.signedInUser));
  //   // print(response.statusCode);
  //   //print(response.body);
  //   if (response.statusCode == 200) {
  //     //print("here");
  //     String body = response.body;
  //     var decodedData = jsonDecode(body);
  //     AppUser u = AppUser.fromJson(decodedData as Map<String, dynamic>);
  //     //print(u.email);
  //     return u;
  //   } else {
  //     throw Exception("Error: GetUserData status code ${response.statusCode}");
  //   }
  // }

  Future<bool> signOut() async {
    await SuperTokens.signOut(completionHandler: (error) {
      // handle error if any
    });
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    //signedInUser = getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // precacheImage(
    //     MzanziInnovationHub.of(context)!.theme.logoImage().image, context);
    ImageProvider logo = MzanziInnovationHub.of(context)!.theme.logoImage();
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
                    SizedBox(
                      height: 60,
                      child: Image(image: logo),
                    ),
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
                //Navigator.of(context).pushNamed('/home');
                Navigator.popAndPushNamed(context, '/home');
              },
            ),
            ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.perm_identity,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                  const SizedBox(width: 25.0),
                  Text(
                    "Profile",
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
                //signedInUser = snapshot.data!;
                //print("MIHAppDrawer: ${signedInUser.runtimeType}");
                Navigator.of(context).popAndPushNamed('/profile',
                    arguments: widget.signedInUser);
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
          top: 1,
          right: 1,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
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
                Navigator.of(context).popAndPushNamed('/home');
              });
            },
            icon: Icon(
              Icons.light_mode,
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              size: 35,
            ),
          ),
        ),
      ]),
    );
  }
}
