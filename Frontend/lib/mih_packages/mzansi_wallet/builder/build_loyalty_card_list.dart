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
                const SizedBox(height: 10),
                SizedBox(
                  height: 75,
                  width: 300,
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
                const SizedBox(height: 10),
                Text(
                  widget.cardList[index].card_number,
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
    );
  }

  double getHorizontalPaddingSize(Size screenSize) {
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      return screenSize.width / 10;
    } else {
      return 20;
    }
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
          crossAxisSpacing: 10,
          maxCrossAxisExtent: 175,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            child: MihCardDisplay(
                shopName: widget.cardList[index].shop_name, height: 100),
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
