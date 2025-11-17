import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:provider/provider.dart';
import 'package:supertokens_flutter/supertokens.dart';
import '../mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihMyBusinessUserServices {
  Future<BusinessUser?> getBusinessUser(
    BuildContext context,
  ) async {
    String app_id = await SuperTokens.getUserId();
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/business-user/$app_id"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      // KenLogger.success(response.body);
      BusinessUser? businessUser =
          BusinessUser.fromJson(jsonDecode(response.body));
      context
          .read<MzansiProfileProvider>()
          .setBusinessUser(newBusinessUser: businessUser);
      return businessUser;
    } else {
      return null;
    }
  }

  Future<int> createBusinessUser(
    String business_id,
    String app_id,
    String signatureFilename,
    String title,
    String access,
    MzansiProfileProvider provider,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    String sigPath = "$business_id/business_files/$signatureFilename";
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/business-user/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": app_id,
        "signature": signatureFilename,
        "sig_path": sigPath,
        "title": title,
        "access": access,
      }),
    );
    context.pop();
    if (response.statusCode == 201) {
      provider.setBusinessUser(
        newBusinessUser: BusinessUser(
            0, business_id, app_id, signatureFilename, sigPath, title, access),
      );
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
    MzansiProfileProvider provider,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var filePath = "$app_id/business_files/$signatureFileName";
    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/business-user/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": app_id,
        "signature": signatureFileName,
        "sig_path": filePath,
        "title": bUserTitle,
        "access": bUserAccess,
      }),
    );
    context.pop();
    if (response.statusCode == 200) {
      provider.setBusinessUser(
        newBusinessUser: BusinessUser(
          provider.businessUser!.idbusiness_users,
          business_id,
          app_id,
          signatureFileName,
          filePath,
          bUserTitle,
          bUserAccess,
        ),
      );
      String newProPicUrl = await MihFileApi.getMinioFileUrl(filePath);
      provider.setBusinessUserSignatureUrl(newProPicUrl);
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
