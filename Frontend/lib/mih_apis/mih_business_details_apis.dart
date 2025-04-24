import 'dart:convert';

import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import '../mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihBusinessDetailsApi {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  ///This function is to get the current location of the signed in user.
  ///First checks the permission, if permission is denied (new user), request permission from user.
  ///if user has blocked permission (denied or denied forver), user will get error pop up.
  ///if user has granted permission (while in use), function will return Position object.
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
    print("Here 1");
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
    print("Here 2");
    Navigator.of(context).pop();
    if (response.statusCode == 200) {
      print("Here 3");
      return 200;
    } else {
      print("Here 4");
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
