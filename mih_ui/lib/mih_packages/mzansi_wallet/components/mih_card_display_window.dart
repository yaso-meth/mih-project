import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_banner_ad.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_card_display.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_card_edit_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_banner_ad_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_wallet_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:provider/provider.dart';
import 'package:qr_bar_code/code/src/code_generate.dart';
import 'package:qr_bar_code/code/src/code_type.dart';
import 'package:screen_brightness/screen_brightness.dart';

class MihCardDisplayWindow extends StatefulWidget {
  final MIHLoyaltyCard displayCard;
  final int listIndex;
  final int noFavourites;
  const MihCardDisplayWindow({
    super.key,
    required this.displayCard,
    required this.listIndex,
    required this.noFavourites,
  });

  @override
  State<MihCardDisplayWindow> createState() => _MihCardDisplayWindowState();
}

class _MihCardDisplayWindowState extends State<MihCardDisplayWindow> {
  double? _originalBrightness;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      context.read<MihBannerAdProvider>().loadBannerAd();
    }
  }

  void resetScreenBrightness() async {
    if (!kIsWeb) {
      KenLogger.success(
          "Resetting screen brightness to original value: $_originalBrightness");
      if (_originalBrightness != null) {
        await ScreenBrightness.instance
            .setSystemScreenBrightness(_originalBrightness!);
      }
    } else {
      KenLogger.warning("Screen brightness reset is not supported on Web.");
    }
  }

  String getFormattedCardNumber() {
    String formattedCardNumber = "";
    for (int i = 0; i <= widget.displayCard.card_number.length - 1; i++) {
      formattedCardNumber += widget.displayCard.card_number[i];
      if ((i + 1) % 4 == 0) {
        formattedCardNumber += "\t";
      }
    }
    return formattedCardNumber;
  }

  void deleteCardWindow(MzansiProfileProvider mzansiProfileProvider,
      MzansiWalletProvider walletProvider, BuildContext ctxt, int index) {
    MihAlertServices().deleteConfirmationAlert(
      "This Card will be deleted permanently from your Mzansi Wallet. Are you certain you want to delete it?",
      () async {
        walletProvider.deleteLocalLoyaltyCard(
          mzansiProfileProvider,
          widget.displayCard,
        );
        context.pop();
        context.pop();
        MihAlertServices().successBasicAlert(
          "Success!",
          "You have successfully deleted the loyalty card from your Mzansi Wallet.",
          context,
        );
      },
      context,
    );
  }

  void addToFavCardWindow(MzansiProfileProvider mzansiProfileProvider,
      MzansiWalletProvider walletProvider, BuildContext ctxt, int index) {
    MihAlertServices().warningAdvancedAlert(
      // "Card Added to Favourites",
      "Add Card to Favourites?",
      "Would you like to add this card to your favourites for quick access?",
      // "You have successfully added the loyalty card to your favourites.",
      [
        MihButton(
          onPressed: () async {
            context.pop();
          },
          buttonColor: MihColors.red(),
          width: 300,
          child: Text(
            "Cancel",
            style: TextStyle(
              color: MihColors.primary(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        MihButton(
          onPressed: () async {
            await walletProvider.updateLocalLoyaltyCard(
              mzansiProfileProvider,
              MIHLoyaltyCard(
                idloyalty_cards: widget.displayCard.idloyalty_cards,
                app_id: widget.displayCard.app_id,
                shop_name: widget.displayCard.shop_name,
                card_number: widget.displayCard.card_number,
                favourite: "Yes",
                priority_index: widget.noFavourites,
                nickname: widget.displayCard.nickname,
                offline_id: widget.displayCard.offline_id,
              ),
            );
            context.pop();
            context.pop();
            context.read<MzansiWalletProvider>().setToolIndex(1);
            MihAlertServices().successBasicAlert(
              "Success!",
              "You have successfully added the loyalty card to your favourites.",
              context,
            );
          },
          buttonColor: MihColors.green(),
          width: 300,
          child: Text(
            "Add",
            style: TextStyle(
              color: MihColors.primary(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      context,
    );
  }

  void removeFromFavCardWindow(MzansiProfileProvider mzansiProfileProvider,
      MzansiWalletProvider walletProvider, BuildContext ctxt, int index) {
    MihAlertServices().warningAdvancedAlert(
      "Remove From Favourites?",
      "Are you sure you want to remove this card from your favourites?",
      [
        MihButton(
          onPressed: () async {
            await walletProvider.updateLocalLoyaltyCard(
              mzansiProfileProvider,
              MIHLoyaltyCard(
                idloyalty_cards: widget.displayCard.idloyalty_cards,
                app_id: widget.displayCard.app_id,
                shop_name: widget.displayCard.shop_name,
                card_number: widget.displayCard.card_number,
                favourite: "No",
                priority_index: 0,
                nickname: widget.displayCard.nickname,
                offline_id: widget.displayCard.offline_id,
              ),
            );
            context.pop();
            context.pop();
            context.read<MzansiWalletProvider>().setToolIndex(0);
            MihAlertServices().successBasicAlert(
              "Success!",
              "You have successfully removed the loyalty card to your favourites.",
              context,
            );
          },
          buttonColor: MihColors.red(),
          width: 300,
          child: Text(
            "Remove",
            style: TextStyle(
              color: MihColors.primary(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        MihButton(
          onPressed: () async {
            context.pop();
          },
          buttonColor: MihColors.green(),
          width: 300,
          child: Text(
            "Cancel",
            style: TextStyle(
              color: MihColors.primary(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      ctxt,
    );
  }

  void editCardWindow(
    int index,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihCardEditWindow(
        editCard: widget.displayCard,
        listIndex: widget.listIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MzansiProfileProvider, MzansiWalletProvider>(
      builder: (
        BuildContext context,
        MzansiProfileProvider mzansiProfileProvider,
        MzansiWalletProvider walletProvider,
        Widget? child,
      ) {
        return MihPackageWindow(
          backgroundColor: getCardColor(widget.displayCard.shop_name),
          fullscreen: false,
          windowTitle: null,
          menuOptions: [
            SpeedDialChild(
              child: widget.displayCard.favourite == "No" ||
                      widget.displayCard.favourite == ""
                  ? Icon(
                      Icons.favorite,
                      color: MihColors.primary(),
                    )
                  : Icon(
                      Icons.favorite_border,
                      color: MihColors.primary(),
                    ),
              label: widget.displayCard.favourite == "No" ||
                      widget.displayCard.favourite == ""
                  ? "Add to Favourite"
                  : "Remove from Favourite",
              labelBackgroundColor: MihColors.green(),
              labelStyle: TextStyle(
                color: MihColors.primary(),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: MihColors.green(),
              onTap: () {
                if (widget.displayCard.favourite == "No" ||
                    widget.displayCard.favourite == "") {
                  addToFavCardWindow(
                    mzansiProfileProvider,
                    walletProvider,
                    context,
                    widget.listIndex,
                  );
                } else {
                  removeFromFavCardWindow(
                    mzansiProfileProvider,
                    walletProvider,
                    context,
                    widget.listIndex,
                  );
                }
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.edit,
                color: MihColors.primary(),
              ),
              label: "Edit Card Details",
              labelBackgroundColor: MihColors.green(),
              labelStyle: TextStyle(
                color: MihColors.primary(),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: MihColors.green(),
              onTap: () {
                editCardWindow(
                  widget.listIndex,
                );
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.delete,
                color: MihColors.primary(),
              ),
              label: "Delete Card",
              labelBackgroundColor: MihColors.green(),
              labelStyle: TextStyle(
                color: MihColors.primary(),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: MihColors.green(),
              onTap: () {
                deleteCardWindow(
                  mzansiProfileProvider,
                  walletProvider,
                  context,
                  widget.listIndex,
                );
              },
            ),
          ],
          onWindowTapClose: () {
            resetScreenBrightness();
            context.pop();
          },
          windowBody: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 500,
                child: MihCardDisplay(
                  shopName: widget.displayCard.shop_name,
                  nickname: widget.displayCard.nickname,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                // width: 500,
                //color: Colors.white,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Code(
                        data: widget.displayCard.card_number,
                        codeType: CodeType.code128(),
                        drawText: false,
                        height: 175,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        getFormattedCardNumber(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                            //MihColors.secondary(),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (!kIsWeb &&
                  (defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS))
                MihBannerAd()
            ],
          ),
        );
      },
    );
  }

  Color getCardColor(String shopName) {
    switch (shopName.toLowerCase()) {
      case "apple tree":
        return const Color(0xFFffffff);
      case "best before":
        return const Color(0xFF000000);
      case "checkers":
        return const Color(0xFF00a6a3);
      case "clicks":
        return const Color(0xFF005baa);
      case "cotton:on":
        return const Color(0xFFffffff);
      case "dis-chem":
        return const Color(0xFF00a950);
      case "pick n pay":
        return const Color(0xFFffffff);
      case "shoprite":
        return const Color(0xFFc12514);
      case "spar":
        return const Color(0xFFffffff);
      case "woolworths":
        return const Color(0xFF000000);
      case "makro":
        return const Color(0xFFffffff);
      case "fresh stop":
        return const Color(0xFF50b849);
      case "panarottis":
        return const Color(0xFF3c3c3b);
      case "shell":
        return const Color(0xFF1d232a);
      case "edgars":
        return const Color(0xFFffffff);
      case "jet":
        return const Color(0xFFffffff);
      case "spur":
        return const Color(0xFF0a0157);
      case "infinity":
        return const Color(0xFFffffff);
      case "eskom":
        return const Color(0xFF003897);
      case "+more":
        return const Color(0xFFffffff);
      case "bp":
        return const Color(0xFF9dc600);
      case "builders warehouse":
        return const Color(0xFFffcb26);
      case "exclusive books":
        return const Color(0xFF2abdc5);
      case "pna":
        return const Color(0xFFcf3339);
      case "pq clothing":
        return const Color(0xFFed2223);
      case "rage":
        return const Color(0xFFffffff);
      case "sasol":
        return const Color(0xFFffffff);
      case "tfg group":
        return const Color(0xFF622775);
      case "toys r us":
        return const Color(0xFF0962ad);
      case "leroy merlin":
        return const Color(0xFFffffff);
      case "signature cosmetics & fragrances":
        return const Color(0xFFec028b);
      case "ok foods":
        return const Color(0xFFffffff);
      case "choppies":
        return const Color(0xFFffffff);
      case "boxer":
        return const Color(0xFFffffff);
      case "carrefour":
        return const Color(0xFFffffff);
      case "sefalana":
        return const Color(0xFFffffff);
      case "big save":
        return const Color(0xFF333333);
      case "justrite":
        return const Color(0xFF50b849);
      case "naivas":
        return const Color(0xFFf26535);
      case "kero":
        return const Color(0xFF004986);
      case "auchan":
        return const Color(0xFFffffff);
      case "woermann brock":
        return const Color(0xFFe31e2d);
      case "continente":
        return const Color(0xFFffffff);
      case "fresmart":
        return const Color(0xFF72ba2e);
      case "total energies":
        return const Color(0xFFffffff);
      case "engen":
        return const Color(0xFF002b8f);
      default:
        return const Color(0xFFffffff);
    }
  }
}
