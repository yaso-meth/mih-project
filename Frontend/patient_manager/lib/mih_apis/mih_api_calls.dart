import 'dart:convert';

import 'package:patient_manager/mih_env/env.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_objects/arguments.dart';
import 'package:patient_manager/mih_objects/business.dart';
import 'package:patient_manager/mih_objects/business_user.dart';
import 'package:patient_manager/mih_objects/notification.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MIHApiCalls {
  final baseAPI = AppEnviroment.baseApiUrl;

  /// This function is used to get profile details of signed in user.
  ///
  /// Patameters: int notificationAmount which is used to get number of notifications to show.
  ///
  /// Returns HomeArguments which contains:-
  /// - Signed In user data.
  /// - Business user belongs to.
  /// - Business User details.
  /// - notifications.
  /// - user profile picture.
  Future<HomeArguments> getProfile(int notificationAmount) async {
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
    var responseNotification = await http.get(
        Uri.parse("$baseAPI/notifications/$uid?amount=$notificationAmount"));
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
}
