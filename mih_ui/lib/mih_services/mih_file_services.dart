import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:http/http.dart' as http2;
import 'package:supertokens_flutter/supertokens.dart';

class MihFileApi {
  final baseAPI = AppEnviroment.baseApiUrl;

  // static Future<String> getMinioFileUrl(
  //   String filePath,
  // ) async {network
  //   String fileUrl = "";
  //   try {
  //     var url =
  //         "${AppEnviroment.baseApiUrl}/minio/pull/file/${AppEnviroment.getEnv()}/$filePath";
  //     var response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       var decodedData = jsonDecode(response.body);
  //       fileUrl = decodedData['minioURL'];
  //     } else {}
  //   } catch (e) {
  //     KenLogger.error("Error getting url");
  //   } finally {}
  //   if (AppEnviroment.getEnv() == "Dev" && kIsWeb) {
  //     fileUrl = fileUrl.replaceAll("10.0.2.2", "127.0.0.1");
  //   } else if (AppEnviroment.getEnv() == "Dev" && Platform.isIOS) {
  //     fileUrl = fileUrl.replaceAll("10.0.2.2", "127.0.0.1");
  //   } else if (AppEnviroment.getEnv() == "Dev" && Platform.isLinux) {
  //     fileUrl = fileUrl.replaceAll("10.0.2.2", "127.0.0.1");
  //   }
  //   return fileUrl;
  // }

  static String getMinioFileUrlV2(
    String filePath,
  ) {
    if (filePath.isEmpty) return "";
    return "${AppEnviroment.baseApiUrl}/v2/minio/pull/file/$filePath";
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
    request.files.add(
      http2.MultipartFile.fromBytes(
        'file',
        await file!.readAsBytes(),
        filename: file.name.replaceAll(RegExp(r' '), '-'),
      ),
    );
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

//================== POP UPS ==========================================================================

  static void loadingPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
  }
}
