import 'dart:convert';

import 'package:mzansi_innovation_hub/mih_objects/icd10_code.dart.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

import '../mih_config/mih_env.dart';

class MIHIcd10CodeApis {
  final baseAPI = AppEnviroment.baseApiUrl;

  /// This function is used to fetch a list of icd 10 codes based on a search .
  ///
  /// Patameters: String search, BuildContext context
  ///
  /// Returns List<ICD10Code>.
  static Future<List<ICD10Code>> getIcd10Codes(
      String search, BuildContext context) async {
    //print("Patien manager page: $endpoint");
    mihLoadingPopUp(context);

    final response = await http
        .get(Uri.parse("${AppEnviroment.baseApiUrl}/icd10-codes/$search"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    // errorCode = response.statusCode.toString();
    // errorBody = response.body;

    if (response.statusCode == 200) {
      //print("Here1");
      Iterable l = jsonDecode(response.body);
      //print("Here2");
      List<ICD10Code> icd10Codes =
          List<ICD10Code>.from(l.map((model) => ICD10Code.fromJson(model)));
      //print("Here3");
      //print(patientQueue);
      Navigator.of(context).pop();
      return icd10Codes;
    } else {
      Navigator.of(context).pop();
      throw Exception('failed to fetch icd-10 codes with api');
    }
  }

  static void mihLoadingPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
  }
}
