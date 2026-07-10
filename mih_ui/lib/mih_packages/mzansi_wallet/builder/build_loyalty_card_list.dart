import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_card_display_slanted.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_card_display_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_wallet_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';

class BuildLoyaltyCardList extends StatefulWidget {
  final List<MIHLoyaltyCard> cardList;
  final int navIndex;
  final bool favouritesMode;
  final TextEditingController searchText;

  const BuildLoyaltyCardList({
    super.key,
    required this.cardList,
    required this.navIndex,
    required this.favouritesMode,
    required this.searchText,
  });

  @override
  State<BuildLoyaltyCardList> createState() => _BuildLoyaltyCardListState();
}

class _BuildLoyaltyCardListState extends State<BuildLoyaltyCardList> {
  late int _noFavourites;
  double? _originalBrightness;

  void viewCardWindow(MzansiProfileProvider mzansiProfileProvider,
      MzansiWalletProvider walletProvider, int index, double width) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihCardDisplayWindow(
        displayCard: widget.cardList[index],
        listIndex: index,
        noFavourites: _noFavourites,
      ),
    );
  }

  double getHorizontalPaddingSize(Size screenSize) {
    if (MzansiInnovationHub.of(context)!.theme.screenType == "desktop") {
      return screenSize.width / 10;
    } else {
      return 20;
    }
  }

  int countFavourites() {
    int count = 0;
    for (var card in widget.cardList) {
      if (card.favourite != "") {
        count++;
      }
    }
    return count;
  }

  Future<void> setScreenBrightness(double newBrightness) async {
    if (!kIsWeb && !Platform.isLinux) {
      bool canChange =
          await ScreenBrightness.instance.canChangeSystemBrightness;

      KenLogger.success("Can change system brightness: $canChange");
      if (canChange) {
        // Permission is granted, you can now change the system brightness
        await ScreenBrightness.instance.system.then((brightness) {
          setState(() {
            _originalBrightness = brightness;
          });
          KenLogger.success("Original brightness: $_originalBrightness");
        });
        await ScreenBrightness.instance
            .setSystemScreenBrightness(newBrightness);
        KenLogger.success("Brightness set to: $newBrightness");
      } else {
        context.pop();
        MihAlertServices().errorAdvancedAlert(
          "Permission Required",
          "Sometimes it can be tough to scan your loyalty card if your phone screen is dim. To make sure your scan is successful every time, we need your permission to temporarily increase your screen brightness.\n\nWould you mind enabling this in your device settings?",
          [
            MihButton(
              onPressed: () async {
                context.pop();
                await ScreenBrightness.instance
                    .setSystemScreenBrightness(newBrightness);
              },
              buttonColor: MihColors.secondary(),
              width: 300,
              child: Text(
                "Grant Permission",
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
    } else {
      KenLogger.warning(
          "Screen brightness adjustment is not supported on Web.");
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _noFavourites = countFavourites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    if (widget.cardList.isNotEmpty) {
      return Consumer2<MzansiProfileProvider, MzansiWalletProvider>(
        builder: (BuildContext context,
            MzansiProfileProvider mzansiProfileProvider,
            MzansiWalletProvider walletProvider,
            Widget? child) {
          return GridView.builder(
            padding: EdgeInsets.only(
              left: getHorizontalPaddingSize(size),
              right: getHorizontalPaddingSize(size),
            ),
            itemCount: widget.cardList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisSpacing: 0,
              // mainAxisSpacing: 15,
              // crossAxisSpacing: 15,
              crossAxisSpacing: 5,
              maxCrossAxisExtent: 200,
              // childAspectRatio: 0.80,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                child: MihCardDisplaySlanted(
                  // child: MihCardDisplay(
                  height: 100,
                  shopName: widget.cardList[index].shop_name,
                  nickname: widget.cardList[index].nickname,
                ),
                onTap: () {
                  setScreenBrightness(1.0);
                  viewCardWindow(
                    mzansiProfileProvider,
                    walletProvider,
                    index,
                    size.width,
                  );
                },
              );
            },
          );
        },
      );
    } else {
      if (!widget.favouritesMode) {
        if (widget.searchText.text.isNotEmpty) {
          return Column(
            children: [
              const SizedBox(height: 50),
              Icon(
                MihIcons.mihIDontKnow,
                size: 165,
                color: MihColors.secondary(),
              ),
              const SizedBox(height: 10),
              Text(
                "Let's try refining your search",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MihColors.secondary(),
                ),
              ),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Icon(
                MihIcons.mzansiWallet,
                size: 165,
                color: MihColors.secondary(),
              ),
              const SizedBox(height: 10),
              Text(
                "No cards added to your Mzansi Wallet",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MihColors.secondary(),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: MihColors.secondary(),
                    ),
                    children: [
                      TextSpan(text: "Press "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.menu,
                          size: 20,
                          color: MihColors.secondary(),
                        ),
                      ),
                      TextSpan(text: " to add your first loyalty card"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Icon(
                MihIcons.mzansiWallet,
                size: 165,
                color: MihColors.secondary(),
              ),
              const SizedBox(height: 10),
              Text(
                "No favourite cards in your Mzansi Wallet",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MihColors.secondary(),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: MihColors.secondary(),
                    ),
                    children: [
                      TextSpan(text: "Press "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.menu,
                          size: 20,
                          color: MihColors.secondary(),
                        ),
                      ),
                      TextSpan(
                          text:
                              " when viewing a loyalty card to add it to your favorites"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}
