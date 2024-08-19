import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/builders/buildAccessRequestList.dart';
import 'package:patient_manager/components/inputsAndButtons/mihDropdownInput.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/mihLoadingCircle.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/accessRequest.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:supertokens_flutter/http.dart' as http;

class PatientAccessRequest extends StatefulWidget {
  final AppUser signedInUser;

  const PatientAccessRequest({
    super.key,
    required this.signedInUser,
  });

  @override
  State<PatientAccessRequest> createState() => _PatientAccessRequestState();
}

class _PatientAccessRequestState extends State<PatientAccessRequest> {
  TextEditingController filterController = TextEditingController();

  String baseUrl = AppEnviroment.baseApiUrl;

  String errorCode = "";
  String errorBody = "";
  String datefilter = "";
  String accessFilter = "";
  bool forceRefresh = false;
  late String selectedDropdown;

  late Future<List<AccessRequest>> accessRequestResults;

  Future<List<AccessRequest>> fetchAccessRequests() async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(
        Uri.parse("$baseUrl/access-requests/${widget.signedInUser.app_id}"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    errorCode = response.statusCode.toString();
    errorBody = response.body;

    if (response.statusCode == 200) {
      //print("Here1");
      Iterable l = jsonDecode(response.body);
      //print("Here2");
      List<AccessRequest> patientQueue = List<AccessRequest>.from(
          l.map((model) => AccessRequest.fromJson(model)));
      //print("Here3");
      //print(patientQueue);
      return patientQueue;
    } else {
      throw Exception('failed to load patients');
    }
  }

  List<AccessRequest> filterSearchResults(List<AccessRequest> accessList) {
    List<AccessRequest> templist = [];

    for (var item in accessList) {
      if (filterController.text == "All") {
        if (item.date_time.contains(datefilter)) {
          templist.add(item);
        }
      } else {
        if (item.date_time.contains(datefilter) &&
            item.access.contains(filterController.text.toLowerCase())) {
          templist.add(item);
        }
      }
    }
    return templist;
  }

  Widget displayAccessRequestList(List<AccessRequest> accessRequestList) {
    if (accessRequestList.isNotEmpty) {
      return Container(
        height: 500,
        decoration: BoxDecoration(
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 3.0,
          ),
        ),
        child: BuildAccessRequestList(
          signedInUser: widget.signedInUser,
          accessRequests: accessRequestList,
        ),
        // BuildPatientQueueList(
        //   patientQueue: patientQueueList,
        //   signedInUser: widget.signedInUser,
        // ),
      );
    }
    return Container(
      //height: 500,
      decoration: BoxDecoration(
        color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 3.0),
      ),
      child: Center(
        child: Text(
          "No Request have been made.",
          style: TextStyle(
              fontSize: 25,
              color: MzanziInnovationHub.of(context)!.theme.messageTextColor()),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget viewAccessRequest(double w, double h) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: w,
        height: 600,
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          //const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //const SizedBox(height: 25),
              const Text(
                "Access Request",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      forceRefresh = true;
                    });
                    refreshList();
                  },
                  icon: const Icon(
                    Icons.refresh,
                  ))
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 500,
            child: MIHDropdownField(
              controller: filterController,
              hintText: "Access Types",
              dropdownOptions: const ["All", "Approved", "Pending", "Declined"],
              required: true,
              editable: true,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder(
            future: accessRequestResults,
            builder: (context, snapshot) {
              //print("patient Queue List  ${snapshot.hasData}");
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  //height: 500,
                  decoration: BoxDecoration(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        width: 3.0),
                  ),
                  child: const Mihloadingcircle(),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<AccessRequest> accessRequestList;
                // if (searchString == "") {
                //   patientQueueList = [];
                // } else {
                accessRequestList = filterSearchResults(snapshot.requireData);
                //   print(patientQueueList);
                // }

                return Expanded(
                  child: displayAccessRequestList(accessRequestList),
                );
              } else {
                return Container(
                  //height: 500,
                  decoration: BoxDecoration(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        width: 3.0),
                  ),
                  child: Center(
                    child: Text(
                      "$errorCode: Error pulling Patients Data\n$baseUrl/queue/patients/\n$errorBody",
                      style: TextStyle(
                          fontSize: 25,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .errorColor()),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
          ),
        ]),
      ),
    );
  }

  void refreshList() {
    if (forceRefresh == true) {
      setState(() {
        accessRequestResults = fetchAccessRequests();
        forceRefresh = false;
      });
    } else if (selectedDropdown != filterController.text) {
      setState(() {
        accessRequestResults = fetchAccessRequests();
        selectedDropdown = filterController.text;
      });
    }
    // setState(() {
    //   accessRequestResults = fetchAccessRequests();
    // });
  }

  @override
  void initState() {
    selectedDropdown = "All";
    filterController.text = "All";
    filterController.addListener(refreshList);
    setState(() {
      accessRequestResults = fetchAccessRequests();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const MIHAppBar(barTitle: "Access Reviews"),
      body: viewAccessRequest(screenWidth, screenHeight),
    );
  }
}
