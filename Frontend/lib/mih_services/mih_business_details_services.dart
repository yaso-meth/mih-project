import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihBusinessDetailsServices {
  Future<int> fetchBusinessCount() async {
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/business/count/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      return jsonBody['count'];
    } else {
      return 0;
    }
  }

  Future<List<String>> fetchAllBusinessTypes() async {
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/business/types/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<String> businessTypes =
          jsonList.map((item) => item['type'].toString()).toList();
      return businessTypes;
    } else {
      return [];
    }
  }

  Future<List<Business>> searchBusinesses(
    String searchText,
    String searchType,
    BuildContext context,
  ) async {
    String newSearchText = "All";
    if (searchText.isNotEmpty) {
      newSearchText = searchText;
    }
    String newSearchType = "All";
    if (searchType.isNotEmpty) {
      newSearchType = searchType;
    }
    if (searchText.isEmpty && searchType.isEmpty) {
      return [];
    }
    var response = await http.get(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/business/search/$newSearchType/$newSearchText"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Business> businesses =
          List<Business>.from(l.map((model) => Business.fromJson(model)));
      return businesses;
    } else {
      throw Exception('failed to load users');
    }
  }

  Future<Business?> getBusinessDetailsByUser(
    MzansiProfileProvider profileProvider,
  ) async {
    String app_id = await SuperTokens.getUserId();
    var response = await http.get(
      Uri.parse("${AppEnviroment.baseApiUrl}/business/app_id/$app_id"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      Business? business = Business.fromJson(jsonBody);
      profileProvider.setBusiness(newBusiness: business);
      return business;
    } else {
      return null;
    }
  }

  Future<Business?> getBusinessDetailsByBusinessId(
    String business_id,
  ) async {
    var response = await http.get(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/business/business_id/$business_id"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      return Business.fromJson(jsonBody);
    } else {
      return null;
    }
  }

  Future<Response> createBusinessDetails(
    MzansiProfileProvider provider,
    String busineName,
    String businessType,
    String businessRegistrationNo,
    String businessPracticeNo,
    String businessVatNo,
    String businessEmail,
    String businessPhoneNumber,
    String businessLocation,
    String businessLogoFilename,
    String businessWebsite,
    String businessRating,
    String businessMissionVision,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/business/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "Name": busineName,
        "type": businessType,
        "registration_no": businessRegistrationNo,
        "logo_name": businessLogoFilename,
        "logo_path": "",
        "contact_no": businessPhoneNumber,
        "bus_email": businessEmail,
        "gps_location": businessLocation,
        "practice_no": businessPracticeNo,
        "vat_no": businessVatNo,
        "website": businessWebsite,
        "rating": businessRating,
        "mission_vision": businessMissionVision,
      }),
    );
    context.pop();
    if (response.statusCode == 201) {
      int finalStatusCode = await updateBusinessDetailsV2(
        jsonDecode(response.body)['business_id'],
        busineName,
        businessType,
        businessRegistrationNo,
        businessPracticeNo,
        businessVatNo,
        businessEmail,
        businessPhoneNumber,
        businessLocation,
        businessLogoFilename,
        businessWebsite,
        businessRating,
        businessMissionVision,
        provider,
        context,
      );
      if (finalStatusCode == 200) {
        String logoPath = businessLogoFilename.isNotEmpty
            ? "${jsonDecode(response.body)['business_id']}/business_files/$businessLogoFilename"
            : "";
        provider.setBusiness(
          newBusiness: Business(
            jsonDecode(response.body)['business_id'],
            busineName,
            businessType,
            businessRegistrationNo,
            businessLogoFilename,
            logoPath,
            businessPhoneNumber,
            businessEmail,
            provider.user!.app_id,
            businessLocation,
            businessPracticeNo,
            businessVatNo,
            businessWebsite,
            businessRating,
            businessMissionVision,
          ),
        );
      }
    }
    return response;
  }

  Future<int> updateBusinessDetailsV2(
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
    String businessWebsite,
    String businessRating,
    String businessMissionVision,
    MzansiProfileProvider provider,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var filePath = "$business_id/business_files/$business_logo_name";
    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/business/update/v2/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "Name": business_name,
        "type": business_type,
        "registration_no": business_registration_no,
        "logo_name": business_logo_name,
        "logo_path": filePath,
        "contact_no": business_phone_number,
        "bus_email": business_email,
        "gps_location": business_location,
        "practice_no": business_practice_no,
        "vat_no": business_vat_no,
        "website": businessWebsite,
        "rating": businessRating,
        "mission_vision": businessMissionVision,
      }),
    );
    context.pop();
    if (response.statusCode == 200) {
      provider.setBusiness(
        newBusiness: Business(
          business_id,
          business_name,
          business_type,
          business_registration_no,
          business_logo_name,
          filePath,
          business_phone_number,
          business_email,
          business_id,
          business_location,
          business_practice_no,
          business_vat_no,
          businessWebsite,
          businessRating,
          businessMissionVision,
        ),
      );
      String newProPicUrl = await MihFileApi.getMinioFileUrl(filePath);
      provider.setBusinessProfilePicUrl(newProPicUrl);
      return 200;
    } else {
      return 500;
    }
  }

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
    Navigator.of(context).pop();
    if (response.statusCode == 200) {
      return 200;
    } else {
      return 500;
    }
  }
}
