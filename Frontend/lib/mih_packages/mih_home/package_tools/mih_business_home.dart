import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/package_tile/about_mih_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/calculator/package_tiles/mih_calculator_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/package_tiles/mzansi_calendar_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_ai/package_tiles/mzansi_ai_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/package_tiles/mzansi_directory_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tiles/mzansi_business_profile_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tiles/mzansi_setup_business_profile_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_manager/package_tiles/pat_manager_tile.dart';
import 'package:flutter/material.dart';

class MihBusinessHome extends StatefulWidget {
  final AppUser signedInUser;
  final bool personalSelected;
  final Business? business;
  final BusinessUser? businessUser;
  final bool isBusinessUserNew;
  const MihBusinessHome({
    super.key,
    required this.signedInUser,
    required this.personalSelected,
    required this.business,
    required this.businessUser,
    required this.isBusinessUserNew,
  });

  @override
  State<MihBusinessHome> createState() => _MihBusinessHomeState();
}

class _MihBusinessHomeState extends State<MihBusinessHome>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  late List<Map<String, Widget>> businessPackagesMap;
  final ValueNotifier<List<Map<String, Widget>>> searchPackageName =
      ValueNotifier([]);
  double packageSize = 200;
  // late final AnimationController _marqueeController;
  // late final ScrollController _scrollController;
  final FocusNode _searchFocusNode = FocusNode();
  final String maintenanceMsg =
      "\tHeads up! We're doing maintenance on Thur, 15 May 2025 at 10 PM (CAT). MIH may be unavailable briefly.";

  // void _startMarquee() async {
  //   while (mounted) {
  //     final double maxScroll = _scrollController.position.maxScrollExtent;
  //     await Future.delayed(const Duration(milliseconds: 500));
  //     await _scrollController.animateTo(
  //       maxScroll,
  //       duration: _marqueeController.duration!,
  //       curve: Curves.linear,
  //     );
  //     await Future.delayed(const Duration(milliseconds: 500));
  //     _scrollController.jumpTo(0);
  //     await Future.delayed(const Duration(milliseconds: 500));
  //   }
  // }

  List<Map<String, Widget>> setNewBusinessUserPackages() {
    List<Map<String, Widget>> temp = [];
    temp.add({
      "Setup Business": MzansiSetupBusinessProfileTile(
        signedInUser: widget.signedInUser,
        packageSize: packageSize,
      )
    });
    return temp;
  }

  List<Map<String, Widget>> setBusinessPackages() {
    List<Map<String, Widget>> temp = [];
    //=============== Biz Profile ===============
    temp.add({
      "Business Profile": MzansiBusinessProfileTile(
        arguments: BusinessArguments(
          widget.signedInUser,
          widget.businessUser,
          widget.business,
        ),
        packageSize: packageSize,
      )
    });
    //=============== Pat Manager ===============
    temp.add({
      "Patient Manager": PatManagerTile(
        arguments: PatManagerArguments(
          widget.signedInUser,
          false,
          widget.business,
          widget.businessUser,
        ),
        packageSize: packageSize,
      )
    });
    //=============== Calendar ===============
    temp.add({
      "Calendar": MzansiCalendarTile(
        arguments: CalendarArguments(
          widget.signedInUser,
          false,
          widget.business,
          widget.businessUser,
        ),
        packageSize: packageSize,
      )
    });
    //=============== Mzansi Directory ===============
    temp.add({
      "Mzansi Directory": MzansiDirectoryTile(
        packageSize: packageSize,
        personalSelected: false,
      )
    });
    //=============== Calculator ===============
    temp.add({
      "Calculator": MihCalculatorTile(
        personalSelected: widget.personalSelected,
        packageSize: packageSize,
      )
    });
    //=============== Mzansi AI ===============
    temp.add({
      "Mzansi AI": MzansiAiTile(
        arguments: MzansiAiArguments(
          widget.signedInUser,
          "",
          false,
        ),
        packageSize: packageSize,
      )
    });
    //=============== About MIH ===============
    temp.add({
      "About MIH": AboutMihTile(
        packageSize: packageSize,
        personalSelected: false,
      )
    });
    return temp;
  }

  EdgeInsets getPadding(double width, double height) {
    if (MzansiInnovationHub.of(context)!.theme.screenType == "mobile") {
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
      searchPackageName.value = businessPackagesMap;
    } else {
      List<Map<String, Widget>> temp = [];
      for (var item in businessPackagesMap) {
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
    // _marqueeController.dispose();
    // _scrollController.dispose();
    _searchFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(searchPackage);
    if (widget.isBusinessUserNew) {
      businessPackagesMap = setNewBusinessUserPackages();
    } else {
      businessPackagesMap = setBusinessPackages();
    }
    searchPackage();
    //Scrolling Banner message
    // _marqueeController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 12),
    // );
    // _scrollController = ScrollController();
    // WidgetsBinding.instance.addPostFrameCallback((_) => _startMarquee());
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
      child: Column(
        children: [
          // Icon(
          //   MihIcons.mihLogo,
          //   size: width / 2,
          //   color: MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          // ),
          // const SizedBox(height: 10),
          // Text(
          //   // "Welcome, ${widget.signedInUser.fname}!",
          //   "Mzansi Innovation Hub",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontSize: 30,
          //     fontWeight: FontWeight.bold,
          //     color: MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          //   ),
          // ),
          // const SizedBox(height: 20),
          Visibility(
            visible: !widget.isBusinessUserNew,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 20),
              child: MihSearchBar(
                controller: searchController,
                hintText: "Ask Mzansi",
                prefixIcon: Icons.search,
                prefixAltIcon: MihIcons.mzansiAi,
                fillColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                hintColor: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                onPrefixIconTap: () {
                  context.goNamed(
                    "mzansiAi",
                    extra: MzansiAiArguments(
                      widget.signedInUser,
                      searchController.text.isEmpty
                          ? null
                          : searchController.text,
                      false,
                    ),
                  );
                  // Navigator.of(context).pushNamed(
                  //   '/mzansi-ai',
                  //   arguments: MzansiAiArguments(
                  //     widget.signedInUser,
                  //     searchController.text.isEmpty
                  //         ? null
                  //         : searchController.text,
                  //   ),
                  // );
                  searchController.clear();
                },
                searchFocusNode: _searchFocusNode,
              ),
            ),
          ),
          const SizedBox(height: 20),
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
                  },
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Icon(
                      MihIcons.mzansiAi,
                      size: 165,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Mzansi AI is here to help you!",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
