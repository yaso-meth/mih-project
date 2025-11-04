import 'dart:convert';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_review.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihMzansiDirectoryServices {
  final baseAPI = AppEnviroment.baseApiUrl;

//########################################################
//#                  Business Ratings                    #
//########################################################

  Future<BusinessReview?> getUserReviewOfBusiness(
    String app_id,
    String business_id,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/mzansi-directory/business-ratings/user/$app_id/$business_id"));
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

  Future<List<BusinessReview>> getAllReviewsofBusiness(
    String business_id,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/mzansi-directory/business-ratings/all/$business_id"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<BusinessReview> businessReviews = List<BusinessReview>.from(
          l.map((model) => BusinessReview.fromJson(model)));
      return businessReviews;
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('failed to fetch Business Reviews');
    }
  }

  Future<int> addBusinessReview(
    String app_id,
    String business_id,
    String rating_title,
    String rating_description,
    String rating_score,
    String current_rating,
  ) async {
    var response = await http.post(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/mzansi-directory/business-rating/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": app_id,
        "business_id": business_id,
        "rating_title": rating_title,
        "rating_description": rating_description,
        "rating_score": rating_score,
        "current_rating": current_rating,
      }),
    );
    if (response.statusCode == 201) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  Future<int> deleteBusinessReview(
    int idbusiness_ratings,
    String business_id,
    String rating_score,
    String current_rating,
  ) async {
    var response = await http.delete(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/mzansi-directory/business-rating/delete/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "idbusiness_ratings": idbusiness_ratings,
        "business_id": business_id,
        "rating_score": rating_score,
        "current_rating": current_rating,
      }),
    );
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  Future<int> updateBusinessReview(
    int idbusiness_ratings,
    String business_id,
    String rating_title,
    String rating_description,
    String rating_new_score,
    String rating_old_score,
    String current_rating,
  ) async {
    var response = await http.put(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/mzansi-directory/business-rating/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "idbusiness_ratings": idbusiness_ratings,
        "business_id": business_id,
        "rating_title": rating_title,
        "rating_description": rating_description,
        "rating_new_score": rating_new_score,
        "rating_old_score": rating_old_score,
        "current_rating": current_rating,
      }),
    );
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

//########################################################
//#                  Bookmarked Business                 #
//########################################################

  Future<BookmarkedBusiness?> getUserBookmarkOfBusiness(
    String app_id,
    String business_id,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/mzansi-directory/bookmarked-business/$app_id/$business_id"));
    // print(response.statusCode);
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      BookmarkedBusiness? BookmarkedBus = BookmarkedBusiness.fromJson(jsonBody);
      return BookmarkedBus;
    } else {
      return null;
    }
  }

  Future<List<BookmarkedBusiness>> getAllUserBookmarkedBusiness(
    String app_id,
    MzansiDirectoryProvider directoryProvider,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/mzansi-directory/bookmarked-business/user/all/$app_id/"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<BookmarkedBusiness> favouriteBusinesses =
          List<BookmarkedBusiness>.from(
              l.map((model) => BookmarkedBusiness.fromJson(model)));
      directoryProvider.setBookmarkedeBusinesses(
          businesses: favouriteBusinesses);
      return favouriteBusinesses;
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('failed to fetch User Bookmarked Business');
    }
  }

  Future<int> addBookmarkedBusiness(
    String app_id,
    String business_id,
  ) async {
    var response = await http.post(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/mzansi-directory/bookmarked-business/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": app_id,
        "business_id": business_id,
      }),
    );
    if (response.statusCode == 201) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  Future<int> deleteBookmarkedBusiness(
    int idbookmarked_businesses,
  ) async {
    var response = await http.delete(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/mzansi-directory/bookmarked-business/delete/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "idbookmarked_businesses": idbookmarked_businesses,
      }),
    );
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }
}
