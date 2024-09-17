import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mihLoadingCircle.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/MIH_Packages/MIH_Home/homeTileGrid.dart';
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
        userPic = "";
        // throw Exception(
        //     "Error: GetUserData status code ${response.statusCode}");
      }
    }
    //print(userPic);
    return HomeArguments(userData, bUserData, busData, userPic);
  }

  ImageProvider<Object>? isPictureAvailable(String url) {
    if (url == "") {
      return const AssetImage('images/i-dont-know-2.png');
    } else if (url != "") {
      return NetworkImage(url);
    } else {
      return null;
    }
  }

// <a href="https://www.flaticon.com/free-icons/dont-know" title="dont know icons">Dont know icons created by Freepik - Flaticon</a>
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
              propicFile: isPictureAvailable(snapshot.data!.profilePicUrl),
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
