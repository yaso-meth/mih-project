import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_access_controlls_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_notification_services.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihAccessControlsServices {
  Future<int> getBusinessAccessListOfPatient(
    String app_id,
    MihAccessControllsProvider mihAccessColtrollsProvider,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/access-requests/personal/patient/$app_id"));
    // var errorCode = response.statusCode.toString();
    // print(response.statusCode);
    // print(response.body);

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<PatientAccess> patientAccesses = List<PatientAccess>.from(
          l.map((model) => PatientAccess.fromJson(model)));
      if (response.statusCode == 200) {
        mihAccessColtrollsProvider.setAccessList(patientAccesses);
      }
      return response.statusCode;
    } else {
      throw Exception('failed to pull patient access List for business');
    }
  }

  /// This function is used to create patient access and trigger notification to patient
  ///
  /// Patameters:-
  /// String business_id,
  /// String app_id,
  /// String type,
  /// String requested_by,
  /// BuildContext context,
  ///
  /// Returns void (triggers notification of success 201).
  static Future<void> addPatientAccessAPICall(
    String business_id,
    String app_id,
    String type,
    String requested_by,
    bool personalSelected,
    BusinessArguments args,
    BuildContext context,
  ) async {
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/access-requests/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      // business_id: str
      // app_id: str
      // type: str
      // requested_by: str
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": app_id,
        "type": type,
        "requested_by": requested_by,
      }),
    );
    if (response.statusCode == 201) {
      await MihNotificationApis.addAccessRequestNotificationAPICall(
          app_id, requested_by, personalSelected, args, context);
    } else {
      internetConnectionPopUp(context);
    }
  }

  /// This function is used to reapply for access to patient.
  ///
  /// Patameters:-
  /// String business_id,
  /// String app_id,
  /// BuildContext context,
  ///
  /// Returns void (on success 200 navigate to /mih-access ).
  static Future<void> reapplyPatientAccessAPICall(
    String business_id,
    String app_id,
    bool personalSelected,
    BusinessArguments args,
    BuildContext context,
  ) async {
    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/access-requests/re-apply/"),
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
      }),
    );
    if (response.statusCode == 200) {
      await MihNotificationApis.reapplyAccessRequestNotificationAPICall(
          app_id, personalSelected, args, context);
      //notification here
    } else {
      internetConnectionPopUp(context);
    }
  }

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
