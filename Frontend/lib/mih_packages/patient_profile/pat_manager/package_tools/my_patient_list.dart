import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_apis/mih_api_calls.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_search_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:Mzansi_Innovation_Hub/mih_env/env.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/patient_access.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_manager/list_builders/build_my_patient_list_list.dart';
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
  String _myPatientIdSearchString = "";
  String baseUrl = AppEnviroment.baseApiUrl;

  final FocusNode _focusNode = FocusNode();

  Widget myPatientListTool() {
    return MihSingleChildScroll(
      child: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) async {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            setState(() {
              _myPatientIdSearchString = _myPatientSearchController.text;
              _myPatientList = MIHApiCalls.getPatientAccessListOfBusiness(
                  widget.business!.business_id);
            });
          }
        },
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "My Patient List",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              IconButton(
                iconSize: 20,
                icon: const Icon(
                  Icons.refresh,
                ),
                onPressed: () {
                  getMyPatientList();
                },
              ),
            ],
          ),
          Divider(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
          //spacer
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 1,
                child: MIHSearchField(
                  controller: _myPatientSearchController,
                  hintText: "Patient ID Search",
                  required: false,
                  editable: true,
                  onTap: () {
                    setState(() {
                      _myPatientIdSearchString =
                          _myPatientSearchController.text;
                      _myPatientList =
                          MIHApiCalls.getPatientAccessListOfBusiness(
                              widget.business!.business_id);
                    });
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _myPatientSearchController.clear();
                      _myPatientIdSearchString = "";
                    });
                    getMyPatientList();
                  },
                  icon: const Icon(
                    Icons.filter_alt_off,
                    size: 25,
                  ))
            ],
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
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .errorColor()),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
          ),
        ]),
      ),
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
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: myPatientListTool(),
    );
  }
}
