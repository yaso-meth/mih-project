import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihProfileLinksServices {
  final baseAPI = AppEnviroment.baseApiUrl;
  List<String> linkOptions = [
    "App Store",
    "App Gallery",
    "Play Store",
    "YouTube",
    "TikTok",
    "Twitch",
    "Threads",
    "WhatsApp",
    "Instagram",
    "X",
    "LinkedIn",
    "Facebook",
    "Reddit",
    "Discord",
    "Git",
    "Telegram",
    "Pinterest",
    "Snapchat",
    "Messenger",
    "Medium",
    "Substack",
    "Spotify",
    "YT Music",
    "Apple Music",
    "Patreon",
    "Loolio",
    "WeChat",
    "Other"
  ];

  static Future<List<ProfileLink>> getUserProfileLinksMD(
    MzansiDirectoryProvider directoryProvider,
    String app_id,
  ) async {
    final response = await http.get(
        Uri.parse("${AppEnviroment.baseApiUrl}/profile-links/user/$app_id"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<ProfileLink> myLinks =
          List<ProfileLink>.from(l.map((model) => ProfileLink.fromJson(model)));
      return myLinks;
    } else {
      throw Exception('failed to fecth user profile links');
    }
  }

  static Future<void> getUserProfileLinks(
    MzansiProfileProvider profileProvider,
    String app_id,
  ) async {
    final response = await http.get(
        Uri.parse("${AppEnviroment.baseApiUrl}/profile-links/user/$app_id"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<ProfileLink> myLinks =
          List<ProfileLink>.from(l.map((model) => ProfileLink.fromJson(model)));
      profileProvider.setPersonalLinks(personalLinks: myLinks);
    } else {
      throw Exception('failed to fecth user profile links');
    }
  }

  static Future<List<ProfileLink>> getUserProfileLinksV2(
    String app_id,
  ) async {
    final response = await http.get(
        Uri.parse("${AppEnviroment.baseApiUrl}/profile-links/user/$app_id"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<ProfileLink> myLinks =
          List<ProfileLink>.from(l.map((model) => ProfileLink.fromJson(model)));
      return myLinks;
    } else {
      throw Exception('failed to fecth user profile links');
    }
  }

  static Future<List<ProfileLink>> getBusinessProfileLinksMD(
    String business_id,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/profile-links/business/$business_id"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<ProfileLink> myLinks =
          List<ProfileLink>.from(l.map((model) => ProfileLink.fromJson(model)));
      return myLinks;
    } else {
      throw Exception('failed to fecth user profile links');
    }
  }

  static Future<void> getBusinessProfileLinks(
    MzansiProfileProvider profileProvider,
    String business_id,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/profile-links/business/$business_id"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<ProfileLink> myLinks =
          List<ProfileLink>.from(l.map((model) => ProfileLink.fromJson(model)));
      profileProvider.setBusinessLinks(businessLinks: myLinks);
    } else {
      throw Exception('failed to fecth user profile links');
    }
  }

  static Future<List<ProfileLink>> getBusinessProfileLinksV2(
    String business_id,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/profile-links/business/$business_id"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<ProfileLink> myLinks =
          List<ProfileLink>.from(l.map((model) => ProfileLink.fromJson(model)));
      return myLinks;
    } else {
      throw Exception('failed to fecth user profile links');
    }
  }

  static Future<int> deleteProfileLink(
    MzansiProfileProvider profileProvider,
    int idprofile_links,
  ) async {
    final response = await http
        .delete(
          Uri.parse("${AppEnviroment.baseApiUrl}/profile-links/delete/"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: jsonEncode(
            <String, dynamic>{
              "idprofile_links": idprofile_links,
            },
          ),
        )
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      profileProvider.deleteProfileLink(linkId: idprofile_links);
    }
    return response.statusCode;
  }

  static Future<int> addProfileLink(
    MzansiProfileProvider profileProvider,
    String app_id,
    String business_id,
    String site_name,
    String custom_name,
    String destination,
    int order,
  ) async {
    var response = await http
        .post(
          Uri.parse("${AppEnviroment.baseApiUrl}/profile-links/insert/"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: jsonEncode(<String, dynamic>{
            "app_id": app_id,
            "business_id": business_id,
            "site_name": site_name,
            "custom_name": custom_name,
            "destination": destination,
            "order": order,
          }),
        )
        .timeout(const Duration(seconds: 5));
    KenLogger.success("Response: $response.statusCode");
    // if (response.statusCode == 201) {
    //   if (app_id == "") {
    //     await getUserProfileLinks(profileProvider, app_id);
    //   } else {
    //     await getBusinessProfileLinks(profileProvider, business_id);
    //   }
    // }
    return response.statusCode;
  }

  static Future<int> updateProfileLink(
    MzansiProfileProvider profileProvider,
    int idprofile_links,
    String app_id,
    String business_id,
    String site_name,
    String custom_name,
    String destination,
    int order,
    BuildContext context,
  ) async {
    final response = await http
        .put(
          Uri.parse("${AppEnviroment.baseApiUrl}/profile-links/update/"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: jsonEncode(<String, dynamic>{
            "idprofile_links": idprofile_links,
            "site_name": site_name,
            "custom_name": custom_name,
            "destination": destination,
            "order": order,
          }),
        )
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      profileProvider.editProfileLink(
        updatedLink: ProfileLink(
          idprofile_links: idprofile_links,
          app_id: app_id,
          business_id: business_id,
          site_name: site_name,
          custom_name: custom_name,
          destination: destination,
          order: order,
        ),
      );
    }
    return response.statusCode;
  }

  static void loadingPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
  }
}
