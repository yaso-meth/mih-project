import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_wallet_provider.dart';
import 'package:provider/provider.dart';
import 'package:supertokens_flutter/http.dart' as http;

import '../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../mih_config/mih_env.dart';

class MIHMzansiWalletApis {
  final baseAPI = AppEnviroment.baseApiUrl;

  static Future<void> getLoyaltyCards(
    String app_id,
    BuildContext context,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/mzasni-wallet/loyalty-cards/$app_id"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<MIHLoyaltyCard> myCards = List<MIHLoyaltyCard>.from(
          l.map((model) => MIHLoyaltyCard.fromJson(model)));
      context.read<MzansiWalletProvider>().setLoyaltyCards(cards: myCards);
      // return myCards;
    } else {
      throw Exception('failed to fatch loyalty cards');
    }
  }

  static Future<void> getFavouriteLoyaltyCards(
    String app_id,
    BuildContext context,
  ) async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/mzasni-wallet/loyalty-cards/favourites/$app_id"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<MIHLoyaltyCard> myCards = List<MIHLoyaltyCard>.from(
          l.map((model) => MIHLoyaltyCard.fromJson(model)));
      context.read<MzansiWalletProvider>().setFavouriteCards(cards: myCards);
    }
    // else {
    //   throw Exception('failed to fatch loyalty cards');
    // }
  }

  /// This function is used to Delete loyalty card from users mzansi wallet.
  ///
  /// Patameters:-
  /// AppUser signedInUser,
  /// int idloyalty_cards,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS NOTIGICATIOPN ON SUCCESS)
  static Future<int> deleteLoyaltyCardAPICall(
    AppUser signedInUser,
    int idloyalty_cards,
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
    context.pop();
    if (response.statusCode == 200) {
      context
          .read<MzansiWalletProvider>()
          .deleteLoyaltyCard(cardId: idloyalty_cards);
    }
    return response.statusCode;
    // if (response.statusCode == 200) {
    //   Navigator.of(context).pop();
    //   Navigator.of(context).pop();
    //   Navigator.of(context).pop();
    //   Navigator.of(context).pop();
    //   Navigator.of(context).pushNamed(
    //     '/mzansi-wallet',
    //     arguments: WalletArguments(signedInUser, navIndex),
    //   );
    //   String message =
    //       "The loyalty card has been deleted successfully. This means it will no longer be visible in your Mzansi Wallet.";
    //   successPopUp(message, context);
    // } else {
    //   Navigator.pop(context);
    //   internetConnectionPopUp(context);
    // }
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
  static Future<int> addLoyaltyCardAPICall(
    AppUser signedInUser,
    String app_id,
    String shop_name,
    String card_number,
    String favourite,
    int priority_index,
    String nickname,
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
    context.pop();
    return response.statusCode;
    // if (response.statusCode == 201) {
    //   // Navigator.pop(context);
    //   // String message =
    //   //     "Your $shop_name Loyalty Card was successfully added to your Mzansi Wallet.";
    //   // Navigator.pop(context);
    //   // Navigator.pop(context);
    //   // Navigator.of(context).pushNamed(
    //   //   '/mzansi-wallet',
    //   //   arguments: WalletArguments(signedInUser, navIndex),
    //   // );
    //   // successPopUp(message, context);
    // } else {
    //   // Navigator.pop(context);
    //   // internetConnectionPopUp(context);
    // }
  }

  /// This function is used to Update loyalty card from users mzansi wallet.
  ///
  /// Patameters:-
  /// AppUser signedInUser,
  /// int idloyalty_cards,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS NOTIGICATIOPN ON SUCCESS)
  static Future<int> updateLoyaltyCardAPICall(
    AppUser signedInUser,
    int idloyalty_cards,
    String shopName,
    String favourite,
    int priority_index,
    String nickname,
    String card_number,
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
        "nickname": nickname,
        "card_number": card_number,
      }),
    );
    context.pop();
    if (response.statusCode == 200) {
      context.read<MzansiWalletProvider>().editLoyaltyCard(
            updatedCard: MIHLoyaltyCard(
              idloyalty_cards: idloyalty_cards,
              app_id: signedInUser.app_id,
              shop_name: shopName,
              card_number: card_number,
              favourite: favourite,
              priority_index: priority_index,
              nickname: nickname,
            ),
          );
    }
    return response.statusCode;
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
