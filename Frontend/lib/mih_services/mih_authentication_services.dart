import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihAuthenticationServices {
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<bool> signUserIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    //var _backgroundColor = Colors.transparent;
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var response = await http.post(
      Uri.parse("$baseAPI/auth/signin"),
      body:
          '{"formFields": [{"id": "email","value": "$email"}, {"id": "password","value": "$password"}]}',
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "leatucczyixqwkqqdrhayiwzeofkltds"
      },
    );
    if (response.statusCode == 200) {
      var userSignedin = jsonDecode(response.body);
      if (userSignedin["status"] == "OK") {
        context.pop();
        return true;
      } else {
        context.pop();
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> forgotPassword(
    String email,
  ) async {
    var response = await http.post(
      Uri.parse("$baseAPI/auth/user/password/reset/token"),
      body: '{"formFields": [{"id": "email","value": "$email"}]}',
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      var userSignedin = jsonDecode(response.body);
      if (userSignedin["status"] == "OK") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> resetPassword(
    String token,
    String password,
  ) async {
    var response = await http.post(
      Uri.parse("$baseAPI/auth/user/password/reset"),
      body:
          '{"method": "token","formFields": [{"id": "password","value": "$password"}],"token": "$token"}',
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      var userSignedin = jsonDecode(response.body);
      if (userSignedin["status"] == "OK") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void loginError(String error, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(error),
        );
      },
    );
  }

  void signUpError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          backgroundColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          windowBody: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              Center(
                child: Text(
                  "Email Already Exists",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Here are some things to keep in mind:",
                style: TextStyle(
                  color: MihColors.getRedColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "1) Are you sure you're using the correct email address associated with your account?\n2) Is your caps lock key on? Passwords are case-sensitive.\n3) If you've forgotten your password, no worries! Click on \"Forgot Password?\" to reset it.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: () {
                  context.pop();
                },
                buttonColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                width: 300,
                elevation: 10,
                child: Text(
                  "Dismiss",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
