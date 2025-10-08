import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_banner_ad.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_wallet_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_add_card_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/builder/build_loyalty_card_list.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class MihCards extends StatefulWidget {
  final AppUser signedInUser;
  const MihCards({
    super.key,
    required this.signedInUser,
  });

  @override
  State<MihCards> createState() => _MihCardsState();
}

class _MihCardsState extends State<MihCards> {
  final TextEditingController cardSearchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  MihBannerAd _bannerAd = MihBannerAd();
  List<MIHLoyaltyCard> listOfCards = [];
  final ValueNotifier<List<MIHLoyaltyCard>> searchShopName = ValueNotifier([]);
  final MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.unrestricted,
  );
  final boxFit = BoxFit.contain;

  void searchShop() {
    if (cardSearchController.text.isEmpty) {
      searchShopName.value = listOfCards;
    } else {
      List<MIHLoyaltyCard> temp = [];
      for (var item in listOfCards) {
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
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.check_circle_outline_rounded,
            size: 150,
            color: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          alertTitle: title,
          alertBody: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: MihButton(
                  onPressed: () {
                    context.pop();
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  elevation: 10,
                  width: 300,
                  child: Text(
                    "Dismiss",
                    style: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          alertColour: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
    );
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(
          errorType: "Internet Connection",
        );
      },
    );
  }

  void addCardWindow(BuildContext ctxt, double width) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihAddCardWindow(
        signedInUser: widget.signedInUser,
      ),
    );
  }

  @override
  void dispose() {
    cardSearchController.removeListener(searchShop);
    cardSearchController.dispose();
    searchShopName.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void getLoyaltyCards(BuildContext context) async {
    setState(() {
      listOfCards = context.read<MzansiWalletProvider>().loyaltyCards;
    });
    searchShop();
  }

  @override
  void initState() {
    getLoyaltyCards(context);
    cardSearchController.addListener(searchShop);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(width),
    );
  }

  Widget getBody(double width) {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 20),
                child: MihSearchBar(
                  controller: cardSearchController,
                  hintText: "Search Cards",
                  // prefixIcon: Icons.search,
                  prefixIcon: Icons.search,
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  hintColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  onPrefixIconTap: () {
                    // print("Search Icon Pressed: ${cardSearchController.text}");
                  },
                  searchFocusNode: searchFocusNode,
                ),
              ),
              const SizedBox(height: 10),
              Consumer<MzansiWalletProvider>(
                builder: (context, mzansiWalletProvider, child) {
                  listOfCards = mzansiWalletProvider.loyaltyCards;
                  return ValueListenableBuilder<List<MIHLoyaltyCard>>(
                      valueListenable: searchShopName,
                      builder: (context, filteredCards, child) {
                        return BuildLoyaltyCardList(
                          cardList: filteredCards, //listOfCards,
                          signedInUser: widget.signedInUser,
                          navIndex: 0,
                          bannerAd: _bannerAd,
                          favouritesMode: false,
                          searchText: cardSearchController,
                          onCardViewClose: () {
                            setState(() {
                              _bannerAd = MihBannerAd();
                            });
                            // Navigator.pop(context);
                          },
                        );
                      });
                },
              ),
            ],
          ),
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
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                  label: "Add Loyalty Card",
                  labelBackgroundColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  labelStyle: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  onTap: () {
                    addCardWindow(context, width);
                  },
                )
              ]),
        )
      ],
    );
  }
}
