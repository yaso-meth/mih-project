import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/package_tools/mih_card_favourites.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/package_tools/mih_cards.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_data_helper_services.dart';
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
  bool _isLoadingInitialData = true;
  late final MihCards _cards;
  late final MihCardFavourites _cardFavourites;

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingInitialData = true;
    });
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    MzansiWalletProvider walletProvider = context.read<MzansiWalletProvider>();
    if (mzansiProfileProvider.user == null) {
      await MihDataHelperServices().loadUserDataOnly(
        mzansiProfileProvider,
      );
    }
    await setLoyaltyCards(mzansiProfileProvider, walletProvider);
    await setFavouritesCards(mzansiProfileProvider, walletProvider);
    setState(() {
      _isLoadingInitialData = false;
    });
  }

  Future<void> setLoyaltyCards(
    MzansiProfileProvider mzansiProfileProvider,
    MzansiWalletProvider walletProvider,
  ) async {
    await MIHMzansiWalletApis.getLoyaltyCards(
        walletProvider, mzansiProfileProvider.user!.app_id, context);
  }

  Future<void> setFavouritesCards(
    MzansiProfileProvider mzansiProfileProvider,
    MzansiWalletProvider walletProvider,
  ) async {
    await MIHMzansiWalletApis.getFavouriteLoyaltyCards(
        walletProvider, mzansiProfileProvider.user!.app_id, context);
  }

  @override
  void initState() {
    super.initState();
    _cards = MihCards();
    _cardFavourites = MihCardFavourites();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiWalletProvider>(
      builder: (BuildContext context, MzansiWalletProvider walletProvider,
          Widget? child) {
        if (_isLoadingInitialData) {
          return Scaffold(
            body: Center(
              child: Mihloadingcircle(),
            ),
          );
        }
        return MihPackage(
          appActionButton: getAction(),
          appTools: getTools(),
          appBody: getToolBody(),
          appToolTitles: getToolTitle(),
          selectedbodyIndex: walletProvider.toolIndex,
          onIndexChange: (newIndex) {
            walletProvider.setToolIndex(newIndex);
          },
        );
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
    return [
      _cards,
      _cardFavourites,
    ];
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Cards",
      "Favourites",
    ];
    return toolTitles;
  }
}
