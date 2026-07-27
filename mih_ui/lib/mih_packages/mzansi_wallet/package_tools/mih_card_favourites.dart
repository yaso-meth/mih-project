import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_wallet_provider.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiWalletProvider>(
      builder: (BuildContext context, MzansiWalletProvider walletProvider,
          Widget? child) {
        return MihPackageToolBody(
          backgroundColor: MihColors.primary(),
          borderOn: false,
          bodyItem: getBody(walletProvider),
        );
      },
    );
  }

  Widget getBody(MzansiWalletProvider walletProvider) {
    return BuildLoyaltyCardList(
      cardList: walletProvider.favouriteCards,
      navIndex: 0,
      favouritesMode: true,
      searchText: TextEditingController(),
    );
  }
}
