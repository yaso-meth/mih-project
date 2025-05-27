import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_mzansi_wallet_apis.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_number_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_delete_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_card_display.dart';
import 'package:flutter/material.dart';

// import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:barcode_widget/barcode_widget.dart';

class BuildLoyaltyCardList extends StatefulWidget {
  final AppUser signedInUser;
  final List<MIHLoyaltyCard> cardList;
  final int navIndex;

  const BuildLoyaltyCardList({
    super.key,
    required this.signedInUser,
    required this.cardList,
    required this.navIndex,
  });

  @override
  State<BuildLoyaltyCardList> createState() => _BuildLoyaltyCardListState();
}

class _BuildLoyaltyCardListState extends State<BuildLoyaltyCardList> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  late int _noFavourites;

  void openscanner() async {
    Navigator.of(context).pushNamed(
      '/scanner',
      arguments: _cardNumberController,
    );
  }

  void editCardWindow(BuildContext ctxt, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Edit Loyalty Card",
        windowTools: null,
        onWindowTapClose: () {
          _cardNumberController.clear();
          _nicknameController.clear();
          Navigator.pop(context);
        },
        windowBody: Column(
          children: [
            MIHTextField(
              controller: _nicknameController,
              hintText: "Card Title",
              editable: true,
              required: false,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: MIHNumberField(
                    controller: _cardNumberController,
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
                  if (_cardNumberController.text == "") {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const MIHErrorMessage(errorType: "Input Error");
                      },
                    );
                  } else {
                    MIHMzansiWalletApis.updateLoyaltyCardAPICall(
                      widget.signedInUser,
                      widget.cardList[index].idloyalty_cards,
                      widget.cardList[index].favourite,
                      widget.cardList[index].priority_index,
                      _nicknameController.text,
                      _cardNumberController.text,
                      0,
                      ctxt,
                    );
                  }
                },
                buttonText: "Update",
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                textColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteCardWindow(BuildContext ctxt, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MIHDeleteMessage(
            deleteType: "Loyalty Card",
            onTap: () {
              MIHMzansiWalletApis.deleteLoyaltyCardAPICall(
                widget.signedInUser,
                widget.cardList[index].idloyalty_cards,
                widget.navIndex,
                context,
              );
            });
      },
    );
  }

  void addToFavCardWindow(BuildContext ctxt, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.favorite,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            size: 100,
          ),
          alertTitle: "Add to Favourites",
          alertBody: Column(
            children: [
              Text(
                "Are you sure you want to add this card to your favourites?",
                style: TextStyle(
                  fontSize: 20,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: MIHButton(
                  onTap: () {
                    MIHMzansiWalletApis.updateLoyaltyCardAPICall(
                      widget.signedInUser,
                      widget.cardList[index].idloyalty_cards,
                      "Yes",
                      _noFavourites,
                      widget.cardList[index].nickname,
                      widget.cardList[index].card_number,
                      1,
                      ctxt,
                    );
                  },
                  buttonText: "Add",
                  buttonColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  textColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
              ),
            ],
          ),
          alertColour: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
    );
  }

  void removeFromFavCardWindow(BuildContext ctxt, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.favorite_border,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            size: 100,
          ),
          alertTitle: "Remove From Favourites",
          alertBody: Column(
            children: [
              Text(
                "Are you sure you want to remove this card from your favourites?",
                style: TextStyle(
                  fontSize: 20,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: MIHButton(
                  onTap: () {
                    MIHMzansiWalletApis.updateLoyaltyCardAPICall(
                      widget.signedInUser,
                      widget.cardList[index].idloyalty_cards,
                      "",
                      0,
                      widget.cardList[index].nickname,
                      widget.cardList[index].card_number,
                      0,
                      ctxt,
                    );
                  },
                  buttonText: "Remove",
                  buttonColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  textColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
              ),
            ],
          ),
          alertColour: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
    );
  }

  void viewCardWindow(int index) {
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
        windowTools: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: MihFloatingMenu(
            animatedIcon: AnimatedIcons.menu_close,
            direction: SpeedDialDirection.down,
            children: [
              SpeedDialChild(
                child: widget.cardList[index].favourite == ""
                    ? Icon(
                        Icons.favorite,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                label: widget.cardList[index].favourite == ""
                    ? "Add to Favourite"
                    : "Remove from Favourite",
                labelBackgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                labelStyle: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                onTap: () {
                  if (widget.cardList[index].favourite == "") {
                    addToFavCardWindow(context, index);
                  } else {
                    removeFromFavCardWindow(context, index);
                  }
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.edit,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
                label: "Edit Card Details",
                labelBackgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                labelStyle: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                onTap: () {
                  setState(() {
                    _cardNumberController.text =
                        widget.cardList[index].card_number;
                    _nicknameController.text = widget.cardList[index].nickname;
                  });
                  editCardWindow(context, index);
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.delete,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
                label: "Delete Card",
                labelBackgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                labelStyle: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                onTap: () {
                  deleteCardWindow(context, index);
                },
              ),
            ],
          ),
        ),
        onWindowTapClose: () {
          Navigator.pop(context);
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
                        //color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                        //MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  double getHorizontalPaddingSize(Size screenSize) {
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
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
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(
          left: getHorizontalPaddingSize(size),
          right: getHorizontalPaddingSize(size),
          //bottom: height / 5,
          //top: 20,
        ),
        // physics: ,
        // shrinkWrap: true,
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
              viewCardWindow(index);
            },
          );
        },
      );
      // return ListView.separated(
      //   shrinkWrap: true,
      //   physics: const NeverScrollableScrollPhysics(),
      //   separatorBuilder: (BuildContext context, int index) {
      //     return Divider(
      //       color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      //     );
      //   },
      //   itemCount: widget.cardList.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: MihCardDisplay(
      //           shopName: widget.cardList[index].shop_name, height: 200),

      //       onTap: () {
      //         viewCardWindow(index);
      //       },
      //     );
      //   },
      // );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: SizedBox(
          height: size.height,
          child: const Align(
            alignment: Alignment.topCenter,
            child: Text(
              "No Cards Available",
              style: TextStyle(fontSize: 25, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }
}
