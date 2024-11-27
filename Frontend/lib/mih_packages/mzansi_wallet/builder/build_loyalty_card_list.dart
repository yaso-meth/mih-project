import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_apis/mih_mzansi_wallet_apis.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_window.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/loyalty_card.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_wallet/components/mih_card_display.dart';
import 'package:flutter/material.dart';

// import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:barcode_widget/barcode_widget.dart';

class BuildLoyaltyCardList extends StatefulWidget {
  final AppUser signedInUser;
  final List<MIHLoyaltyCard> cardList;
  const BuildLoyaltyCardList({
    super.key,
    required this.signedInUser,
    required this.cardList,
  });

  @override
  State<BuildLoyaltyCardList> createState() => _BuildLoyaltyCardListState();
}

class _BuildLoyaltyCardListState extends State<BuildLoyaltyCardList> {
  void viewCardWindow(int index) {
    //print(widget.cardList[index].card_number);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MIHWindow(
        fullscreen: false,
        windowTitle: widget.cardList[index].shop_name.toUpperCase(),
        windowTools: [
          IconButton(
            onPressed: () {
              MIHMzansiWalletApis.deleteLoyaltyCardAPICall(
                widget.signedInUser,
                widget.cardList[index].idloyalty_cards,
                context,
              );
            },
            icon: Icon(
              Icons.delete,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
        ],
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowBody: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MihCardDisplay(
                  shopName: widget.cardList[index].shop_name, height: 250),
            ],
          ),
          //const SizedBox(height: 10),
          Container(
            width: 250,
            //color: Colors.white,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: 200,
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
                Text(
                  "Card Number: ${widget.cardList[index].card_number}",
                  style: TextStyle(
                    color: Colors.black,
                    //MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cardList.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          );
        },
        itemCount: widget.cardList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: MihCardDisplay(
                shopName: widget.cardList[index].shop_name, height: 200),
            // subtitle: Text(
            //   "Card Number: ${widget.cardList[index].card_number}",
            //   style: TextStyle(
            //     color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            //   ),
            // ),
            // trailing: Icon(
            //   Icons.arrow_forward,
            //   color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            // ),
            onTap: () {
              viewCardWindow(index);
            },
          );
        },
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(top: 25.0),
        child: Center(
          child: Text(
            "No Cards Available",
            style: TextStyle(fontSize: 25, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
