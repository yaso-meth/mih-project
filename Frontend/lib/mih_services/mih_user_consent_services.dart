import 'dart:convert';

import 'package:mzansi_innovation_hub/mih_components/mih_objects/user_consent.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:supertokens_flutter/supertokens.dart';

class MihUserConsentServices {
  Future<UserConsent?> getUserConsentStatus() async {
    var app_id = await SuperTokens.getUserId();
    final response = await http.get(
        Uri.parse("${AppEnviroment.baseApiUrl}/user-consent/user/$app_id"));
    if (response.statusCode == 200) {
      Map<String, dynamic> userMap = jsonDecode(response.body);
      UserConsent userConsent = UserConsent.fromJson(userMap);
      return userConsent;
    } else {
      return null;
    }
  }

  Future<int> insertUserConsentStatus(
    String app_id,
    String latestPrivacyPolicyDate,
    String latestTermOfServiceDate,
  ) async {
    UserConsent userConsent = UserConsent(
      app_id: app_id,
      privacy_policy_accepted: DateTime.parse(latestPrivacyPolicyDate),
      terms_of_services_accepted: DateTime.parse(latestTermOfServiceDate),
    );
    final response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/user-consent/insert/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userConsent.toJson()),
    );
    return response.statusCode;
  }

  Future<int> updateUserConsentStatus(
    String app_id,
    String latestPrivacyPolicyDate,
    String latestTermOfServiceDate,
  ) async {
    UserConsent userConsent = UserConsent(
      app_id: app_id,
      privacy_policy_accepted: DateTime.parse(latestPrivacyPolicyDate),
      terms_of_services_accepted: DateTime.parse(latestTermOfServiceDate),
    );
    final response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/user-consent/update"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userConsent.toJson()),
    );
    return response.statusCode;
  }
}
