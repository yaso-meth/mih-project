import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:http/http.dart' as http2;
import 'package:supertokens_flutter/supertokens.dart';

class MihFileApi {
  final baseAPI = AppEnviroment.baseApiUrl;

  static Future<String> getMinioFileUrl(
    String filePath,
    BuildContext context,
  ) async {
    // loadingPopUp(context);
    // print("here");
    // var url =
    //     "${AppEnviroment.baseApiUrl}/minio/pull/file/${AppEnviroment.getEnv()}/$filePath";
    // var response = await http.get(Uri.parse(url));
    String fileUrl = "";
    // print(response.statusCode);
    // if (response.statusCode == 200) {
    //   String body = response.body;
    //   var decodedData = jsonDecode(body);

    //   fileUrl = decodedData['minioURL'];
    // } else {
    //   fileUrl = "";
    // }
    // Navigator.of(context).pop(); // Pop loading dialog
    // return fileUrl;
    try {
      var url =
          "${AppEnviroment.baseApiUrl}/minio/pull/file/${AppEnviroment.getEnv()}/$filePath";
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        fileUrl = decodedData['minioURL'];
      } else {
        // internetConnectionPopUp(context);
        KenLogger.error("Get File Error: $url");
        KenLogger.error("Get File Error: ${response.statusCode}");
        KenLogger.error("Get File Error: ${response.body}");
      }
    } catch (e) {
      // internetConnectionPopUp(context);
      print("Error getting url");
    } finally {
      // Navigator.of(context).pop(); // Always pop loading dialog
    }
    return fileUrl;
  }

  static Future<int> uploadFile(
    String app_id,
    String env,
    String folderName,
    PlatformFile? file,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var token = await SuperTokens.getAccessToken();
    var request = http2.MultipartRequest(
        'POST', Uri.parse("${AppEnviroment.baseApiUrl}/minio/upload/file/"));
    request.headers['accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['app_id'] = app_id;
    request.fields['env'] = env;
    request.fields['folder'] = folderName;
    request.files.add(await http2.MultipartFile.fromBytes('file', file!.bytes!,
        filename: file.name.replaceAll(RegExp(r' '), '-')));
    var response = await request.send();
    context.pop(); // Pop loading dialog
    return response.statusCode;
  }

  static Future<int> deleteFile(
    String app_id,
    String env,
    String folderName,
    String fileName,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var fname = fileName.replaceAll(RegExp(r' '), '-');
    var filePath = "$app_id/$folderName/$fname";
    var response = await http.delete(
      Uri.parse("${AppEnviroment.baseApiUrl}/minio/delete/file/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "file_path": filePath,
        "env": env,
      }),
    );
    context.pop(); // Pop loading dialog
    return response.statusCode;
  }

  // Future<void> signOut() async {
  //   await SuperTokens.signOut(completionHandler: (error) {
  //     print(error);
  //   });
  //   if (await SuperTokens.doesSessionExist() == false) {
  //     Navigator.of(context).pop();
  //     Navigator.of(context).popAndPushNamed(
  //       '/',
  //       arguments: AuthArguments(true, false),
  //     );
  //   }
  // }

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

  static void loadingPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
  }
}
