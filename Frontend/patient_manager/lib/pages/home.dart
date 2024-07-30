import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/mihAppDrawer.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/components/homeTileGrid.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:supertokens_flutter/http.dart' as http;

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //late Future<AppUser> signedInUser;
  String useremail = "";
  final baseAPI = AppEnviroment.baseApiUrl;
  //late Image logo;

  Future<void> loadImage() async {
    try {
      var t = MzanziInnovationHub.of(context)!.theme.logoImage();
      await precacheImage(t.image, context);
    } catch (e) {
      print('Failed to load and cache the image: $e');
    }
  }

  Future<AppUser> getUserDetails() async {
    //print("pat man drawer: " + endpointUserData + widget.userEmail);
    var uid = await SuperTokens.getUserId();
    var response = await http.get(Uri.parse("$baseAPI/user/$uid"));
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      // print("here");
      String body = response.body;
      var decodedData = jsonDecode(body);
      AppUser u = AppUser.fromJson(decodedData);
      // print(u.email);
      return u;
    } else {
      throw Exception("Error: GetUserData status code ${response.statusCode}");
    }
  }

  // Future<void> getUser() async {
  //   var uid = await SuperTokens.getUserId();
  //   var response = await http.get(Uri.parse("$baseAPI/user/$uid"));
  //   if (response.statusCode == 200) {
  //     var user = jsonDecode(response.body);
  //     print(user);
  //     signedInUser = AppUser.fromJson(user as Map<String, dynamic>);

  //     //useremail = user["email"];
  //   }
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  void initState() {
    //signedInUser = getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadImage();
    var logo = MzanziInnovationHub.of(context)!.theme.logoImage();
    return FutureBuilder(
      future: getUserDetails(),
      builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: const MIHAppBar(barTitle: "Mzansi Innovation Hub"),
              drawer: MIHAppDrawer(
                signedInUser: snapshot.data!,
                logo: logo,
              ), //HomeAppDrawer(userEmail: useremail),
              body: HomeTileGrid(
                signedInUser: snapshot.data!,
              ),
              // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
              // floatingActionButton: Padding(
              //   padding: const EdgeInsets.only(top: 65, right: 5),
              //   child: FloatingActionButton.extended(
              //     label: const Text(
              //       "Test Pop Up",
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     //backgroundColor: Colors.blueAccent,
              //     onPressed: () {
              //       showDatePicker(
              //         context: context,
              //         initialDate: DateTime.now(),
              //         firstDate: DateTime(2000),
              //         lastDate: DateTime(2100),
              //       );
              //       // showDialog(
              //       //   context: context,
              //       //   builder: (context) =>
              //       //       const MyErrorMessage(errorType: "Input Error"),
              //       // );
              //     },
              //     icon: const Icon(
              //       Icons.warning,
              //       //color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              //     ),
              //   ),
            );
          } else {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //);
  }
}
