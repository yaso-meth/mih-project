import 'package:flutter/foundation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_banner_ad.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_wallet_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_wallet_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
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
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                          fillColor: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          inputColor: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
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
                        buttonColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 100,
                        child: Text(
                          "Scan",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
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
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
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
          buttonColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          width: 300,
          child: Text(
            "Cancel",
            style: TextStyle(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          buttonColor: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          width: 300,
          child: Text(
            "Add",
            style: TextStyle(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          buttonColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          width: 300,
          child: Text(
            "Remove",
            style: TextStyle(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        MihButton(
          onPressed: () async {
            context.pop();
          },
          buttonColor: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          width: 300,
          child: Text(
            "Cancel",
            style: TextStyle(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      ctxt,
    );
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
        fullscreen: false,
        windowTitle: widget.cardList[index].shop_name.toUpperCase(),
        menuOptions: [
          SpeedDialChild(
            child: widget.cardList[index].favourite == ""
                ? Icon(
                    Icons.favorite,
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  )
                : Icon(
                    Icons.favorite_border,
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
            label: widget.cardList[index].favourite == ""
                ? "Add to Favourite"
                : "Remove from Favourite",
            labelBackgroundColor: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            labelStyle: TextStyle(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            label: "Edit Card Details",
            labelBackgroundColor: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            labelStyle: TextStyle(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            label: "Delete Card",
            labelBackgroundColor: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            labelStyle: TextStyle(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
            Container(
              width: 500,
              child: MihCardDisplay(
                shopName: widget.cardList[index].shop_name,
                nickname: widget.cardList[index].nickname,
                height: 250,
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
                      height: 75,
                      // width: 300,
                      child: BarcodeWidget(
                        //color: MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                        //MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            MihBannerAd()
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
    if (!kIsWeb) {
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
              buttonColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              width: 300,
              child: Text(
                "Grant Permission",
                style: TextStyle(
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(
              left: getHorizontalPaddingSize(size),
              right: getHorizontalPaddingSize(size),
            ),
            itemCount: widget.cardList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisSpacing: 0,
              crossAxisSpacing: 5,
              maxCrossAxisExtent: 200,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                child: MihCardDisplay(
                  shopName: widget.cardList[index].shop_name,
                  nickname: widget.cardList[index].nickname,
                  height: 100,
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
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              const SizedBox(height: 10),
              Text(
                "Let's try refining your search",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              const SizedBox(height: 10),
              Text(
                "No cards added to your Mzansi Wallet",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                    children: [
                      TextSpan(text: "Press "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.menu,
                          size: 20,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
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
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              const SizedBox(height: 10),
              Text(
                "No favourite cards in your Mzansi Wallet",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                    children: [
                      TextSpan(text: "Press "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.menu,
                          size: 20,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
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
