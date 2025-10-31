import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_banner_ad_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/package_tools/mih_card_favourites.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/package_tools/mih_cards.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_wallet_services.dart';
import 'package:provider/provider.dart';

class MihWallet extends StatefulWidget {
  const MihWallet({
    super.key,
  });

  @override
  State<MihWallet> createState() => _MihWalletState();
}

class _MihWalletState extends State<MihWallet> {
  bool isLoading = true;

  Future<void> setLoyaltyCards(
      MzansiProfileProvider mzansiProfileProvider) async {
    await MIHMzansiWalletApis.getLoyaltyCards(
        mzansiProfileProvider.user!.app_id, context);
  }

  Future<void> setFavouritesCards(
      MzansiProfileProvider mzansiProfileProvider) async {
    await MIHMzansiWalletApis.getFavouriteLoyaltyCards(
        mzansiProfileProvider.user!.app_id, context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var mzansiProfileProvider = context.read<MzansiProfileProvider>();
      await setLoyaltyCards(mzansiProfileProvider);
      await setFavouritesCards(mzansiProfileProvider);
      context.read<MihBannerAdProvider>().loadBannerAd();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: context.watch<MzansiWalletProvider>().toolIndex,
      onIndexChange: (newIndex) {
        context.read<MzansiWalletProvider>().setToolIndex(newIndex);
        // setState(() {
        //   _selcetedIndex = newValue;
        // });
        // print("Index: $_selcetedIndex");
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        context.goNamed(
          'mihHome',
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.card_membership)] = () {
      context.read<MzansiWalletProvider>().setToolIndex(0);
    };
    temp[const Icon(Icons.favorite)] = () {
      context.read<MzansiWalletProvider>().setToolIndex(1);
    };

    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MzansiWalletProvider>().toolIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      MihCards(),
      MihCardFavourites(),
    ];
    if (isLoading) {
      return [
        const Center(
          child: Mihloadingcircle(),
        )
      ];
    }
    return toolBodies;
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Cards",
      "Favourites",
    ];
    return toolTitles;
  }
}
