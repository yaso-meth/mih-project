import 'dart:convert';

import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import '../mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihMyBusinessUserApi {
  Future<int> createBusinessUser(
    String business_id,
    String app_id,
    String signatureFilename,
    String title,
    String access,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/business-user/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": app_id,
        "signature": signatureFilename,
        "sig_path": "$business_id/business_files/$signatureFilename",
        "title": title,
        "access": access,
      }),
    );
    Navigator.of(context).pop();
    if (response.statusCode == 201) {
      return 201;
    } else {
      internetConnectionPopUp(context);
      return 500;
    }
  }

  /// This function updates the business user details.
  Future<int> updateBusinessUser(
    String app_id,
    String business_id,
    String bUserTitle,
    String bUserAccess,
    String signatureFileName,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/business-user/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": app_id,
        "signature": signatureFileName,
        "sig_path": "$app_id/business_files/$signatureFileName",
        "title": bUserTitle,
        "access": bUserAccess,
      }),
    );
    // var response = await http.put(
    //   Uri.parse("${AppEnviroment.baseApiUrl}/business/update/"),
    //   headers: <String, String>{
    //     "Content-Type": "application/json; charset=UTF-8"
    //   },
    //   body: jsonEncode(<String, dynamic>{
    //     "business_id": business_id,
    //     "Name": business_name,
    //     "type": business_type,
    //     "registration_no": business_registration_no,
    //     "logo_name": business_logo_name,
    //     "logo_path": "$business_id/business_files/$business_logo_name",
    //     "contact_no": business_phone_number,
    //     "bus_email": business_email,
    //     "gps_location": business_location,
    //     "practice_no": business_practice_no,
    //     "vat_no": business_vat_no,
    //   }),
    // );
    Navigator.of(context).pop();
    if (response.statusCode == 200) {
      return 200;
    } else {
      internetConnectionPopUp(context);
      return 500;
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
}
