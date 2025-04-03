import 'dart:convert';

import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_env/env.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:supertokens_flutter/supertokens.dart';

class MihUserApis {
  final baseAPI = AppEnviroment.baseApiUrl;

  static Future<void> deleteAccount(
    String app_id,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http.delete(
      Uri.parse("${AppEnviroment.baseApiUrl}/user/delete/all/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": app_id,
        "env": AppEnviroment.getEnv(),
      }),
    );

    if (response.statusCode == 200) {
      await SuperTokens.signOut(completionHandler: (error) {
        print(error);
      });
      if (await SuperTokens.doesSessionExist() == false) {
        Navigator.of(context).pop(); // Pop loading dialog
        Navigator.of(context).pop(); // Pop delete account dialog
        Navigator.of(context).pop(); // Pop Mzansi Profile
        Navigator.of(context).popAndPushNamed(
          '/',
          arguments: AuthArguments(true, false),
        ); //Pop and push to login page
        successPopUp(
          "Account Deleted Successfully",
          context,
        ); // Show success message.
      }
    } else {
      Navigator.of(context).pop(); // Pop loading dialog
      internetConnectionPopUp(context);
    }
  }

  // Future<void> signOut() async {
  //   await SuperTokens.signOut(completionHandler: (error) {
  //     print(error);
  //   });
  //   if (await SuperTokens.doesSessionExist() == false) {
  //     Navigator.of(context).pop();
  //     Navigator.of(context).popAndPushNamed(
  //       '/',
  //       arguments: AuthArguments(true, false),
  //     );
  //   }
  // }

//================== POP UPS ==========================================================================

  static void internetConnectionPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(
          errorType: "Internet Connection",
        );
      },
    );
  }

  static void successPopUp(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MIHSuccessMessage(
          successType: "Success",
          successMessage: message,
        );
      },
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
