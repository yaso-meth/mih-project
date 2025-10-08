import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/package_tools/mih_card_favourites.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/package_tools/mih_cards.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_wallet_services.dart';
import 'package:provider/provider.dart';

class MihWallet extends StatefulWidget {
  final WalletArguments arguments;
  const MihWallet({
    super.key,
    required this.arguments,
  });

  @override
  State<MihWallet> createState() => _MihWalletState();
}

class _MihWalletState extends State<MihWallet> {
  bool isLoading = true;

  void setPackageIndex() {
    if (widget.arguments.index >= 0 && widget.arguments.index <= 3) {
      context.read<MzansiWalletProvider>().setToolIndex(widget.arguments.index);
    }
  }

  Future<void> setLoyaltyCards() async {
    await MIHMzansiWalletApis.getLoyaltyCards(
        widget.arguments.signedInUser.app_id, context);
  }

  Future<void> setFavouritesCards() async {
    await MIHMzansiWalletApis.getFavouriteLoyaltyCards(
        widget.arguments.signedInUser.app_id, context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setPackageIndex();
      await setLoyaltyCards();
      await setFavouritesCards();
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
          extra: true,
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
      MihCards(
        signedInUser: widget.arguments.signedInUser,
      ),
      MihCardFavourites(
        signedInUser: widget.arguments.signedInUser,
      ),
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
