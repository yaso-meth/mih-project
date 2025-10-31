import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_wallet_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/builder/build_loyalty_card_list.dart';
import 'package:provider/provider.dart';

class MihCardFavourites extends StatefulWidget {
  const MihCardFavourites({
    super.key,
  });

  @override
  State<MihCardFavourites> createState() => _MihCardFavouritesState();
}

class _MihCardFavouritesState extends State<MihCardFavourites> {
  late Future<List<MIHLoyaltyCard>> cardList;
  List<MIHLoyaltyCard> listOfCards = [];

  void getFavouriteLoyaltyCards(BuildContext context) async {
    setState(() {
      listOfCards = context.read<MzansiWalletProvider>().favouriteCards;
    });
  }

  @override
  void initState() {
    getFavouriteLoyaltyCards(context);
    super.initState();
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
              BuildLoyaltyCardList(
                cardList: listOfCards,
                navIndex: 0,
                favouritesMode: true,
                searchText: TextEditingController(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
