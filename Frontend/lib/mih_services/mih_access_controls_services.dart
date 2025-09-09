import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihAccessControlsServices {
  /// This function is used to UPDATE access the business has.
  ///
  /// Patameters:-
  /// String business_id,
  /// String business_name,
  /// String app_id,
  /// String status,
  /// String approved_by,
  /// AppUser signedInUser,
  /// BuildContext context,
  ///
  /// Returns void (on success 200 navigate to /mih-access ).
  Future<int> updatePatientAccessAPICall(
    String business_id,
    String business_name,
    String app_id,
    String status,
    String approved_by,
    AppUser signedInUser,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http.put(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/access-requests/update/permission/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      // business_id: str
      // app_id: str
      // status: str
      // approved_by: str
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": app_id,
        "status": status,
        "approved_by": approved_by,
      }),
    );
    context.pop();
    return response.statusCode;
    // if (response.statusCode == 200) {
    //   //Navigator.of(context).pushNamed('/home');
    //   Navigator.of(context).pop();
    //   Navigator.of(context).pop();
    //   Navigator.of(context).pushNamed(
    //     '/mih-access',
    //     arguments: signedInUser,
    //   );
    //   String message = "";
    //   if (status == "approved") {
    //     message =
    //         "You've successfully approved the access request! $business_name now has access to your profile forever.";
    //   } else {
    //     message =
    //         "You've declined the access request. $business_name will not have access to your profile.";
    //   }
    //   successPopUp(message, context);
    // } else {
    //   internetConnectionPopUp(context);
    // }
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
