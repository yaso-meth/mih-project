import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_wallet_apis.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_delete_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_card_display.dart';
import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();

  void openscanner() async {
    Navigator.of(context).pushNamed(
      '/scanner',
      arguments: _cardNumberController,
    );
  }

  void editCardWindow(BuildContext ctxt, int index, double width) {
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
              MzanziInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.05)
                  : EdgeInsets.symmetric(horizontal: width * 0),
          child: Column(
            children: [
              MihForm(
                formKey: _formKey,
                formFields: [
                  MihTextFormField(
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                          fillColor: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          inputColor: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
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
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        width: 100,
                        child: Text(
                          "Scan",
                          style: TextStyle(
                            color: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
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
                        } else {
                          MihAlertServices().formNotFilledCompletely(context);
                        }
                      },
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      width: 300,
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
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
              MihButton(
                onPressed: () {
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
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                width: 300,
                child: Text(
                  "Add",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
              MihButton(
                onPressed: () {
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
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                width: 300,
                child: Text(
                  "Remove",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          alertColour: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
    );
  }

  void viewCardWindow(int index, double width) {
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
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  )
                : Icon(
                    Icons.favorite_border,
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                _cardNumberController.text = widget.cardList[index].card_number;
                _nicknameController.text = widget.cardList[index].nickname;
              });
              editCardWindow(context, index, width);
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
              viewCardWindow(index, size.width);
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
