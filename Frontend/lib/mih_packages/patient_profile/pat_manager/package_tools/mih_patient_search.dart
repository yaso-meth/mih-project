import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_service_calls.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_manager/list_builders/build_mih_patient_search_list.dart';
import 'package:flutter/material.dart';

class MihPatientSearch extends StatefulWidget {
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final bool personalSelected;

  const MihPatientSearch({
    super.key,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.personalSelected,
  });

  @override
  State<MihPatientSearch> createState() => _MihPatientSearchState();
}

class _MihPatientSearchState extends State<MihPatientSearch> {
  TextEditingController _mihPatientSearchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  String _mihPatientSearchString = "";
  String baseUrl = AppEnviroment.baseApiUrl;
  late Future<List<Patient>> _mihPatientSearchResults;

  Widget getPatientSearch(double width) {
    return MihSingleChildScroll(
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: MihSearchBar(
            controller: _mihPatientSearchController,
            hintText: "Search Patient ID/ Aid No.",
            prefixIcon: Icons.search,
            fillColor: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
            hintColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
            onPrefixIconTap: () {
              submitPatientSearch();
            },
            onClearIconTap: () {
              setState(() {
                _mihPatientSearchController.clear();
                _mihPatientSearchString = "";
              });
              submitPatientSearch();
              //To-Do: Implement the search function
              // print("To-Do: Implement the search function");
            },
            searchFocusNode: _searchFocusNode,
          ),
        ),
        //spacer
        const SizedBox(height: 10),
        FutureBuilder(
          future: _mihPatientSearchResults,
          builder: (context, snapshot) {
            //print("patient Liust  ${snapshot.data}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Mihloadingcircle();
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<Patient> patientsList;
              if (_mihPatientSearchString == "") {
                patientsList = [];
              } else {
                patientsList = filterSearchResults(
                    snapshot.data!, _mihPatientSearchString);
                //print(patientsList);
              }
              return displayPatientList(patientsList, _mihPatientSearchString);
            } else {
              return Center(
                child: Text(
                  "Error pulling Patients Data\n$baseUrl/patients/search/$_mihPatientSearchString",
                  style: TextStyle(
                      fontSize: 25,
                      color:
                          MzansiInnovationHub.of(context)!.theme.errorColor()),
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ]),
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

  Widget displayPatientList(List<Patient> patientsList, String searchString) {
    if (patientsList.isNotEmpty) {
      return BuildMihPatientSearchList(
        patients: patientsList,
        signedInUser: widget.signedInUser,
        business: widget.business,
        businessUser: widget.businessUser,
        personalSelected: widget.personalSelected,
      );
    } else if (patientsList.isEmpty && searchString != "") {
      return Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Center(
          child: Text(
            "No ID or Medical Aid No. matches a Patient",
            style: TextStyle(
                fontSize: 25,
                color:
                    MzansiInnovationHub.of(context)!.theme.messageTextColor()),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Center(
          child: Text(
            "Enter ID or Medical Aid No. of Patient",
            style: TextStyle(
                fontSize: 25,
                color:
                    MzansiInnovationHub.of(context)!.theme.messageTextColor()),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void submitPatientSearch() {
    if (_mihPatientSearchController.text != "") {
      setState(() {
        _mihPatientSearchString = _mihPatientSearchController.text;
        _mihPatientSearchResults =
            MIHApiCalls.fetchPatients(_mihPatientSearchString);
      });
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
    _mihPatientSearchResults = MIHApiCalls.fetchPatients("abc");
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
