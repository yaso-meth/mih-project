import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:supertokens_flutter/http.dart' as http;

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

class _MIHAppDrawerState extends State<MIHAppDrawer>
    with TickerProviderStateMixin {
  late Future<String> proPicUrl;
  late final GifController _controller;
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

  Future<String> getFileUrlApiCall(String filePath) async {
    if (widget.signedInUser.pro_pic_path == "") {
      return "";
    } else if (AppEnviroment.getEnv() == "Dev") {
      return "${AppEnviroment.baseFileUrl}/mih/$filePath";
    } else {
      var url = "${AppEnviroment.baseApiUrl}/minio/pull/file/$filePath/prod";
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String body = response.body;
        var decodedData = jsonDecode(body);

        return decodedData['minioURL'];
      } else {
        throw Exception(
            "Error: GetUserData status code ${response.statusCode}");
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      proPicUrl = getFileUrlApiCall(widget.signedInUser.pro_pic_path);
    });
    _controller = GifController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // precacheImage(
    //     MzanziInnovationHub.of(context)!.theme.logoImage().image, context);
    ImageProvider logoThemeSwitch =
        MzanziInnovationHub.of(context)!.theme.logoImage();
    ImageProvider logoFrame =
        MzanziInnovationHub.of(context)!.theme.logoFrame();
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
                    FutureBuilder(
                      future: proPicUrl,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData && snapshot.data != "") {
                            return Stack(
                              alignment: Alignment.center,
                              fit: StackFit.loose,
                              children: [
                                CircleAvatar(
                                  //backgroundColor: Colors.green,
                                  backgroundImage:
                                      NetworkImage(snapshot.requireData),
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
                        } else {
                          return Center(
                            child: Text(
                              '${snapshot.error} occurred',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }
                      },
                    ),
                    // Stack(
                    //   alignment: Alignment.center,
                    //   fit: StackFit.loose,
                    //   children: [
                    //     const CircleAvatar(
                    //       backgroundColor: Colors.green,
                    //       radius: 27,
                    //     ),
                    //     SizedBox(
                    //       width: 60,
                    //       child: Image(image: logoFrame),
                    //     )
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 60,
                    //   child: Image(image: logoFrame),
                    // ),
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
                Navigator.of(context).popAndPushNamed('/user-profile',
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
