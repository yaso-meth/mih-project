import 'dart:convert';

import 'package:http/http.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import '../mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihBusinessDetailsServices {

  Future<Business?> getBusinessDetails(
    String app_id,
    BuildContext context,
  ) async {
     var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/business/app_id/$app_id"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      return Business.fromJson(jsonBody);
    } else {
      return null;
    }
  }

  Future<Response> createBusinessDetails(
    String appId,
    String busineName,
    String businessType,
    String businessRegistrationNo,
    String businessPracticeNo,
    String businessVatNo,
    String businessEmail,
    String businessPhoneNumber,
    String businessLocation,
    String businessLogoFilename,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/business/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "Name": busineName,
        "type": businessType,
        "registration_no": businessRegistrationNo,
        "logo_name": businessLogoFilename,
        "logo_path": "$appId/business_files/$businessLogoFilename",
        "contact_no": businessPhoneNumber,
        "bus_email": businessEmail,
        "gps_location": businessLocation,
        "practice_no": businessPracticeNo,
        "vat_no": businessVatNo,
      }),
    );
    Navigator.of(context).pop();
    return response;
  }

  Future<int> updateBusinessDetails(
    String business_id,
    String business_name,
    String business_type,
    String business_registration_no,
    String business_practice_no,
    String business_vat_no,
    String business_email,
    String business_phone_number,
    String business_location,
    String business_logo_name,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/business/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "Name": business_name,
        "type": business_type,
        "registration_no": business_registration_no,
        "logo_name": business_logo_name,
        "logo_path": "$business_id/business_files/$business_logo_name",
        "contact_no": business_phone_number,
        "bus_email": business_email,
        "gps_location": business_location,
        "practice_no": business_practice_no,
        "vat_no": business_vat_no,
      }),
    );
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
