import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_action.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_body.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_header.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:patient_manager/mih_env/env.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_objects/arguments.dart';
import 'package:patient_manager/mih_objects/business.dart';
import 'package:patient_manager/mih_objects/business_user.dart';
import 'package:patient_manager/mih_objects/notification.dart';
import 'package:patient_manager/mih_packages/mih_home/mih_home.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MIHProfileGetter extends StatefulWidget {
  const MIHProfileGetter({
    super.key,
  });

  @override
  State<MIHProfileGetter> createState() => _MIHProfileGetterState();
}

class _MIHProfileGetterState extends State<MIHProfileGetter> {
  String useremail = "";
  int amount = 10;
  final baseAPI = AppEnviroment.baseApiUrl;
  late Future<HomeArguments> profile;

  String proPicUrl = "empty";
  ImageProvider<Object>? propicFile;

  Future<HomeArguments> getProfile() async {
    AppUser userData;
    Business? busData;
    BusinessUser? bUserData;
    List<MIHNotification> notifi;
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
    var responseBUser = await http.get(
      Uri.parse("$baseAPI/business-user/$uid"),
    );
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

    //Get Notifications
    var responseNotification =
        await http.get(Uri.parse("$baseAPI/notifications/$uid?amount=$amount"));
    if (responseNotification.statusCode == 200) {
      String body = responseNotification.body;
      // var decodedData = jsonDecode(body);
      // MIHNotification notifications = MIHNotification.fromJson(decodedData);

      Iterable l = jsonDecode(body);
      //print("Here2");
      List<MIHNotification> notifications = List<MIHNotification>.from(
          l.map((model) => MIHNotification.fromJson(model)));
      notifi = notifications;
    } else {
      notifi = [];
    }

    //print(userPic);
    return HomeArguments(userData, bUserData, busData, notifi, userPic);
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

  bool isUserNew(AppUser signedInUser) {
    if (signedInUser.fname == "") {
      return true;
    } else {
      return false;
    }
  }

  bool isDevActive() {
    if (AppEnviroment.getEnv() == "Dev") {
      return true;
    } else {
      return false;
    }
  }

  bool isBusinessUser(AppUser signedInUser) {
    if (signedInUser.type == "personal") {
      return false;
    } else {
      return true;
    }
  }

  bool isBusinessUserNew(BusinessUser? businessUser) {
    if (businessUser == null) {
      return true;
    } else {
      return false;
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
            return MIHHome(
              signedInUser: snapshot.requireData.signedInUser,
              businessUser: snapshot.data!.businessUser,
              business: snapshot.data!.business,
              notifications: snapshot.data!.notifi,
              propicFile: isPictureAvailable(snapshot.data!.profilePicUrl),
              isUserNew: isUserNew(snapshot.requireData.signedInUser),
              isBusinessUser: isBusinessUser(snapshot.requireData.signedInUser),
              isBusinessUserNew: isBusinessUserNew(snapshot.data!.businessUser),
              isDevActive: isDevActive(),
            );
          } else {
            return MIHLayoutBuilder(
              actionButton: MIHAction(
                icon: const Icon(Icons.refresh),
                iconSize: 35,
                onTap: () {},
              ),
              header: const MIHHeader(
                headerAlignment: MainAxisAlignment.center,
                headerItems: [
                  Text(
                    "Mzanzi Innovation Hub",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              secondaryActionButton: null,
              body: MIHBody(
                borderOn: false,
                bodyItems: [
                  Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              actionDrawer: null,
              secondaryActionDrawer: null,
              bottomNavBar: null,
              pullDownToRefresh: false,
              onPullDown: () async {},
            );
          }
        }
        return const Mihloadingcircle();
      },
    );
  }
}
