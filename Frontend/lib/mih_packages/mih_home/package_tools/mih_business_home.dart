import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_search_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/package_tile/about_mih_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/calculator/package_tiles/mih_calculator_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/package_tiles/mzansi_calendar_tile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_ai/package_tiles/mzansi_ai_tile.dart';
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
  late final AnimationController _marqueeController;
  late final ScrollController _scrollController;
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
    //=============== Mzansi AI ===============
    temp.add({
      "Mzansi AI": MzansiAiTile(
        signedInUser: widget.signedInUser,
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
    //=============== About MIH ===============
    temp.add({"About MIH": AboutMihTile(packageSize: packageSize)});
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 4,
                child: SizedBox(
                  child: MIHSearchField(
                    controller: searchController,
                    hintText: "Search MIH Packages",
                    required: false,
                    editable: true,
                    onTap: () {
                      setState(() {});
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: IconButton(
                  //padding: const EdgeInsets.all(0),
                  onPressed: () {
                    setState(() {
                      searchController.clear();
                    });
                  },
                  icon: const Icon(
                    Icons.filter_alt_off,
                    size: 30,
                  ),
                ),
              ),
            ],
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
            },
          ),
        ],
      ),
    );
  }
}
