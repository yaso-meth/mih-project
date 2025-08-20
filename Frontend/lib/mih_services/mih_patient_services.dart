import 'dart:convert';

import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihPatientServices {
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<Patient?> getPatientDetails(
    String appId,
  ) async {
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/patients/$appId"),
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

  Future<int> addPatientService(
    String id_no,
    String fname,
    String lname,
    String email,
    String cell,
    String medAid,
    String medMainMem,
    String medNo,
    String medAidCode,
    String medName,
    String medScheme,
    String address,
    AppUser signedInUser,
  ) async {
    var response = await http.post(
      Uri.parse("$baseAPI/patients/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "id_no": id_no,
        "first_name": fname,
        "last_name": lname,
        "email": email,
        "cell_no": cell,
        "medical_aid": medAid,
        "medical_aid_main_member": medMainMem,
        "medical_aid_no": medNo,
        "medical_aid_code": medAidCode,
        "medical_aid_name": medName,
        "medical_aid_scheme": medScheme,
        "address": address,
        "app_id": signedInUser.app_id,
      }),
    );
    return response.statusCode;
  }
}
