import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_banner_ad.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_wallet_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_wallet_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_card_display.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
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
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  late int _noFavourites;
  double? _originalBrightness;
  final _formKey = GlobalKey<FormState>();

  void openscanner() async {
    context.pushNamed(
      "barcodeScanner",
      extra: _cardNumberController,
    );
  }

  void editCardWindow(
      MzansiProfileProvider mzansiProfileProvider,
      MzansiWalletProvider walletProvider,
      BuildContext ctxt,
      int index,
      double width) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Edit Loyalty Card",
        onWindowTapClose: () {
          _cardNumberController.clear();
          _nicknameController.clear();
          Navigator.pop(context);
        },
        windowBody: Padding(
          padding:
              MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.05)
                  : EdgeInsets.symmetric(horizontal: width * 0),
          child: Column(
            children: [
              MihForm(
                formKey: _formKey,
                formFields: [
                  MihTextFormField(
                    fillColor: MihColors.secondary(),
                    inputColor: MihColors.primary(),
                    controller: _nicknameController,
                    multiLineInput: false,
                    requiredText: false,
                    hintText: "Card Title",
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: MihTextFormField(
                          fillColor: MihColors.secondary(),
                          inputColor: MihColors.primary(),
                          controller: _cardNumberController,
                          multiLineInput: false,
                          requiredText: true,
                          hintText: "Card Number",
                          numberMode: true,
                          validator: (value) {
                            return MihValidationServices().isEmpty(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      MihButton(
                        onPressed: () {
                          openscanner();
                        },
                        buttonColor: MihColors.secondary(),
                        width: 100,
                        child: Text(
                          "Scan",
                          style: TextStyle(
                            color: MihColors.primary(),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: MihButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          int statusCode = await MIHMzansiWalletApis
                              .updateLoyaltyCardAPICall(
                            walletProvider,
                            mzansiProfileProvider.user!,
                            widget.cardList[index].idloyalty_cards,
                            widget.cardList[index].shop_name,
                            widget.cardList[index].favourite,
                            widget.cardList[index].priority_index,
                            _nicknameController.text,
                            _cardNumberController.text,
                            ctxt,
                          );
                          if (statusCode == 200) {
                            context.pop();
                            context.pop();
                            MihAlertServices().successBasicAlert(
                              "Success!",
                              "You have successfully updated the loyalty card details.",
                              context,
                            );
                          } else {
                            MihAlertServices().internetConnectionAlert(context);
                          }
                        } else {
                          MihAlertServices().inputErrorAlert(context);
                        }
                      },
                      buttonColor: MihColors.green(),
                      width: 300,
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: MihColors.primary(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteCardWindow(MzansiProfileProvider mzansiProfileProvider,
      MzansiWalletProvider walletProvider, BuildContext ctxt, int index) {
    MihAlertServices().deleteConfirmationAlert(
      "This Card will be deleted permanently from your Mzansi Wallet. Are you certain you want to delete it?",
      () async {
        int statusCode = await MIHMzansiWalletApis.deleteLoyaltyCardAPICall(
          walletProvider,
          mzansiProfileProvider.user!,
          widget.cardList[index].idloyalty_cards,
          context,
        );
        if (statusCode == 200) {
          context.pop();
          context.pop();
          MihAlertServices().successBasicAlert(
            "Success!",
            "You have successfully deleted the loyalty card from your Mzansi Wallet.",
            context,
          );
        } else {
          context.pop();
          MihAlertServices().internetConnectionAlert(context);
        }
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
            int statusCode = await MIHMzansiWalletApis.updateLoyaltyCardAPICall(
              walletProvider,
              mzansiProfileProvider.user!,
              widget.cardList[index].idloyalty_cards,
              widget.cardList[index].shop_name,
              "Yes",
              _noFavourites,
              widget.cardList[index].nickname,
              widget.cardList[index].card_number,
              ctxt,
            );
            if (statusCode == 200) {
              context.pop();
              context.pop();
              await MIHMzansiWalletApis.getFavouriteLoyaltyCards(
                walletProvider,
                mzansiProfileProvider.user!.app_id,
                context,
              );
              context.read<MzansiWalletProvider>().setToolIndex(1);
              MihAlertServices().successBasicAlert(
                "Success!",
                "You have successfully added the loyalty card to your favourites.",
                context,
              );
            } else {
              MihAlertServices().internetConnectionAlert(context);
            }
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
            int statusCode = await MIHMzansiWalletApis.updateLoyaltyCardAPICall(
              walletProvider,
              mzansiProfileProvider.user!,
              widget.cardList[index].idloyalty_cards,
              widget.cardList[index].shop_name,
              "",
              0,
              widget.cardList[index].nickname,
              widget.cardList[index].card_number,
              ctxt,
            );
            if (statusCode == 200) {
              context.pop();
              context.pop();
              await MIHMzansiWalletApis.getFavouriteLoyaltyCards(
                walletProvider,
                mzansiProfileProvider.user!.app_id,
                context,
              );
              context.read<MzansiWalletProvider>().setToolIndex(0);
              MihAlertServices().successBasicAlert(
                "Success!",
                "You have successfully removed the loyalty card to your favourites.",
                context,
              );
            } else {
              MihAlertServices().internetConnectionAlert(context);
            }
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

  Color getCardColor(String shopName) {
    switch (shopName.toLowerCase()) {
      case "apple tree":
        return const Color(0xFFffffff);
      case "best before":
        return const Color(0xFF000000);
      case "checkers":
        return const Color(0xFF00a6a3);
      case "clicks":
        return const Color(0xFF005caf);
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

  void viewCardWindow(MzansiProfileProvider mzansiProfileProvider,
      MzansiWalletProvider walletProvider, int index, double width) {
    //print(widget.cardList[index].card_number);
    String formattedCardNumber = "";
    for (int i = 0; i <= widget.cardList[index].card_number.length - 1; i++) {
      formattedCardNumber += widget.cardList[index].card_number[i];
      if ((i + 1) % 4 == 0) {
        formattedCardNumber += "\t";
      }
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        backgroundColor: getCardColor(widget.cardList[index].shop_name),
        fullscreen: false,
        windowTitle: null,
        menuOptions: [
          SpeedDialChild(
            child: widget.cardList[index].favourite == ""
                ? Icon(
                    Icons.favorite,
                    color: MihColors.primary(),
                  )
                : Icon(
                    Icons.favorite_border,
                    color: MihColors.primary(),
                  ),
            label: widget.cardList[index].favourite == ""
                ? "Add to Favourite"
                : "Remove from Favourite",
            labelBackgroundColor: MihColors.green(),
            labelStyle: TextStyle(
              color: MihColors.primary(),
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: MihColors.green(),
            onTap: () {
              if (widget.cardList[index].favourite == "") {
                addToFavCardWindow(
                  mzansiProfileProvider,
                  walletProvider,
                  context,
                  index,
                );
              } else {
                removeFromFavCardWindow(
                  mzansiProfileProvider,
                  walletProvider,
                  context,
                  index,
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
              setState(() {
                _cardNumberController.text = widget.cardList[index].card_number;
                _nicknameController.text = widget.cardList[index].nickname;
              });
              editCardWindow(
                mzansiProfileProvider,
                walletProvider,
                context,
                index,
                width,
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
                index,
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
                shopName: widget.cardList[index].shop_name,
                nickname: widget.cardList[index].nickname,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 500,
              //color: Colors.white,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 150,
                      // width: 300,
                      child: BarcodeWidget(
                        //color: MihColors.secondary(),
                        barcode: Barcode.code128(),
                        backgroundColor: Colors.white,
                        data: widget.cardList[index].card_number,
                        drawText: false,
                      ),
                      // SfBarcodeGenerator(
                      //   backgroundColor: Colors.white,
                      //   barColor: Colors.black,
                      //   value: widget.cardList[index].card_number,
                      //   symbology: Code128(),
                      //   //showValue: true,
                      // ),
                    ),
                  ),
                  // const SizedBox(height: 10),
                  Text(
                    formattedCardNumber,
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
            SizedBox(height: 10),
            if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) MihBannerAd()
            // MihBannerAd(),
          ],
        ),
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
      // _originalBrightness = 1.0; // Default brightness for web
      // await ScreenBrightness.instance.setSystemScreenBrightness(1.0);
      // KenLogger.success("Brightness set to default value: 1.0");
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
    // final double width = size.width;
    //final double height = size.height;
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
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              maxCrossAxisExtent: 200,
              // childAspectRatio: 0.80,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                child: MihCardDisplay(
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
                MihIcons.iDontKnow,
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
