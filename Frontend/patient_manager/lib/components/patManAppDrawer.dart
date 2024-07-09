import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:http/http.dart' as http;
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/theme/mihTheme.dart';

class PatManAppDrawer extends StatefulWidget {
  final String userEmail;

  const PatManAppDrawer({super.key, required this.userEmail});

  @override
  State<PatManAppDrawer> createState() => _PatManAppDrawerState();
}

class _PatManAppDrawerState extends State<PatManAppDrawer> {
  String endpointUserData = "http://localhost:80/users/profile/";
  late Future<AppUser> signedInUser;

  Future<AppUser> getUserDetails() async {
    //print("pat man drawer: " + endpointUserData + widget.userEmail);
    var response =
        await http.get(Uri.parse(endpointUserData + widget.userEmail));
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      return AppUser.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Error: GetUserData status code ${response.statusCode}");
    }
  }

  @override
  void initState() {
    signedInUser = getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: signedInUser,
      builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
        return Drawer(
          backgroundColor: MyTheme().primaryColor(),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: MyTheme().secondaryColor(),
                ),
                child: SizedBox(
                  height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Signed Is As:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: MyTheme().primaryColor()),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Name: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyTheme().primaryColor(),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "${snapshot.data?.fname} ${snapshot.data?.lname}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyTheme().primaryColor(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Email: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyTheme().primaryColor(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "${snapshot.data?.email}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyTheme().primaryColor(),
                            ),
                          ),
                        ],
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
                      color: MyTheme().secondaryColor(),
                    ),
                    const SizedBox(width: 25.0),
                    Text(
                      "Home",
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: MyTheme().secondaryColor(),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/home');
                },
              ),
              ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.perm_identity,
                      color: MyTheme().secondaryColor(),
                    ),
                    const SizedBox(width: 25.0),
                    Text(
                      "Profile",
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: MyTheme().secondaryColor(),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  //signedInUser = snapshot.data!;
                  //print("PatManAppDrawer: ${signedInUser.runtimeType}");
                  Navigator.of(context).pushNamed('/patient-manager/profile',
                      arguments: snapshot.data);
                },
              ),
              ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.logout,
                      color: MyTheme().secondaryColor(),
                    ),
                    const SizedBox(width: 25.0),
                    Text(
                      "Sign Out",
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: MyTheme().secondaryColor(),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  client.auth.signOut();
                  Navigator.of(context).pushNamed('/');
                },
              )
            ],
          ),
        );
      },
    );
  }
}
