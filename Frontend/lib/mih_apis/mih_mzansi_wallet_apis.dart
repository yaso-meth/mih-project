import 'dart:convert';

import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
import 'package:flutter/material.dart';
// import '../mih_components/mih_pop_up_messages/mih_error_message.dart';
// import '../mih_components/mih_pop_up_messages/mih_success_message.dart';
// import '../mih_env/env.dart';
// import '../mih_objects/app_user.dart';
// import '../mih_objects/arguments.dart';
// import '../mih_objects/business.dart';
// import '../mih_objects/business_user.dart';
// import '../mih_objects/notification.dart';
// import '../mih_objects/patient_access.dart';
// import '../mih_objects/patient_queue.dart';
// import '../mih_objects/patients.dart';
import 'package:supertokens_flutter/http.dart' as http;

import '../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../mih_env/env.dart';

class MIHMzansiWalletApis {
  final baseAPI = AppEnviroment.baseApiUrl;

  /// This function is used to fetch a list of loyalty cards for a user.
  ///
  /// Patameters: app_id .
  ///
  /// Returns List<PatientQueue>.
  static Future<List<MIHLoyaltyCard>> getLoyaltyCards(
    String app_id,
  ) async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/mzasni-wallet/loyalty-cards/$app_id"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    // errorCode = response.statusCode.toString();
    // errorBody = response.body;
    if (response.statusCode == 200) {
      //print("Here1");
      Iterable l = jsonDecode(response.body);
      //print("Here2");
      List<MIHLoyaltyCard> patientQueue = List<MIHLoyaltyCard>.from(
          l.map((model) => MIHLoyaltyCard.fromJson(model)));
      //print("Here3");
      //print(patientQueue);
      return patientQueue;
    } else {
      throw Exception('failed to fatch loyalty cards');
    }
  }

  /// This function is used to fetch a list of loyalty cards for a user.
  ///
  /// Patameters: app_id .
  ///
  /// Returns List<PatientQueue>.
  static Future<List<MIHLoyaltyCard>> getFavouriteLoyaltyCards(
    String app_id,
  ) async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/mzasni-wallet/loyalty-cards/favourites/$app_id"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    // errorCode = response.statusCode.toString();
    // errorBody = response.body;
    if (response.statusCode == 200) {
      // print("Here1");
      Iterable l = jsonDecode(response.body);
      //print("Here2");
      List<MIHLoyaltyCard> patientQueue = List<MIHLoyaltyCard>.from(
          l.map((model) => MIHLoyaltyCard.fromJson(model)));
      //print("Here3");
      //print(patientQueue);
      return patientQueue;
    } else {
      throw Exception('failed to fatch loyalty cards');
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
  static Future<void> deleteLoyaltyCardAPICall(
    AppUser signedInUser,
    int idloyalty_cards,
    int navIndex,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http.delete(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/mzasni-wallet/loyalty-cards/delete/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{"idloyalty_cards": idloyalty_cards}),
    );
    //print("Here4");
    //print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/mzansi-wallet',
        arguments: WalletArguments(signedInUser, navIndex),
      );
      String message =
          "The loyalty card has been deleted successfully. This means it will no longer be visible in your Mzansi Wallet.";
      successPopUp(message, context);
    } else {
      Navigator.pop(context);
      internetConnectionPopUp(context);
    }
  }

  /// This function is used to add a lopyalty card to users mzansi wallet.
  ///
  /// Patameters:-
  /// AppUser signedInUser,
  /// String app_id,
  /// String shop_name,
  /// String card_number,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS SUCCESS pop up)
  static Future<void> addLoyaltyCardAPICall(
    AppUser signedInUser,
    String app_id,
    String shop_name,
    String card_number,
    String favourite,
    int priority_index,
    String nickname,
    int navIndex,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http.post(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/mzasni-wallet/loyalty-cards/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": app_id,
        "shop_name": shop_name,
        "card_number": card_number,
        "favourite": favourite,
        "priority_index": priority_index,
        "nickname": nickname,
      }),
    );
    if (response.statusCode == 201) {
      Navigator.pop(context);
      String message =
          "Your $shop_name Loyalty Card was successfully added to your Mzansi Wallet.";
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.of(context).pushNamed(
        '/mzansi-wallet',
        arguments: WalletArguments(signedInUser, navIndex),
      );
      successPopUp(message, context);
    } else {
      Navigator.pop(context);
      internetConnectionPopUp(context);
    }
  }

  /// This function is used to Update loyalty card from users mzansi wallet.
  ///
  /// Patameters:-
  /// AppUser signedInUser,
  /// int idloyalty_cards,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS NOTIGICATIOPN ON SUCCESS)
  static Future<void> updateLoyaltyCardAPICall(
    AppUser signedInUser,
    int idloyalty_cards,
    String favourite,
    int priority_index,
    int navIndex,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http.put(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/mzasni-wallet/loyalty-cards/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "idloyalty_cards": idloyalty_cards,
        "favourite": favourite,
        "priority_index": priority_index,
      }),
    );
    //print("Here4");
    //print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/mzansi-wallet',
        arguments: WalletArguments(signedInUser, navIndex),
      );
      String message = "The loyalty card has been added to your favourites.";
      successPopUp(message, context);
    } else {
      Navigator.pop(context);
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

  static void loadingPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
  }
}
