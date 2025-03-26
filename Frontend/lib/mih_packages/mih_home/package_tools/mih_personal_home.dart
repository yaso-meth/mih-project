import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_search_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih-app_tool_body.dart';
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

  const MihPersonalHome({
    super.key,
    required this.signedInUser,
    required this.personalSelected,
    required this.business,
    required this.businessUser,
    required this.propicFile,
  });

  @override
  State<MihPersonalHome> createState() => _MihPersonalHomeState();
}

class _MihPersonalHomeState extends State<MihPersonalHome> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  String packageSearch = "";
  late List<Widget> personalPackages;
  double packageSize = 100;

  List<Widget> setPersonalPackages() {
    List<Widget> temp = [];
    //=============== Mzansi Profile ===============
    temp.add(
      MzansiProfileTile(
        signedInUser: widget.signedInUser,
        propicFile: widget.propicFile,
        packageSize: packageSize,
      ),
    );
    //=============== Mzansi Wallet ===============
    temp.add(
      MihWalletTile(
        signedInUser: widget.signedInUser,
        packageSize: packageSize,
      ),
    );
    //=============== Patient Profile ===============
    temp.add(
      PatientProfileTile(
        arguments: PatientViewArguments(
          widget.signedInUser,
          null,
          null,
          null,
          "personal",
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
    //=============== Calendar ===============
    temp.add(
      MzansiCalendarTile(
        arguments: CalendarArguments(
          widget.signedInUser,
          widget.personalSelected,
          widget.business,
          widget.businessUser,
        ),
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
    //=============== MIH Access ===============
    temp.add(
      MihAccessTile(
        signedInUser: widget.signedInUser,
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
    personalPackages = setPersonalPackages();
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
            itemCount: personalPackages.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: packageSize,
            ),
            itemBuilder: (context, index) {
              return personalPackages[index];
            },
          ),
        ],
      ),
    );
  }
}
