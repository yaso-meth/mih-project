import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_mzansi_wallet_apis.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/builder/build_loyalty_card_list.dart';

class MihCardFavourites extends StatefulWidget {
  final AppUser signedInUser;
  const MihCardFavourites({
    super.key,
    required this.signedInUser,
  });

  @override
  State<MihCardFavourites> createState() => _MihCardFavouritesState();
}

class _MihCardFavouritesState extends State<MihCardFavourites> {
  late Future<List<MIHLoyaltyCard>> cardList;
  List<MIHLoyaltyCard> listOfCards = [];

  @override
  void initState() {
    super.initState();
    cardList = MIHMzansiWalletApis.getFavouriteLoyaltyCards(
      widget.signedInUser.app_id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
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
                    "Favourites",
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
              Divider(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
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
                    // searchShop();
                    return BuildLoyaltyCardList(
                      cardList: listOfCards,
                      signedInUser: widget.signedInUser,
                      navIndex: 0,
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
        // Positioned(
        //   right: 0,
        //   bottom: 0,
        //   child: MihFloatingMenu(
        //       animatedIcon: AnimatedIcons.menu_close,
        //       children: [
        //         SpeedDialChild(
        //           child: Icon(
        //             Icons.add,
        //             color:
        //                 MzanziInnovationHub.of(context)!.theme.primaryColor(),
        //           ),
        //           label: "Add Loyalty Card",
        //           labelBackgroundColor:
        //               MzanziInnovationHub.of(context)!.theme.successColor(),
        //           labelStyle: TextStyle(
        //             color:
        //                 MzanziInnovationHub.of(context)!.theme.primaryColor(),
        //             fontWeight: FontWeight.bold,
        //           ),
        //           backgroundColor:
        //               MzanziInnovationHub.of(context)!.theme.successColor(),
        //           onTap: () {
        //             // addCardWindow(context);
        //           },
        //         )
        //       ]),
        // )
      ],
    );
  }
}
