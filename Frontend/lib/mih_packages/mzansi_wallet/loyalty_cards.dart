import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_apis/mih_mzansi_wallet_apis.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_number_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_search_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_window.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/loyalty_card.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_wallet/builder/build_loyalty_card_list.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_wallet/components/mih_card_display.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class LoyaltyCards extends StatefulWidget {
  final AppUser signedInUser;
  const LoyaltyCards({
    super.key,
    required this.signedInUser,
  });

  @override
  State<LoyaltyCards> createState() => _LoyaltyCardsState();
}

class _LoyaltyCardsState extends State<LoyaltyCards> {
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

  void foundCode(BarcodeCapture bcode) {
    if (bcode.barcodes.first.rawValue != null) {
      setState(() {
        cardNumberController.text = bcode.barcodes.first.rawValue!;
      });
      //print(bcode.barcodes.first.rawValue);
      scannerController.stop();
      Navigator.of(context).pop();
    }
  }

  void openscanner() async {
    if (MzanziInnovationHub.of(context)!.theme.getPlatform() == "Web") {
      print("================ Web ====================");
      print("here 1");
      try {
        String? res = await SimpleBarcodeScanner.scanBarcode(
          context,
          barcodeAppBar: const BarcodeAppBar(
            appBarTitle: 'Scan Barcode',
            centerTitle: true,
            enableBackButton: true,
            backButtonIcon: Icon(Icons.arrow_back),
          ),
          isShowFlashIcon: true,
          delayMillis: 500,
          cameraFace: CameraFace.back,
          scanFormat: ScanFormat.ONLY_BARCODE,
        );
        if (res != null) {
          setState(() {
            cardNumberController.text = res;
          });
        }
      } catch (error) {
        print(error);
      }
    } else {
      Navigator.of(context).pushNamed(
        '/scanner',
        arguments: cardNumberController,
      );
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

  void shopSelected() {
    if (shopController.text.isNotEmpty) {
      shopName.value = shopController.text;
    } else {
      shopName.value = "";
    }
  }

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
    return FutureBuilder(
      future: cardList,
      builder: (context, snapshot) {
        //print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Mihloadingcircle(),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          listOfCards = snapshot.data!;
          searchShop();
          //print(listOfCards);
          return Column(
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
                  IconButton(
                    icon: const Icon(Icons.add_card),
                    alignment: Alignment.topRight,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    onPressed: () {
                      addCardWindow(context);
                    },
                  )
                ],
              ),
              // Divider(
              //   color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              // ),
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
              ValueListenableBuilder(
                valueListenable: searchShopName,
                builder: (BuildContext context, List<MIHLoyaltyCard> value,
                    Widget? child) {
                  return BuildLoyaltyCardList(
                    cardList: searchShopName.value,
                    signedInUser: widget.signedInUser,
                  );
                },
              ),
            ],
          );
        } else {
          return const Center(
            child: Text("Error Loading Loyalty Cards"),
          );
        }
      },
    );
  }
}
