import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/user_consent.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:provider/provider.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:supertokens_flutter/supertokens.dart';

class MihUserConsentServices {
  Future<void> getUserConsentStatus(
    BuildContext context,
  ) async {
    var app_id = await SuperTokens.getUserId();
    final response = await http.get(
        Uri.parse("${AppEnviroment.baseApiUrl}/user-consent/user/$app_id"));
    if (response.statusCode == 200) {
      Map<String, dynamic> userMap = jsonDecode(response.body);
      UserConsent userConsent = UserConsent.fromJson(userMap);
      context.read<MzansiProfileProvider>().setUserConsent(userConsent);
      // return userConsent;
    }
    // else {
    //   return null;
    // }
  }

  Future<int> insertUserConsentStatus(
    String latestPrivacyPolicyDate,
    String latestTermOfServiceDate,
    MzansiProfileProvider provider,
    BuildContext context,
  ) async {
    UserConsent userConsent = UserConsent(
      app_id: provider.user!.app_id,
      privacy_policy_accepted: DateTime.parse(latestPrivacyPolicyDate),
      terms_of_services_accepted: DateTime.parse(latestTermOfServiceDate),
    );
    final response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/user-consent/insert/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userConsent.toJson()),
    );
    provider.setUserConsent(userConsent);
    return response.statusCode;
  }

  Future<int> updateUserConsentStatus(
    String latestPrivacyPolicyDate,
    String latestTermOfServiceDate,
    MzansiProfileProvider provider,
    BuildContext context,
  ) async {
    UserConsent userConsent = UserConsent(
      app_id: provider.user!.app_id,
      privacy_policy_accepted: DateTime.parse(latestPrivacyPolicyDate),
      terms_of_services_accepted: DateTime.parse(latestTermOfServiceDate),
    );
    final response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/user-consent/update"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userConsent.toJson()),
    );
    provider.setUserConsent(userConsent);
    return response.statusCode;
  }
}
