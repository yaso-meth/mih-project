import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:provider/provider.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:supertokens_flutter/supertokens.dart';

class MihAuthenticationServices {
  final baseAPI = AppEnviroment.baseApiUrl;

  bool validEmail(String email) {
    var regex = RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
    return regex.hasMatch(email);
  }

  Future<void> signUserUp(
    String email,
    String password,
    String confirmPassword,
    BuildContext context,
  ) async {
    context.read<MzansiProfileProvider>().reset();
    if (!validEmail(email)) {
      MihAlertServices().invalidEmailAlert(context);
    } else if (password != confirmPassword) {
      MihAlertServices().passwordMatchAlert(context);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const Mihloadingcircle();
        },
      );
      try {
        Uri uri =
            Uri.parse("$baseAPI/auth/emailpassword/email/exists?email=$email");
        var response = await http.get(uri);
        if (response.statusCode == 200) {
          var userExists = jsonDecode(response.body);
          if (userExists["exists"]) {
            context.pop();
            MihAlertServices().emailExistsAlert(context);
          } else {
            var response2 = await http.post(
              Uri.parse("$baseAPI/auth/signup"),
              body:
                  '{"formFields": [{"id": "email","value": "$email"}, {"id": "password","value": "$password"}]}',
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
              },
            );
            if (response2.statusCode == 200) {
              var userCreated = jsonDecode(response2.body);
              if (userCreated["status"] == "OK") {
                TextInput.finishAutofillContext();
                String uid = await SuperTokens.getUserId();
                await MihUserServices().createUser(
                  email,
                  uid,
                  context,
                );
                context.pop();
              } else if (userCreated["status"] == "FIELD_ERROR") {
                context.pop();
                MihAlertServices().passwordRequirementAlert(context);
              } else {
                context.pop();
                MihAlertServices().internetConnectionAlert(context);
                TextInput.finishAutofillContext(shouldSave: false);
              }
            }
          }
        }
      } on Exception catch (error) {
        Navigator.of(context).pop();
        signUpError(error, context);
      }
    }
  }

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
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(error),
        );
      },
    );
  }

  void signUpError(Exception error, BuildContext context) {
    MihAlertServices().errorAdvancedAlert(
      "Sign Up Error",
      "An error occurred while signing up: $error Please try again later.",
      [
        MihButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          buttonColor: MihColors.secondary(),
          width: 200,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.primary(),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      context,
    );
  }
}
