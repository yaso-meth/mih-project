import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_search_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/about_mih/package_tile/about_mih_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/access_review/package_tile/mih_access_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calculator/package_tiles/mih_calculator_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calendar/package_tiles/mzansi_calendar_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_ai/package_tiles/mzansi_ai_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_profile/personal_profile/package_tiles/mzansi_profile_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_profile/personal_profile/package_tiles/mzansi_setup_profile_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_wallet/package_tiles/mih_wallet_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_profile/package_tiles/patient_profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MihPersonalHome extends StatefulWidget {
  final AppUser signedInUser;
  final bool personalSelected;
  final Business? business;
  final BusinessUser? businessUser;
  final ImageProvider<Object>? propicFile;
  final bool isUserNew;

  const MihPersonalHome({
    super.key,
    required this.signedInUser,
    required this.personalSelected,
    required this.business,
    required this.businessUser,
    required this.propicFile,
    required this.isUserNew,
  });

  @override
  State<MihPersonalHome> createState() => _MihPersonalHomeState();
}

class _MihPersonalHomeState extends State<MihPersonalHome> {
  final TextEditingController searchController = TextEditingController();
  late List<Map<String, Widget>> personalPackagesMap;
  final ValueNotifier<List<Map<String, Widget>>> searchPackageName =
      ValueNotifier([]);
  double packageSize = 200;

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
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final double height = size.height;

    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(width, height),
    );
  }

  Widget getBody(double width, double height) {
    return MihSingleChildScroll(
      child: Column(
        children: [
          const Text(
            "Personal Home",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
                    onTap: () {},
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
                ),
                itemBuilder: (context, index) {
                  return filteredPackages[index];
                  // return personalPackages[index];
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
