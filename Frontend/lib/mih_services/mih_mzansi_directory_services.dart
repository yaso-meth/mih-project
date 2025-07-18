import 'dart:convert';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_review.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihMzansiDirectoryServices {
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<BusinessReview?> getUserReviewOfBusiness(
    String app_id,
    String business_id,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/mzasni-directory/business-ratings/user/$app_id/$business_id"));
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      BusinessReview? busRev = BusinessReview.fromJson(jsonBody);
      return busRev;
    } else {
      return null;
    }
  }

  static Future<List<BusinessReview>> getAllReviewsofBusiness(
    String business_id,
    String businessid,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/mzasni-directory/business-ratings/all/$business_id"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<BusinessReview> businessReviews = List<BusinessReview>.from(
          l.map((model) => BusinessReview.fromJson(model)));
      return businessReviews;
    } else {
      throw Exception('failed to fetch Business Reviews');
    }
  }

  Future<int> addLoyaltyCardAPICall(
    String app_id,
    String business_id,
    String rating_title,
    String rating_description,
    int rating_score,
  ) async {
    var response = await http.post(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/mzasni-directory/business-rating/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": app_id,
        "business_id": business_id,
        "rating_title": rating_title,
        "rating_description": rating_description,
        "rating_score": rating_score,
      }),
    );
    if (response.statusCode == 201) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  Future<int> deleteLoyaltyCardAPICall(
    int idbusiness_ratings,
  ) async {
    var response = await http.delete(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/mzasni-directory/business-ratng/delete/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(
          <String, dynamic>{"idbusiness_ratings": idbusiness_ratings}),
    );
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  static Future<int> updateLoyaltyCardAPICall(
    int idbusiness_ratings,
    String rating_title,
    String rating_description,
    String rating_score,
  ) async {
    var response = await http.put(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/mzasni-directory/business-rating/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "idbusiness_ratings": idbusiness_ratings,
        "rating_title": rating_title,
        "rating_description": rating_description,
        "rating_score": rating_score,
      }),
    );
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }
}
