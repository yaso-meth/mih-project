import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_banner_ad.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_wallet_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/builder/build_loyalty_card_list.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_card_display.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MihCards extends StatefulWidget {
  final AppUser signedInUser;
  const MihCards({
    super.key,
    required this.signedInUser,
  });

  @override
  State<MihCards> createState() => _MihCardsState();
}

class _MihCardsState extends State<MihCards> {
  final TextEditingController shopController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardSearchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late Future<List<MIHLoyaltyCard>> cardList;
  MihBannerAd _bannerAd = MihBannerAd();
  List<MIHLoyaltyCard> listOfCards = [];
  //bool showSelectedCardType = false;
  final ValueNotifier<String> shopName = ValueNotifier("");
  final ValueNotifier<List<MIHLoyaltyCard>> searchShopName = ValueNotifier([]);

  final MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.unrestricted,
  );
  final boxFit = BoxFit.contain;

  void searchShop() {
    if (cardSearchController.text.isEmpty) {
      searchShopName.value = listOfCards;
    } else {
      List<MIHLoyaltyCard> temp = [];
      for (var item in listOfCards) {
        if (item.shop_name
                .toLowerCase()
                .contains(cardSearchController.text.toLowerCase()) ||
            item.nickname
                .toLowerCase()
                .contains(cardSearchController.text.toLowerCase())) {
          temp.add(item);
        }
      }
      searchShopName.value = temp;
    }
  }

  void openscanner() async {
    context.pushNamed(
      "barcodeScanner",
      extra: cardNumberController,
    );
  }

  void shopSelected() {
    if (shopController.text.isNotEmpty) {
      shopName.value = shopController.text;
    } else {
      shopName.value = "";
    }
  }

  void successPopUp(String title, String message, int packageIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.check_circle_outline_rounded,
            size: 150,
            color: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          alertTitle: title,
          alertBody: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: MihButton(
                  onPressed: () {
                    context.pop();
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  elevation: 10,
                  width: 300,
                  child: Text(
                    "Dismiss",
                    style: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          alertColour: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
    );
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(
          errorType: "Internet Connection",
        );
      },
    );
  }

  void addCardWindow(BuildContext ctxt, double width) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Add New Loyalty Card",
        onWindowTapClose: () {
          shopController.clear();
          cardNumberController.clear();
          _nicknameController.clear();
          shopName.value = "";
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
                  MihDropdownField(
                    controller: shopController,
                    hintText: "Shop Name",
                    editable: true,
                    enableSearch: true,
                    validator: (value) {
                      return MihValidationServices().isEmpty(value);
                    },
                    requiredText: true,
                    dropdownOptions: const [
                      "+More",
                      "Apple Tree",
                      "Auchan",
                      "Best Before",
                      "Big Save",
                      "Boxer",
                      "BP",
                      "Builders Warehouse",
                      "Checkers",
                      "Choppies",
                      "Clicks",
                      "Continente",
                      "Cotton:On",
                      "Carrefour",
                      "Dis-Chem",
                      "Edgars",
                      "Eskom",
                      "Exclusive Books",
                      "Fresh Stop",
                      "Fresmart",
                      "Infinity",
                      "Jet",
                      "Justrite",
                      "Kero",
                      "Leroy Merlin",
                      "Makro",
                      "Naivas",
                      "OK Foods",
                      "Panarottis",
                      "Pick n Pay",
                      "PnA",
                      "PQ Clothing",
                      "Rage",
                      "Sefalana",
                      "Sasol",
                      "Shell",
                      "Shoprite",
                      "Signature Cosmetics & Fragrances",
                      "Spar",
                      "Spur",
                      "TFG Group",
                      "Total Energies",
                      "Toys R Us",
                      "Woermann Brock",
                      "Woolworths"
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: shopName,
                    builder:
                        (BuildContext context, String value, Widget? child) {
                      return Visibility(
                        visible: value != "",
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            MihCardDisplay(
                                shopName: shopName.value,
                                nickname: "",
                                height: 200),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
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
                          controller: cardNumberController,
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
                          if (shopController.text == "") {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const MIHErrorMessage(
                                    errorType: "Input Error");
                              },
                            );
                          } else {
                            int statusCode =
                                await MIHMzansiWalletApis.addLoyaltyCardAPICall(
                              widget.signedInUser,
                              widget.signedInUser.app_id,
                              shopController.text,
                              cardNumberController.text,
                              "",
                              0,
                              _nicknameController.text,
                              context,
                            );
                            if (statusCode == 201) {
                              setState(() {
                                cardList = MIHMzansiWalletApis.getLoyaltyCards(
                                    widget.signedInUser.app_id);
                              });
                              context.pop();
                              successPopUp(
                                "Successfully Added Card",
                                "The loyalty card has been added to your favourites.",
                                0,
                              );
                            } else {
                              internetConnectionPopUp();
                            }
                          }
                        } else {
                          MihAlertServices().formNotFilledCompletely(context);
                        }
                      },
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        "Add",
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

  @override
  void dispose() {
    cardNumberController.dispose();
    shopController.removeListener(shopSelected);
    shopController.dispose();
    cardSearchController.removeListener(searchShop);
    cardSearchController.dispose();
    searchShopName.dispose();
    _nicknameController.dispose();
    searchFocusNode.dispose();
    shopName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    cardList = MIHMzansiWalletApis.getLoyaltyCards(widget.signedInUser.app_id);
    shopController.addListener(shopSelected);
    cardSearchController.addListener(searchShop);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(width),
    );
  }

  Widget getBody(double width) {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 20),
                child: MihSearchBar(
                  controller: cardSearchController,
                  hintText: "Search Cards",
                  // prefixIcon: Icons.search,
                  prefixIcon: Icons.search,
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  hintColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  onPrefixIconTap: () {
                    // print("Search Icon Pressed: ${cardSearchController.text}");
                  },
                  searchFocusNode: searchFocusNode,
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                future: cardList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Mihloadingcircle(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    listOfCards = snapshot.data!;
                    searchShop();
                    return ValueListenableBuilder(
                      valueListenable: searchShopName,
                      builder: (BuildContext context,
                          List<MIHLoyaltyCard> value, Widget? child) {
                        return BuildLoyaltyCardList(
                          cardList: value,
                          signedInUser: widget.signedInUser,
                          navIndex: 0,
                          bannerAd: _bannerAd,
                          favouritesMode: false,
                          searchText: cardSearchController,
                          onCardViewClose: () {
                            setState(() {
                              _bannerAd = MihBannerAd();
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("Error Loading Loyalty Cards"),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: MihFloatingMenu(
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.add,
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                  label: "Add Loyalty Card",
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
                    addCardWindow(context, width);
                  },
                )
              ]),
        )
      ],
    );
  }
}
