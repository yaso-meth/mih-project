import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
// import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:supertokens_flutter/http.dart' as http;
// import 'package:supertokens_flutter/supertokens.dart';

class MihAuthenticationServices {
  final baseAPI = AppEnviroment.baseApiUrl;

  // Future<void> signUserUp(
  //   TextEditingController emailController,
  //   TextEditingController passwordController,
  //   TextEditingController confirmPasswordController,
  //   BuildContext context,
  // ) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return const Mihloadingcircle();
  //     },
  //   );
  //   try {
  //     Uri uri = Uri.parse(
  //         "$baseAPI/auth/emailpassword/email/exists?email=${emailController.text}");
  //     var response = await http.get(uri);
  //     if (response.statusCode == 200) {
  //       var userExists = jsonDecode(response.body);
  //       if (userExists["exists"]) {
  //         Navigator.of(context).pop();
  //         signUpError(context);
  //       } else {
  //         var response2 = await http.post(
  //           Uri.parse("$baseAPI/auth/signup"),
  //           body:
  //               '{"formFields": [{"id": "email","value": "${emailController.text}"}, {"id": "password","value": "${passwordController.text}"}]}',
  //           headers: {
  //             'Content-type': 'application/json',
  //             'Accept': 'application/json',
  //             "Authorization": "leatucczyixqwkqqdrhayiwzeofkltds"
  //           },
  //         );
  //         //print("response 2: ${response2.statusCode}");
  //         if (response2.statusCode == 200) {
  //           //print("response 2: ${response2.body}");
  //           var userCreated = jsonDecode(response2.body);
  //           //print("Created user $userCreated");
  //           if (userCreated["status"] == "OK") {
  //             //print("Here1");
  //             //Creat user in db
  //             String uid = await SuperTokens.getUserId();
  //             //print("uid: $uid");
  //             await MihUserServices()
  //                 .createUser(emailController.text, uid, context);
  //             // addUserAPICall(emailController.text, uid);
  //             Navigator.of(context).pop();
  //             //print("Here1");
  //           } else if (userCreated["status"] == "FIELD_ERROR") {
  //             Navigator.of(context).pop();
  //             passwordReqError(context);
  //           } else {
  //             Navigator.of(context).pop();
  //             internetConnectionPopUp(context);
  //           }
  //         }
  //       }
  //     }
  //   } on Exception catch (error) {
  //     Navigator.of(context).pop();
  //     loginError(error.toString(), context);
  //     emailController.clear();
  //     passwordController.clear();
  //     confirmPasswordController.clear();
  //   }
  // }

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

  void internetConnectionPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
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

  void passwordReqError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Password Requirements");
      },
    );
  }

  void signUpError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "User Exists");
      },
    );
  }
}
