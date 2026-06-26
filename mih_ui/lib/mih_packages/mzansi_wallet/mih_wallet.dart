import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
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

  Future<void> _loadInitialData() async {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    mzansiProfileProvider.loadCachedProfileState();
    MzansiWalletProvider walletProvider = context.read<MzansiWalletProvider>();
    walletProvider.loadCachedWallet();
    if (mzansiProfileProvider.user == null) {
      mzansiProfileProvider.syncWithMihServerData();
    }
    if (walletProvider.loyaltyCards.isEmpty) {
      walletProvider.syncWithMihServerData(mzansiProfileProvider);
    }
    setState(() {
      _isLoadingInitialData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInitialData();
      }
    });
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
          packageActionButton: getAction(),
          packageTools: getTools(),
          packageToolBodies: getToolBody(),
          packageToolTitles: getToolTitle(),
          selectedBodyIndex: walletProvider.toolIndex,
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
      iconColor: MihColors.secondary(),
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
      selectedIndex: context.watch<MzansiWalletProvider>().toolIndex,
    );
  }

  List<Widget> getToolBody() {
    return [
      MihCards(),
      MihCardFavourites(),
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
