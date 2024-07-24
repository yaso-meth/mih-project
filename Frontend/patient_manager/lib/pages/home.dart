import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/patManAppDrawer.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/components/homeTileGrid.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/main.dart';
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

  Future<void> getUserEmail() async {
    var uid = await SuperTokens.getUserId();
    var response = await http.get(Uri.parse("$baseAPI/user/$uid"));
    if (response.statusCode == 200) {
      var user = jsonDecode(response.body);
      useremail = user["email"];
    }
  }

  String getEmail() {
    return useremail;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadImage();
    var logo = MzanziInnovationHub.of(context)!.theme.logoImage();
    return FutureBuilder(
      future: getUserEmail(),
      builder: (contexts, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          //print("home page: $useremail");
          return Scaffold(
            appBar: const MyAppBar(barTitle: "Mzansi Innovation Hub"),
            drawer: PatManAppDrawer(
              userEmail: useremail,
              logo: logo,
            ), //HomeAppDrawer(userEmail: useremail),
            body: HomeTileGrid(
              userEmail: useremail,
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
          //);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
