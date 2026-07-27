import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:provider/provider.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:supertokens_flutter/supertokens.dart';

class MihUserServices {
  final baseAPI = AppEnviroment.baseApiUrl;

  static Future<bool> isUsernameUnique(
    String username,
    BuildContext context,
  ) async {
    var response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/users/validate/username/$username"));
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);

      return jsonBody["available"];
    } else {
      throw Exception(
          "Error: isUsernameUnique status code ${response.statusCode}");
    }
  }

  Future<int> fetchUserCount() async {
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/users/count/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return jsonBody['count'];
    } else {
      return 0;
    }
  }

  Future<void> createUser(
    String email,
    String app_id,
    BuildContext context,
  ) async {
    var response = await http.post(
      Uri.parse("$baseAPI/user/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "email": email,
        "app_id": app_id,
      }),
    );
    if (response.statusCode == 201) {
      await context.read<MzansiProfileProvider>().syncWithMihServerData();
      context.goNamed(
        'mihHome',
        extra: true,
      );
    } else {
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  Future<List<AppUser>> searchUsers(
    MzansiProfileProvider profileProvider,
    String searchText,
    BuildContext context,
  ) async {
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/users/search/$searchText"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<AppUser> users =
          List<AppUser>.from(l.map((model) => AppUser.fromJson(model)));
      profileProvider.setUserearchResults(userSearchResults: users);
      return users;
    } else {
      throw Exception('failed to load users');
    }
  }

  Future<AppUser?> getMIHUserDetails(
    String app_id,
    BuildContext context,
  ) async {
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/user/$app_id"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      return AppUser.fromJson(jsonBody);
    } else {
      return null;
    }
  }

  Future<AppUser?> getMIHUserDetailsV2(
    String app_id,
  ) async {
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/user/$app_id"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      return AppUser.fromJson(jsonBody);
    } else {
      return null;
    }
  }

  Future<AppUser?> getMIHUserDetailsByUsername(
    String username,
    BuildContext context,
  ) async {
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/user/username/$username"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      return AppUser.fromJson(jsonBody);
    } else {
      return null;
    }
  }

  Future<AppUser?> getMyUserDetails(
    MzansiProfileProvider profileProvider,
  ) async {
    String app_id = await SuperTokens.getUserId();
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/user/$app_id"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      profileProvider.setUser(
        newUser: AppUser.fromJson(jsonBody),
      );
      return AppUser.fromJson(jsonBody);
    } else {
      return null;
    }
  }

  Future<AppUser?> getMyUserDetailsV2() async {
    String app_id = await SuperTokens.getUserId();
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/user/$app_id"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      return AppUser.fromJson(jsonBody);
    } else {
      return null;
    }
  }

  Future<int> updateUserV2(
    AppUser signedInUser,
    String firstName,
    String lastName,
    String username,
    String profilePicture,
    String purpose,
    bool isBusinessUser,
    BuildContext context,
  ) async {
    var fileName = profilePicture.replaceAll(RegExp(r' '), '-');
    var filePath = "${signedInUser.app_id}/profile_files/$fileName";
    String profileType;
    if (isBusinessUser) {
      profileType = "business";
    } else {
      profileType = "personal";
    }
    var response = await http
        .put(
          Uri.parse("${AppEnviroment.baseApiUrl}/user/update/v2/"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: jsonEncode(<String, dynamic>{
            "idusers": signedInUser.idUser,
            "username": username,
            "fnam": firstName,
            "lname": lastName,
            "type": profileType,
            "pro_pic_path": filePath,
            "purpose": purpose,
          }),
        )
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      context.read<MzansiProfileProvider>().setUser(
            newUser: AppUser(
              signedInUser.idUser,
              signedInUser.email,
              firstName,
              lastName,
              profileType,
              signedInUser.app_id,
              username,
              filePath,
              purpose,
            ),
          );
      String newProPicUrl = MihFileApi.getMinioFileUrlV2(filePath);
      context.read<MzansiProfileProvider>().setUserProfilePicUrl(newProPicUrl);
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  Future<int> updateUser(
    AppUser signedInUser,
    String firstName,
    String lastName,
    String username,
    String profilePicture,
    bool isBusinessUser,
    BuildContext context,
  ) async {
    var fileName = profilePicture.replaceAll(RegExp(r' '), '-');
    var filePath = "${signedInUser.app_id}/profile_files/$fileName";
    String profileType;
    if (isBusinessUser) {
      profileType = "business";
    } else {
      profileType = "personal";
    }
    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/user/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "idusers": signedInUser.idUser,
        "username": username,
        "fnam": firstName,
        "lname": lastName,
        "type": profileType,
        "pro_pic_path": filePath,
      }),
    );
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  static Future<void> deleteAccount(
    MzansiProfileProvider provider,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http
        .delete(
          Uri.parse("${AppEnviroment.baseApiUrl}/user/delete/all/"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: jsonEncode(<String, dynamic>{
            "app_id": provider.user!.app_id,
            "env": AppEnviroment.getEnv(),
          }),
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      await SuperTokens.signOut(completionHandler: (error) {
        print(error);
      });
      if (await SuperTokens.doesSessionExist() == false) {
        successPopUp(
          "Account Deleted Successfully",
          "Your account has been successfully deleted. We are sorry to see you go, but we respect your decision.",
          context,
        ); // Show success message.
        provider.dispose();
      }
    } else {
      Navigator.of(context).pop(); // Pop loading dialog
      MihAlertServices().internetConnectionAlert(context);
    }
  }

//================== POP UPS ==========================================================================

  static void successPopUp(String title, String message, BuildContext context) {
    MihAlertServices().successAdvancedAlert(
      title,
      message,
      [
        MihButton(
          onPressed: () {
            context.goNamed(
              'mihHome',
              extra: true,
            );
          },
          buttonColor: MihColors.primary(),
          elevation: 10,
          width: 300,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.primary(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      context,
    );
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
