import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/popUpMessages/mihLoadingCircle.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/components/homeTileGrid.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/arguments.dart';
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
  late Future<HomeArguments> profile;

  String proPicUrl = "empty";
  ImageProvider<Object>? propicFile;

  Future<HomeArguments> getProfile() async {
    AppUser userData;
    Business? busData;
    BusinessUser? bUserData;
    String userPic;

    // Get Userdata
    var uid = await SuperTokens.getUserId();
    var responseUser = await http.get(Uri.parse("$baseAPI/user/$uid"));
    if (responseUser.statusCode == 200) {
      // print("here");
      String body = responseUser.body;
      var decodedData = jsonDecode(body);
      AppUser u = AppUser.fromJson(decodedData);
      userData = u;
    } else {
      throw Exception(
          "Error: GetUserData status code ${responseUser.statusCode}");
    }

    // Get BusinessUserdata
    var responseBUser =
        await http.get(Uri.parse("$baseAPI/business-user/$uid"));
    if (responseBUser.statusCode == 200) {
      String body = responseBUser.body;
      var decodedData = jsonDecode(body);
      BusinessUser business_User = BusinessUser.fromJson(decodedData);
      bUserData = business_User;
    } else {
      bUserData = null;
    }

    // Get Businessdata
    var responseBusiness =
        await http.get(Uri.parse("$baseAPI/business/app_id/$uid"));
    if (responseBusiness.statusCode == 200) {
      String body = responseBusiness.body;
      var decodedData = jsonDecode(body);
      Business business = Business.fromJson(decodedData);
      busData = business;
    } else {
      busData = null;
    }

    //get profile picture
    if (userData.pro_pic_path == "") {
      userPic = "";
    }
    // else if (AppEnviroment.getEnv() == "Dev") {
    //   userPic = "${AppEnviroment.baseFileUrl}/mih/${userData.pro_pic_path}";
    // }
    else {
      var url =
          "${AppEnviroment.baseApiUrl}/minio/pull/file/${AppEnviroment.getEnv()}/${userData.pro_pic_path}";
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String body = response.body;
        var decodedData = jsonDecode(body);

        userPic = decodedData['minioURL'];
      } else {
        throw Exception(
            "Error: GetUserData status code ${response.statusCode}");
      }
    }
    print(userPic);
    return HomeArguments(userData, bUserData, busData, userPic);
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

  Future<String> getFileUrlApiCall(AppUser signedInUser) async {
    if (signedInUser.pro_pic_path == "") {
      return "";
    } else if (AppEnviroment.getEnv() == "Dev") {
      return "${AppEnviroment.baseFileUrl}/mih/${signedInUser.pro_pic_path}";
    } else {
      var url =
          "${AppEnviroment.baseApiUrl}/minio/pull/file/${signedInUser.pro_pic_path}/prod";
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
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    profile = getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: profile,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return HomeTileGrid(
              signedInUser: snapshot.requireData.signedInUser,
              businessUser: snapshot.data!.businessUser,
              business: snapshot.data!.business,
              propicFile: NetworkImage(snapshot.data!.profilePicUrl),
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
