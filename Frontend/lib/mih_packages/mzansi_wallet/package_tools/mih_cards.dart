import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_mzansi_wallet_apis.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_number_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_search_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih-app_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
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
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardSearchController = TextEditingController();
  late Future<List<MIHLoyaltyCard>> cardList;
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
            .contains(cardSearchController.text.toLowerCase())) {
          temp.add(item);
        }
      }
      searchShopName.value = temp;
    }
  }

  void openscanner() async {
    Navigator.of(context).pushNamed(
      '/scanner',
      arguments: cardNumberController,
    );
  }

  void shopSelected() {
    if (shopController.text.isNotEmpty) {
      shopName.value = shopController.text;
    } else {
      shopName.value = "";
    }
  }

  void addCardWindow(BuildContext ctxt) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MIHWindow(
        fullscreen: false,
        windowTitle: "Add New Loyalty Card",
        windowTools: const [
          SizedBox(width: 35),
          // IconButton(
          //   onPressed: () {
          //     //Delete card API Call
          //   },
          //   icon: Icon(
          //     Icons.delete,
          //     color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          //   ),
          // ),
        ],
        onWindowTapClose: () {
          shopController.clear();
          cardNumberController.clear();
          shopName.value = "";
          Navigator.pop(context);
        },
        windowBody: [
          MIHDropdownField(
            controller: shopController,
            hintText: "Shop Name",
            dropdownOptions: const [
              "Apple Tree",
              "Best Before",
              "Checkers",
              "Clicks",
              "Cotton:On",
              "Dis-Chem",
              "Edgars",
              "Eskom",
              "Fresh Stop",
              "Infinity",
              "Jet",
              "Makro",
              "Panarottis",
              "Pick n Pay",
              "Shell",
              "Shoprite",
              "Spar",
              "Spur",
              "Woolworths"
            ],
            required: true,
            editable: true,
            enableSearch: false,
          ),
          ValueListenableBuilder(
            valueListenable: shopName,
            builder: (BuildContext context, String value, Widget? child) {
              return Visibility(
                visible: value != "",
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    MihCardDisplay(shopName: shopName.value, height: 200),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: MIHNumberField(
                  controller: cardNumberController,
                  hintText: "Card Number",
                  editable: true,
                  required: true,
                  enableDecimal: false,
                ),
              ),
              const SizedBox(width: 10),
              MIHButton(
                onTap: () async {
                  openscanner();
                },
                buttonText: "Scan",
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                textColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 300,
            height: 50,
            child: MIHButton(
              onTap: () {
                if (shopController.text == "" ||
                    cardNumberController.text == "") {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const MIHErrorMessage(errorType: "Input Error");
                    },
                  );
                } else {
                  MIHMzansiWalletApis.addLoyaltyCardAPICall(
                    widget.signedInUser,
                    widget.signedInUser.app_id,
                    shopController.text,
                    cardNumberController.text,
                    context,
                  );
                }
              },
              buttonText: "Add",
              buttonColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            ),
          ),
        ],
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
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Loyalty Cards",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 4,
                    child: SizedBox(
                      height: 50,
                      child: MIHSearchField(
                        controller: cardSearchController,
                        hintText: "Shop Name",
                        required: false,
                        editable: true,
                        onTap: () {},
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        cardSearchController.clear();
                      },
                      icon: const Icon(Icons.filter_alt_off),
                    ),
                  ),
                ],
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
                          cardList: searchShopName.value,
                          signedInUser: widget.signedInUser,
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
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
              child: IconButton(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                onPressed: () {
                  addCardWindow(context);
                },
                icon: const Icon(
                  Icons.add_card,
                  size: 50,
                ),
              ),
            ))
      ],
    );
  }
}
