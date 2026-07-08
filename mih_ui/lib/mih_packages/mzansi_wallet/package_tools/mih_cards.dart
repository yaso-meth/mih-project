import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_wallet_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_add_card_window.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/builder/build_loyalty_card_list.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:provider/provider.dart';

class MihCards extends StatefulWidget {
  const MihCards({
    super.key,
  });

  @override
  State<MihCards> createState() => _MihCardsState();
}

class _MihCardsState extends State<MihCards> {
  final TextEditingController cardSearchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final ValueNotifier<List<MIHLoyaltyCard>> searchShopName = ValueNotifier([]);
  final MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.unrestricted,
  );
  final boxFit = BoxFit.contain;
  late MzansiWalletProvider _walletProvider;
  late VoidCallback _searchListener;

  void searchShop(List<MIHLoyaltyCard> allCards) {
    if (cardSearchController.text.isEmpty) {
      searchShopName.value = allCards;
    } else {
      List<MIHLoyaltyCard> temp = [];
      for (var item in allCards) {
        if (item.shop_name
                .toLowerCase()
                .contains(cardSearchController.text.toLowerCase()) ||
            item.nickname
                .toLowerCase()
                .contains(cardSearchController.text.toLowerCase())) {
          temp.add(item);
        }
      }
      searchShopName.value = temp;
    }
  }

  void successPopUp(String title, String message, int packageIndex) {
    MihAlertServices().successBasicAlert(
      title,
      message,
      context,
    );
  }

  void addCardWindow(BuildContext ctxt, double width) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihAddCardWindow(),
    );
  }

  @override
  void dispose() {
    cardSearchController.removeListener(_searchListener);
    cardSearchController.dispose();
    searchShopName.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _walletProvider = context.read<MzansiWalletProvider>();
    _searchListener = () {
      searchShop(_walletProvider.loyaltyCards);
    };
    searchShopName.value = _walletProvider.loyaltyCards;
    cardSearchController.addListener(_searchListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      bodyItem: getBody(width),
    );
  }

  Widget getBody(double width) {
    return Consumer<MzansiWalletProvider>(
      builder: (BuildContext context, MzansiWalletProvider walletProvider,
          Widget? child) {
        if (cardSearchController.text.isEmpty) {
          searchShopName.value = walletProvider.loyaltyCards;
        } else {
          // Re-run search with updated card list
          searchShop(walletProvider.loyaltyCards);
        }
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: MihSearchBar(
                    controller: cardSearchController,
                    hintText: "Search Cards",
                    // prefixIcon: Icons.search,
                    prefixIcon: Icons.search,
                    fillColor: MihColors.secondary(),
                    hintColor: MihColors.primary(),
                    onPrefixIconTap: () {
                      // print("Search Icon Pressed: ${cardSearchController.text}");
                    },
                    searchFocusNode: searchFocusNode,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ValueListenableBuilder<List<MIHLoyaltyCard>>(
                    valueListenable: searchShopName,
                    builder: (context, filteredCards, child) {
                      return BuildLoyaltyCardList(
                        cardList: filteredCards, //listOfCards,
                        navIndex: 0,
                        favouritesMode: false,
                        searchText: cardSearchController,
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: MihFloatingMenu(
                  animatedIcon: AnimatedIcons.menu_close,
                  children: [
                    SpeedDialChild(
                      child: Icon(
                        Icons.add,
                        color: MihColors.primary(),
                      ),
                      label: "Add Loyalty Card",
                      labelBackgroundColor: MihColors.green(),
                      labelStyle: TextStyle(
                        color: MihColors.primary(),
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: MihColors.green(),
                      onTap: () {
                        addCardWindow(context, width);
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(
                        Icons.cloud_sync_rounded,
                        color: MihColors.primary(),
                      ),
                      label: "Sync Wallet",
                      labelBackgroundColor: MihColors.green(),
                      labelStyle: TextStyle(
                        color: MihColors.primary(),
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: MihColors.green(),
                      onTap: () async {
                        MzansiProfileProvider profileProvider =
                            context.read<MzansiProfileProvider>();
                        bool success = await walletProvider
                            .syncWithMihServerData(profileProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            MihSnackBar(
                              child: Text(
                                success
                                    ? "Wallet Synced with MIH Cloud."
                                    : "MIH App operation in Offline Mode",
                              ),
                              // backgroundColor: success ? null : MihColors.red(),
                            ),
                          );
                        }
                      },
                    )
                  ]),
            )
          ],
        );
      },
    );
  }
}
