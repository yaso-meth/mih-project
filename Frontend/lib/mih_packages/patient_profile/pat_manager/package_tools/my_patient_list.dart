import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_api_calls.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_manager/list_builders/build_my_patient_list_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyPatientList extends StatefulWidget {
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final bool personalSelected;

  const MyPatientList({
    super.key,
    required this.signedInUser,
    this.business,
    this.businessUser,
    this.personalSelected = false,
  });

  @override
  State<MyPatientList> createState() => _MyPatientListState();
}

class _MyPatientListState extends State<MyPatientList> {
  late Future<List<PatientAccess>> _myPatientList;
  TextEditingController _myPatientSearchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _myPatientIdSearchString = "";
  String baseUrl = AppEnviroment.baseApiUrl;

  final FocusNode _focusNode = FocusNode();

  Widget myPatientListTool(double width) {
    return MihSingleChildScroll(
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: MihSearchBar(
            controller: _myPatientSearchController,
            hintText: "Search Patient ID",
            prefixIcon: Icons.search,
            fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            hintColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            onPrefixIconTap: () {
              setState(() {
                _myPatientIdSearchString = _myPatientSearchController.text;
                _myPatientList = MIHApiCalls.getPatientAccessListOfBusiness(
                    widget.business!.business_id);
              });
            },
            onClearIconTap: () {
              setState(() {
                _myPatientSearchController.clear();
                _myPatientIdSearchString = "";
              });
              getMyPatientList();
            },
            searchFocusNode: _searchFocusNode,
          ),
        ),
        //spacer
        const SizedBox(height: 10),
        FutureBuilder(
          future: _myPatientList,
          builder: (context, snapshot) {
            //print("patient Liust  ${snapshot.data}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Mihloadingcircle();
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<PatientAccess> patientsAccessList;
              if (_myPatientIdSearchString == "") {
                patientsAccessList = snapshot.data!;
              } else {
                patientsAccessList = filterAccessResults(
                    snapshot.data!, _myPatientIdSearchString);
                //print(patientsList);
              }
              return displayMyPatientList(patientsAccessList);
            } else {
              return Center(
                child: Text(
                  "Error pulling Patient Access Data\n$baseUrl/access-requests/business/patient/${widget.business!.business_id}",
                  style: TextStyle(
                      fontSize: 25,
                      color:
                          MzanziInnovationHub.of(context)!.theme.errorColor()),
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ]),
    );
  }

  Widget displayMyPatientList(List<PatientAccess> patientsAccessList) {
    if (patientsAccessList.isNotEmpty) {
      return BuildMyPatientListList(
        patientAccesses: patientsAccessList,
        signedInUser: widget.signedInUser,
        business: widget.business,
        businessUser: widget.businessUser,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: Center(
        child: Text(
          "No Patients matching search",
          style: TextStyle(
              fontSize: 25,
              color: MzanziInnovationHub.of(context)!.theme.messageTextColor()),
          textAlign: TextAlign.center,
        ),
      ),
    );
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

  void getMyPatientList() {
    setState(() {
      _myPatientList = MIHApiCalls.getPatientAccessListOfBusiness(
          widget.business!.business_id);
    });
  }

  @override
  void initState() {
    super.initState();
    _myPatientList = MIHApiCalls.getPatientAccessListOfBusiness(
        widget.business!.business_id);
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
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: myPatientListTool(width),
    );
  }
}
