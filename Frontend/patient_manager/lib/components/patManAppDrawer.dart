import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:http/http.dart' as http;
import 'package:patient_manager/objects/appUser.dart';

class PatManAppDrawer extends StatefulWidget {
  final String userEmail;

  const PatManAppDrawer({super.key, required this.userEmail});

  @override
  State<PatManAppDrawer> createState() => _PatManAppDrawerState();
}

class _PatManAppDrawerState extends State<PatManAppDrawer> {
  String endpointUserData = "http://localhost:80/users/profile/";
  late AppUser signedInUser;

  Future<AppUser> getUserDetails() async {
    //print("pat man drawer: " + endpointUserData + widget.userEmail);
    var response =
        await http.get(Uri.parse(endpointUserData + widget.userEmail));
    //print(response.statusCode);
    //print(response.body);
    if (response.statusCode == 200) {
      return AppUser.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Error: GetUserData status code ${response.statusCode}");
    }
  }

  @override
  void initState() {
    //signedInUser = getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserDetails(),
      builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Signed Is As:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Name: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 15),
                        Text("${snapshot.data?.fname} ${snapshot.data?.lname}"),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Email: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        Text("${snapshot.data?.email}"),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.home_outlined),
                    SizedBox(width: 25.0),
                    Text("Home"),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/home');
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.perm_identity),
                    SizedBox(width: 25.0),
                    Text("Profile"),
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
                title: const Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 25.0),
                    Text("Sign Out"),
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

  // Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: [
  //         DrawerHeader(
  //           decoration: const BoxDecoration(
  //             color: Colors.blueAccent,
  //           ),
  //           child: Column(
  //             children: [
  //               const Text("Signed Is As:"),
  //               Text("Name: ${signedInUser.fname} ${signedInUser.lname}"),
  //               Text("Email: ${signedInUser.email}"),
  //             ],
  //           ),
  //         ),
  //         ListTile(
  //           title: const Row(
  //             children: [
  //               Icon(Icons.home_outlined),
  //               SizedBox(width: 25.0),
  //               Text("Home"),
  //             ],
  //           ),
  //           onTap: () {
  //             Navigator.of(context).pushNamed('/home');
  //           },
  //         ),
  //         ListTile(
  //           title: const Row(
  //             children: [
  //               Icon(Icons.perm_identity),
  //               SizedBox(width: 25.0),
  //               Text("Profile"),
  //             ],
  //           ),
  //           onTap: () {
  //             //Navigator.of(context).pushNamed('/home');
  //           },
  //         ),
  //         ListTile(
  //           title: const Row(
  //             children: [
  //               Icon(Icons.logout),
  //               SizedBox(width: 25.0),
  //               Text("Sign Out"),
  //             ],
  //           ),
  //           onTap: () {
  //             client.auth.signOut();
  //             Navigator.of(context).pushNamed('/');
  //           },
  //         )
  //       ],
  //     ),
  //   );
}
