import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_manager/list_builders/build_my_patient_list_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPatientList extends StatefulWidget {
  const MyPatientList({
    super.key,
  });

  @override
  State<MyPatientList> createState() => _MyPatientListState();
}

class _MyPatientListState extends State<MyPatientList> {
  TextEditingController _myPatientSearchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool hasSearchedBefore = false;
  String _myPatientIdSearchString = "";
  String baseUrl = AppEnviroment.baseApiUrl;

  final FocusNode _focusNode = FocusNode();

  Widget myPatientListTool(MzansiProfileProvider profileProvider,
      PatientManagerProvider patientManagerProvider, double width) {
    return MihSingleChildScroll(
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: MihSearchBar(
            controller: _myPatientSearchController,
            hintText: "Search Patient ID",
            prefixIcon: Icons.search,
            fillColor: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            hintColor: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            onPrefixIconTap: () {
              setState(() async {
                _myPatientIdSearchString = _myPatientSearchController.text;
                await MihPatientServices().getPatientAccessListOfBusiness(
                    patientManagerProvider,
                    profileProvider.business!.business_id);
              });
            },
            onClearIconTap: () {
              setState(() {
                _myPatientSearchController.clear();
                _myPatientIdSearchString = "";
              });
              getMyPatientList(profileProvider, patientManagerProvider);
            },
            searchFocusNode: _searchFocusNode,
          ),
        ),
        //spacer
        const SizedBox(height: 10),
        displayMyPatientList(patientManagerProvider),
      ]),
    );
  }

  Widget displayMyPatientList(PatientManagerProvider patientManagerProvider) {
    if (patientManagerProvider.myPaitentList!.isNotEmpty) {
      return BuildMyPatientListList();
    }
    if (hasSearchedBefore && _myPatientIdSearchString.isNotEmpty) {
      return Column(
        children: [
          const SizedBox(height: 50),
          Icon(
            MihIcons.iDontKnow,
            size: 165,
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          const SizedBox(height: 10),
          Text(
            "Let's try refining your search",
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Icon(
              MihIcons.patientProfile,
              size: 165,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            const SizedBox(height: 10),
            Text(
              "You dont have access to any Patients Profile",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                  children: [
                    TextSpan(text: "Press "),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.search,
                        size: 20,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                    TextSpan(
                        text:
                            " to use Patient Search to request access to their profile."),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    // return Padding(
    //   padding: const EdgeInsets.only(top: 35.0),
    //   child: Center(
    //     child: Text(
    //       "No Patients matching search",
    //       style: TextStyle(
    //           fontSize: 25,
    //           color: MihColors.getGreyColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark")),
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    // );
  }

  List<PatientAccess> filterAccessResults(
      List<PatientAccess> patAccList, String query) {
    List<PatientAccess> templist = [];
    for (var item in patAccList) {
      if (item.id_no.contains(query)) {
        templist.add(item);
      }
    }
    return templist;
  }

  Future<void> getMyPatientList(MzansiProfileProvider profileProvider,
      PatientManagerProvider patientManagerProvider) async {
    await MihPatientServices().getPatientAccessListOfBusiness(
        patientManagerProvider, profileProvider.business!.business_id);
    setState(() {
      hasSearchedBefore = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _myPatientSearchController.dispose();
    _searchFocusNode.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    return Consumer2<MzansiProfileProvider, PatientManagerProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        return MihPackageToolBody(
          borderOn: false,
          innerHorizontalPadding: 10,
          bodyItem:
              myPatientListTool(profileProvider, patientManagerProvider, width),
        );
      },
    );
  }
}
