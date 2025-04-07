import 'dart:convert';

import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_objects/claim_statement_file.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

import '../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../mih_env/env.dart';

class MIHClaimStatementGenerationApi {
  final baseAPI = AppEnviroment.baseApiUrl;

  /// This function is used to generate and store a claim/ statement.
  ///
  /// Patameters: TBC .
  ///
  /// Returns TBC.
  Future<void> generateClaimStatement(
    ClaimStatementGenerationArguments data,
    PatientViewArguments args,
    BuildContext context,
  ) async {
    //start loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );

    var response1 = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/minio/generate/claim-statement/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "document_type": data.document_type,
        "patient_app_id": data.patient_app_id,
        "patient_full_name": data.patient_full_name,
        "patient_id_no": data.patient_id_no,
        "has_med_aid": data.has_med_aid,
        "med_aid_no": data.med_aid_no,
        "med_aid_code": data.med_aid_code,
        "med_aid_name": data.med_aid_name,
        "med_aid_scheme": data.med_aid_scheme,
        "busName": data.busName,
        "busAddr": data.busAddr,
        "busNo": data.busNo,
        "busEmail": data.busEmail,
        "provider_name": data.provider_name,
        "practice_no": data.practice_no,
        "vat_no": data.vat_no,
        "service_date": data.service_date,
        "service_desc": data.service_desc,
        "service_desc_option": data.service_desc_option,
        "procedure_name": data.procedure_name,
        "procedure_additional_info": data.procedure_additional_info,
        "icd10_code": data.icd10_code,
        "amount": data.amount,
        "pre_auth_no": data.pre_auth_no,
        "logo_path": data.logo_path,
        "sig_path": data.sig_path,
      }),
    );
    //print(response1.statusCode);
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    String fileName =
        "${data.document_type}-${data.patient_full_name}-${date.toString().substring(0, 10)}.pdf";
    if (response1.statusCode == 200) {
      //Update this API
      var response2 = await http.post(
        Uri.parse("${AppEnviroment.baseApiUrl}/files/claim-statement/insert/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{
          "app_id": data.patient_app_id,
          "business_id": args.business!.business_id,
          "file_path": "${data.patient_app_id}/claims-statements/$fileName",
          "file_name": fileName
        }),
      );
      if (response2.statusCode == 201) {
        // end loading circle
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context)
            .pushNamed('/patient-manager/patient', arguments: args);
        String message =
            "The ${data.document_type}: $fileName has been successfully generated and added to ${data.patient_full_name}'s record. You can now access and download it for their use.";
        successPopUp(message, context);
      } else {
        internetConnectionPopUp(context);
      }
    } else {
      internetConnectionPopUp(context);
    }
  }

  /// This function is used to fetch a list of claim/ statement files for a ptient.
  ///
  /// Patameters: app_id .
  ///
  /// Returns List<ClaimStatementFile>.
  static Future<List<ClaimStatementFile>> getClaimStatementFilesByPatient(
    String app_id,
  ) async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/files/claim-statement/patient/$app_id"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    // errorCode = response.statusCode.toString();
    // errorBody = response.body;

    if (response.statusCode == 200) {
      //print("Here1");
      Iterable l = jsonDecode(response.body);
      //print("Here2");
      List<ClaimStatementFile> docList = List<ClaimStatementFile>.from(
          l.map((model) => ClaimStatementFile.fromJson(model)));
      //print("Here3");
      //print(patientQueue);
      return docList;
    } else {
      throw Exception(
          'failed to fatch patient claims statement files with api');
    }
  }

  /// This function is used to fetch a list of claim/ statement files for a business.
  ///
  /// Patameters: business_id .
  ///
  /// Returns List<ClaimStatementFile>.
  static Future<List<ClaimStatementFile>> getClaimStatementFilesByBusiness(
    String business_id,
  ) async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/files/claim-statement/business/$business_id"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    // errorCode = response.statusCode.toString();
    // errorBody = response.body;

    if (response.statusCode == 200) {
      //print("Here1");
      Iterable l = jsonDecode(response.body);
      //print("Here2");
      List<ClaimStatementFile> docList = List<ClaimStatementFile>.from(
          l.map((model) => ClaimStatementFile.fromJson(model)));
      //print("Here3");
      //print(patientQueue);
      return docList;
    } else {
      throw Exception(
          'failed to fatch business claims statement files with api');
    }
  }

  /// This function is used to Delete loyalty card from users mzansi wallet.
  ///
  /// Patameters:-
  /// AppUser signedInUser,
  /// int idloyalty_cards,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS NOTIGICATIOPN ON SUCCESS)
  static Future<void> deleteClaimStatementFilesByFileID(
    PatientViewArguments args,
    String filePath,
    int fileID,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    // delete file from minio
    var response = await http.delete(
      Uri.parse("${AppEnviroment.baseApiUrl}/minio/delete/file/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{"file_path": filePath}),
    );
    //print("Here4");
    //print(response.statusCode);
    if (response.statusCode == 200) {
      //SQL delete
      var response2 = await http.delete(
        Uri.parse("${AppEnviroment.baseApiUrl}/files/claim-statement/delete/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{"idclaim_statement_file": fileID}),
      );
      if (response2.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        //print(widget.business);

        Navigator.of(context)
            .pushNamed('/patient-manager/patient', arguments: args);

        // Navigator.of(context)
        //     .pushNamed('/patient-profile', arguments: widget.signedInUser);
        // setState(() {});
        String message =
            "The File has been deleted successfully. This means it will no longer be visible on your and cannot be used for future appointments.";
        successPopUp(message, context);
      } else {
        internetConnectionPopUp(context);
      }
    } else {
      internetConnectionPopUp(context);
    }
  }

  //================== POP UPS ==========================================================================

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

  static void successPopUp(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MIHSuccessMessage(
          successType: "Success",
          successMessage: message,
        );
      },
    );
  }
}
