import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_manager/list_builders/build_mih_patient_search_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MihPatientSearch extends StatefulWidget {
  const MihPatientSearch({
    super.key,
  });

  @override
  State<MihPatientSearch> createState() => _MihPatientSearchState();
}

class _MihPatientSearchState extends State<MihPatientSearch> {
  TextEditingController _mihPatientSearchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  bool hasSearchedBefore = false;
  String _mihPatientSearchString = "";
  String baseUrl = AppEnviroment.baseApiUrl;

  Widget getPatientSearch(double width) {
    return Consumer<PatientManagerProvider>(
      builder: (BuildContext context,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        return MihSingleChildScroll(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 20),
              child: MihSearchBar(
                controller: _mihPatientSearchController,
                hintText: "Search Patient ID/ Aid No.",
                prefixIcon: Icons.search,
                fillColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                hintColor: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                onPrefixIconTap: () {
                  submitPatientSearch(patientManagerProvider);
                },
                onClearIconTap: () {
                  setState(() {
                    _mihPatientSearchController.clear();
                    _mihPatientSearchString = "";
                  });
                  patientManagerProvider
                      .setPatientSearchResults(patientSearchResults: []);
                },
                searchFocusNode: _searchFocusNode,
              ),
            ),
            //spacer
            const SizedBox(height: 10),

            displayPatientList(patientManagerProvider, _mihPatientSearchString),
          ]),
        );
      },
    );
  }

  List<Patient> filterSearchResults(List<Patient> patList, String query) {
    List<Patient> templist = [];
    //print(query);
    for (var item in patList) {
      if (item.id_no.contains(_mihPatientSearchString) ||
          item.medical_aid_no.contains(_mihPatientSearchString)) {
        //print(item.medical_aid_no);
        templist.add(item);
      }
    }
    return templist;
  }

  Widget displayPatientList(
      PatientManagerProvider patientManagerProvider, String searchString) {
    if (patientManagerProvider.patientSearchResults.isNotEmpty) {
      return BuildMihPatientSearchList();
    } else if (patientManagerProvider.patientSearchResults.isEmpty &&
        searchString != "") {
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
              "Search for a Patient of Mzansi to add to your Patient List",
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
                    TextSpan(
                        text:
                            "You can search using their ID Number or Medical Aid No."),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> submitPatientSearch(
      PatientManagerProvider patientManagerProvider) async {
    if (_mihPatientSearchController.text != "") {
      setState(() {
        _mihPatientSearchString = _mihPatientSearchController.text;
        hasSearchedBefore = true;
      });
      await MihPatientServices.searchPatients(
          patientManagerProvider, _mihPatientSearchString);
    }
  }

  //Patient Access Widgets/ Functions
  List<PatientAccess> filterAccessResults(
      List<PatientAccess> patAccList, String query) {
    List<PatientAccess> templist = [];
    //print(query);
    for (var item in patAccList) {
      if (item.id_no.contains(query)) {
        //print(item.medical_aid_no);
        templist.add(item);
      }
    }
    return templist;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocusNode.dispose();
    _mihPatientSearchController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getPatientSearch(width),
    );
  }
}
