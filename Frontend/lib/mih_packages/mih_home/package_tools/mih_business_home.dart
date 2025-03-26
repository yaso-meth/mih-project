import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_search_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/about_mih/package_tile/about_mih_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calculator/package_tiles/mih_calculator_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calendar/package_tiles/mzansi_calendar_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_ai/package_tiles/mzansi_ai_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_profile/business_profile/package_tiles/mzansi_business_profile_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_manager/package_tiles/pat_manager_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MihBusinessHome extends StatefulWidget {
  final AppUser signedInUser;
  final bool personalSelected;
  final Business? business;
  final BusinessUser? businessUser;
  const MihBusinessHome({
    super.key,
    required this.signedInUser,
    required this.personalSelected,
    required this.business,
    required this.businessUser,
  });

  @override
  State<MihBusinessHome> createState() => _MihBusinessHomeState();
}

class _MihBusinessHomeState extends State<MihBusinessHome> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  String packageSearch = "";
  late List<Widget> businessPackages;
  double packageSize = 200;

  List<Widget> setBusinessPackages() {
    List<Widget> temp = [];
    //=============== Biz Profile ===============
    temp.add(
      MzansiBusinessProfileTile(
        arguments: BusinessArguments(
          widget.signedInUser,
          widget.businessUser,
          widget.business,
        ),
        packageSize: packageSize,
      ),
    );
    //=============== Pat Manager ===============
    temp.add(
      PatManagerTile(
        arguments: PatManagerArguments(
          widget.signedInUser,
          false,
          widget.business,
          widget.businessUser,
        ),
        packageSize: packageSize,
      ),
    );
    //=============== Calendar ===============
    temp.add(
      MzansiCalendarTile(
        arguments: CalendarArguments(
          widget.signedInUser,
          false,
          widget.business,
          widget.businessUser,
        ),
        packageSize: packageSize,
      ),
    );
    //=============== Mzansi AI ===============
    temp.add(
      MzansiAiTile(
        signedInUser: widget.signedInUser,
        packageSize: packageSize,
      ),
    );
    //=============== Calculator ===============
    temp.add(
      MihCalculatorTile(
        personalSelected: widget.personalSelected,
        packageSize: packageSize,
      ),
    );
    //=============== About MIH ===============
    temp.add(
      AboutMihTile(packageSize: packageSize),
    );
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

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    businessPackages = setBusinessPackages();
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
            "Business Home",
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
                child: KeyboardListener(
                  focusNode: _focusNode,
                  autofocus: true,
                  onKeyEvent: (event) async {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.enter) {
                      setState(() {
                        packageSearch = searchController.text;
                      });
                    }
                  },
                  child: SizedBox(
                    child: MIHSearchField(
                      controller: searchController,
                      hintText: "Search Mzansi Packages",
                      required: false,
                      editable: true,
                      onTap: () {
                        setState(() {
                          packageSearch = searchController.text;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: IconButton(
                  //padding: const EdgeInsets.all(0),
                  onPressed: () {
                    setState(() {
                      packageSearch = "";
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
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: getPadding(width, height),
            // shrinkWrap: true,
            itemCount: businessPackages.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: packageSize,
            ),
            itemBuilder: (context, index) {
              return businessPackages[index];
            },
          ),
        ],
      ),
    );
  }
}
