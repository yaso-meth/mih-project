import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import '../../../mih_services/mih_service_calls.dart';
import '../../../mih_components/mih_layout/mih_action.dart';
import '../../../mih_components/mih_layout/mih_header.dart';
import '../../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../../mih_config/mih_env.dart';
import '../../../mih_components/mih_objects/app_user.dart';
import '../../../mih_components/mih_objects/patient_access.dart';
import '../builder/build_business_access_list.dart';

class MihAccessRequest extends StatefulWidget {
  final AppUser signedInUser;

  const MihAccessRequest({
    super.key,
    required this.signedInUser,
  });

  @override
  State<MihAccessRequest> createState() => _MihAccessRequestState();
}

class _MihAccessRequestState extends State<MihAccessRequest> {
  TextEditingController filterController = TextEditingController();

  String baseUrl = AppEnviroment.baseApiUrl;

  String errorCode = "";
  String errorBody = "";
  String datefilter = "";
  String accessFilter = "";
  bool forceRefresh = false;
  late String selectedDropdown;

  late Future<List<PatientAccess>> accessList;

  // Future<List<AccessRequest>> fetchAccessRequests() async {
  //   //print("Patien manager page: $endpoint");
  //   final response = await http.get(
  //       Uri.parse("$baseUrl/access-requests/${widget.signedInUser.app_id}"));
  //   // print("Here");
  //   // print("Body: ${response.body}");
  //   // print("Code: ${response.statusCode}");
  //   errorCode = response.statusCode.toString();
  //   errorBody = response.body;

  //   if (response.statusCode == 200) {
  //     //print("Here1");
  //     Iterable l = jsonDecode(response.body);
  //     //print("Here2");
  //     List<AccessRequest> patientQueue = List<AccessRequest>.from(
  //         l.map((model) => AccessRequest.fromJson(model)));
  //     //print("Here3");
  //     //print(patientQueue);
  //     return patientQueue;
  //   } else {
  //     throw Exception('failed to load patients');
  //   }
  // }

  List<PatientAccess> filterSearchResults(List<PatientAccess> accessList) {
    List<PatientAccess> templist = [];

    for (var item in accessList) {
      if (filterController.text == "All") {
        templist.add(item);
      } else {
        if (item.status.contains(filterController.text.toLowerCase())) {
          templist.add(item);
        }
      }
    }
    return templist;
  }

  void refreshList() {
    if (forceRefresh == true) {
      setState(() {
        accessList = MIHApiCalls.getBusinessAccessListOfPatient(
            widget.signedInUser.app_id);
        forceRefresh = false;
      });
    } else if (selectedDropdown != filterController.text) {
      setState(() {
        accessList = MIHApiCalls.getBusinessAccessListOfPatient(
            widget.signedInUser.app_id);
        selectedDropdown = filterController.text;
      });
    }
    // setState(() {
    //   accessRequestResults = fetchAccessRequests();
    // });
  }

  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();

        Navigator.of(context).popAndPushNamed(
          '/',
          arguments: AuthArguments(true, false),
        );
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "Forever Access List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  Widget getBody() {
    return MihSingleChildScroll(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: MihDropdownField(
                  controller: filterController,
                  hintText: "Access Type",
                  dropdownOptions: const [
                    "All",
                    "Approved",
                    "Pending",
                    "Declined",
                    "Cancelled",
                  ],
                  requiredText: true,
                  editable: true,
                  enableSearch: true,
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
              ),
              IconButton(
                iconSize: 35,
                onPressed: () {
                  setState(() {
                    forceRefresh = true;
                  });
                  refreshList();
                },
                icon: const Icon(
                  Icons.refresh,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FutureBuilder(
            future: accessList,
            builder: (context, snapshot) {
              //print("patient Queue List  ${snapshot.hasData}");
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Mihloadingcircle();
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<PatientAccess> accessRequestList;
                accessRequestList = filterSearchResults(snapshot.requireData);
                if (accessRequestList.isNotEmpty) {
                  return BuildBusinessAccessList(
                    signedInUser: widget.signedInUser,
                    patientAccessList: accessRequestList,
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
                          MihIcons.accessControl,
                          size: 165,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "No access has been granted to your MIH Profile",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // Center(
                        //   child: RichText(
                        //     textAlign: TextAlign.center,
                        //     text: TextSpan(
                        //       style: TextStyle(
                        //         fontSize: 20,
                        //         fontWeight: FontWeight.normal,
                        //         color: MzansiInnovationHub.of(context)!
                        //             .theme
                        //             .secondaryColor(),
                        //       ),
                        //       children: [
                        //         TextSpan(text: "Press "),
                        //         WidgetSpan(
                        //           alignment: PlaceholderAlignment.middle,
                        //           child: Icon(
                        //             Icons.menu,
                        //             size: 20,
                        //             color: MzansiInnovationHub.of(context)!
                        //                 .theme
                        //                 .secondaryColor(),
                        //           ),
                        //         ),
                        //         TextSpan(
                        //             text: " to add your first loyalty card."),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  );
                  // return Center(
                  //   child: Text(
                  //     "No Request have been made.",
                  //     style: TextStyle(
                  //         fontSize: 25,
                  //         color: MzansiInnovationHub.of(context)!
                  //             .theme
                  //             .messageTextColor()),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // );
                }

                // return Expanded(
                //   child: displayAccessRequestList(accessRequestList),
                // );
              } else {
                return Center(
                  child: Text(
                    "$errorCode: Error pulling Patients Data\n$baseUrl/queue/patients/\n$errorBody",
                    style: TextStyle(
                        fontSize: 25,
                        color: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark")),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    selectedDropdown = "All";
    filterController.text = "All";
    filterController.addListener(refreshList);
    setState(() {
      accessList = MIHApiCalls.getBusinessAccessListOfPatient(
          widget.signedInUser.app_id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(),
    );
  }
}
