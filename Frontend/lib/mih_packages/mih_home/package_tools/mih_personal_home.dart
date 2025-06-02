import 'package:flutter/services.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/package_tile/about_mih_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/access_review/package_tile/mih_access_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/calculator/package_tiles/mih_calculator_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/package_tiles/mzansi_calendar_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_ai/package_tiles/mzansi_ai_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/package_tiles/mzansi_profile_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/package_tiles/mzansi_setup_profile_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/package_tiles/mih_wallet_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/package_tiles/patient_profile_tile.dart';
import 'package:flutter/material.dart';

class MihPersonalHome extends StatefulWidget {
  final AppUser signedInUser;
  final bool personalSelected;
  final Business? business;
  final BusinessUser? businessUser;
  final ImageProvider<Object>? propicFile;
  final bool isUserNew;
  final bool isDevActive;

  const MihPersonalHome({
    super.key,
    required this.signedInUser,
    required this.personalSelected,
    required this.business,
    required this.businessUser,
    required this.propicFile,
    required this.isUserNew,
    required this.isDevActive,
  });

  @override
  State<MihPersonalHome> createState() => _MihPersonalHomeState();
}

class _MihPersonalHomeState extends State<MihPersonalHome>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  late List<Map<String, Widget>> personalPackagesMap;
  final ValueNotifier<List<Map<String, Widget>>> searchPackageName =
      ValueNotifier([]);
  double packageSize = 200;
  late final AnimationController _marqueeController;
  late final ScrollController _scrollController;
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _focusNode = FocusNode();
  final String maintenanceMsg =
      "\tHeads up! We're doing maintenance on Thur, 15 May 2025 at 10 PM (CAT). MIH may be unavailable briefly.";

  void _startMarquee() async {
    while (mounted) {
      final double maxScroll = _scrollController.position.maxScrollExtent;
      await Future.delayed(const Duration(milliseconds: 500));
      await _scrollController.animateTo(
        maxScroll,
        duration: _marqueeController.duration!,
        curve: Curves.linear,
      );
      await Future.delayed(const Duration(milliseconds: 500));
      _scrollController.jumpTo(0);
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  List<Map<String, Widget>> setNerUserPersonalPackage() {
    List<Map<String, Widget>> temp = [];
    temp.add({
      "Setup Profile": MzansiSetupProfileTile(
        signedInUser: widget.signedInUser,
        propicFile: widget.propicFile,
        packageSize: packageSize,
      )
    });
    return temp;
  }

  List<Map<String, Widget>> setPersonalPackagesMap() {
    List<Map<String, Widget>> temp = [];
    //=============== Mzansi Profile ===============
    temp.add({
      "Mzansi Profile": MzansiProfileTile(
        signedInUser: widget.signedInUser,
        propicFile: widget.propicFile,
        packageSize: packageSize,
      )
    });
    //=============== Mzansi Wallet ===============
    temp.add({
      "Mzansi Wallet": MihWalletTile(
        signedInUser: widget.signedInUser,
        packageSize: packageSize,
      )
    });
    //=============== Patient Profile ===============
    temp.add({
      "Patient Profile": PatientProfileTile(
        arguments: PatientViewArguments(
          widget.signedInUser,
          null,
          null,
          null,
          "personal",
        ),
        packageSize: packageSize,
      )
    });
    //=============== Mzansi AI ===============
    temp.add({
      "Mzansi AI": MzansiAiTile(
        signedInUser: widget.signedInUser,
        packageSize: packageSize,
      )
    });
    //=============== Calendar ===============
    temp.add({
      "Calendar": MzansiCalendarTile(
        arguments: CalendarArguments(
          widget.signedInUser,
          true,
          widget.business,
          widget.businessUser,
        ),
        packageSize: packageSize,
      )
    });
    //=============== Calculator ===============
    temp.add({
      "Calculator": MihCalculatorTile(
        personalSelected: widget.personalSelected,
        packageSize: packageSize,
      )
    });
    //=============== MIH Access ===============
    temp.add({
      "MIH Access": MihAccessTile(
        signedInUser: widget.signedInUser,
        packageSize: packageSize,
      )
    });
    //=============== About MIH ===============
    temp.add({"About MIH": AboutMihTile(packageSize: packageSize)});
    //=============== Dev ===============
    if (widget.isDevActive) {
      temp.add({
        "test": MihPackageTile(
          onTap: () {
            Navigator.of(context).pushNamed(
              '/package-dev',
              //arguments: widget.signedInUser,
            );
          },
          appName: "Test",
          appIcon: Icon(
            Icons.warning_amber_rounded,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
          iconSize: packageSize,
          primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        )
      });
    }
    return temp;
  }

  EdgeInsets getPadding(double width, double height) {
    if (MzanziInnovationHub.of(context)!.theme.screenType == "mobile") {
      double mobilePadding = 10;
      return EdgeInsets.only(
        left: mobilePadding,
        right: mobilePadding,
        bottom: mobilePadding,
      );
    } else {
      return EdgeInsets.only(
        left: width / 13,
        right: width / 13,
        bottom: height / 15,
      );
    }
  }

  void searchPackage() {
    if (searchController.text.isEmpty) {
      searchPackageName.value = personalPackagesMap;
    } else {
      List<Map<String, Widget>> temp = [];
      for (var item in personalPackagesMap) {
        if (item.keys.first.toLowerCase().contains(searchController.text)) {
          temp.add(item);
        }
      }
      searchPackageName.value = temp;
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.removeListener(searchPackage);
    searchController.dispose();
    _searchFocusNode.dispose();
    _marqueeController.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(searchPackage);
    if (widget.isUserNew) {
      personalPackagesMap = setNerUserPersonalPackage();
    } else {
      personalPackagesMap = setPersonalPackagesMap();
    }
    searchPackage();
    _marqueeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startMarquee());
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final double height = size.height;

    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(width, height),
    );
  }

  Widget getBody(double width, double height) {
    return MihSingleChildScroll(
      child: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) async {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            Navigator.of(context).pushNamed(
              '/mzansi-ai',
              arguments: MzansiAiArguments(
                widget.signedInUser,
                searchController.text.isEmpty ? null : searchController.text,
              ),
            );
            searchController.clear();
          }
        },
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 20),
              child: MihSearchBar(
                controller: searchController,
                hintText: "Ask Mzansi",
                prefixIcon: Icons.search,
                prefixAltIcon: MihIcons.mzansiAi,
                fillColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                hintColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                onPrefixIconTap: () {
                  Navigator.of(context).pushNamed(
                    '/mzansi-ai',
                    arguments: MzansiAiArguments(
                      widget.signedInUser,
                      searchController.text.isEmpty
                          ? null
                          : searchController.text,
                    ),
                  );
                  searchController.clear();
                },
                searchFocusNode: _searchFocusNode,
              ),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: searchPackageName,
              builder: (context, value, child) {
                List<Widget> filteredPackages = value
                    .where((package) => package.keys.first
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                    .map((package) => package.values.first)
                    .toList();
                if (filteredPackages.isNotEmpty) {
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: getPadding(width, height),
                    // shrinkWrap: true,
                    itemCount: filteredPackages.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: packageSize,
                      crossAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      return filteredPackages[index];
                      // return personalPackages[index];
                    },
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        MihIcons.mzansiAi,
                        size: 165,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Mzansi AI is here to help you!",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
