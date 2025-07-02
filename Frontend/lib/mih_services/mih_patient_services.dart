import 'dart:convert';

import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihPatientServices {
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<Patient?> getPatientDetails(
    String appId,
  ) async {
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/patient/app_id/$appId"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      return Patient.fromJson(jsonBody);
    } else {
      return null;
    }
  }
}
