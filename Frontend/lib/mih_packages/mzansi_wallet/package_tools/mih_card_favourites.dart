import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_banner_ad.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_wallet_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/loyalty_card.dart';
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
  late MihBannerAd _bannerAd;
  List<MIHLoyaltyCard> listOfCards = [];

  @override
  void initState() {
    super.initState();
    _bannerAd = MihBannerAd();
    cardList = MIHMzansiWalletApis.getFavouriteLoyaltyCards(
      widget.signedInUser.app_id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Column(
            children: [
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
                      bannerAd: _bannerAd,
                      favouritesMode: true,
                      onCardViewClose: () {
                        setState(() {
                          _bannerAd = MihBannerAd();
                        });
                        Navigator.pop(context);
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
        //                 MzansiInnovationHub.of(context)!.theme.primaryColor(),
        //           ),
        //           label: "Add Loyalty Card",
        //           labelBackgroundColor:
        //               MzansiInnovationHub.of(context)!.theme.successColor(),
        //           labelStyle: TextStyle(
        //             color:
        //                 MzansiInnovationHub.of(context)!.theme.primaryColor(),
        //             fontWeight: FontWeight.bold,
        //           ),
        //           backgroundColor:
        //               MzansiInnovationHub.of(context)!.theme.successColor(),
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
