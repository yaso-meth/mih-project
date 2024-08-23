import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/mihLoadingCircle.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/components/homeTileGrid.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/business.dart';
import 'package:patient_manager/objects/businessUser.dart';
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
      //setState(() {
      //_widgetOptions = setLayout(u);
      //});
      return u;
    } else {
      throw Exception("Error: GetUserData status code ${response.statusCode}");
    }
  }

  Future<BusinessUser?> getBusinessUserDetails() async {
    var uid = await SuperTokens.getUserId();
    var response = await http.get(Uri.parse("$baseAPI/business-user/$uid"));
    if (response.statusCode == 200) {
      String body = response.body;
      var decodedData = jsonDecode(body);
      BusinessUser business_User = BusinessUser.fromJson(decodedData);
      return business_User;
    } else {
      return null;
    }
  }

  Future<Business?> getBusinessDetails() async {
    var uid = await SuperTokens.getUserId();
    var response = await http.get(Uri.parse("$baseAPI/business/app_id/$uid"));
    if (response.statusCode == 200) {
      String body = response.body;
      var decodedData = jsonDecode(body);
      Business business = Business.fromJson(decodedData);
      return business;
    } else {
      return null;
    }
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
    return FutureBuilder(
      future: Future.wait(
          [getUserDetails(), getBusinessUserDetails(), getBusinessDetails()]),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return HomeTileGrid(
              signedInUser: snapshot.requireData[0] as AppUser,
              businessUser: snapshot.data![1] as BusinessUser?,
              business: snapshot.data![2] as Business?,
            );
          } else {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
          }
        }
        return const Mihloadingcircle();
      },
    );
  }
}
