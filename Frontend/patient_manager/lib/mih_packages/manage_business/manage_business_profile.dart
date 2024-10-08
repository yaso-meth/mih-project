import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/mih_packages/manage_business/business_details.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_action.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_body.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_header.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:patient_manager/mih_packages/manage_business/builder/build_employee_list.dart';
import 'package:patient_manager/mih_packages/manage_business/builder/build_user_list.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_search_input.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:patient_manager/mih_env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_objects/arguments.dart';
import 'package:patient_manager/mih_objects/business_employee.dart';
import 'package:supertokens_flutter/http.dart' as http;

class ManageBusinessProfile extends StatefulWidget {
  final BusinessArguments arguments;
  const ManageBusinessProfile({
    super.key,
    required this.arguments,
  });

  @override
  State<ManageBusinessProfile> createState() => _ManageBusinessProfileState();
}

class _ManageBusinessProfileState extends State<ManageBusinessProfile> {
  final FocusNode _focusNode = FocusNode();
  final baseAPI = AppEnviroment.baseApiUrl;
  final TextEditingController searchController = TextEditingController();

  String userSearch = "";
  String errorCode = "";
  String errorBody = "";
  int selectionIndex = 0;

  late Future<List<BusinessEmployee>> employeeList;
  late Future<List<AppUser>> userSearchResults;

  Future<List<BusinessEmployee>> fetchEmployees() async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/business-user/employees/${widget.arguments.businessUser!.business_id}"));
    errorCode = response.statusCode.toString();
    errorBody = response.body;

    if (response.statusCode == 200) {
      //print("Here1");
      Iterable l = jsonDecode(response.body);
      //print("Here2");
      List<BusinessEmployee> patientQueue = List<BusinessEmployee>.from(
          l.map((model) => BusinessEmployee.fromJson(model)));
      //print("Here3");
      //print(patientQueue);
      return patientQueue;
    } else {
      throw Exception('failed to load employees');
    }
  }

  Future<List<AppUser>> fetchUsers(String search) async {
    //TODO
    final response = await http
        .get(Uri.parse("${AppEnviroment.baseApiUrl}/users/search/$search"));
    errorCode = response.statusCode.toString();
    errorBody = response.body;

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<AppUser> users =
          List<AppUser>.from(l.map((model) => AppUser.fromJson(model)));
      return users;
    } else {
      throw Exception('failed to load patients');
    }
  }

  Widget employeesview() {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      const Text(
        "Business Team",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
      const SizedBox(height: 10),
      FutureBuilder(
        future: employeeList,
        builder: (context, snapshot) {
          //print("patient Queue List  ${snapshot.hasData}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Mihloadingcircle();
          } else if (snapshot.connectionState == ConnectionState.done) {
            //List<BusinessEmployee> employeeListResults;
            // if (searchString == "") {
            //   patientQueueList = [];
            // } else {

            //   print(patientQueueList);
            // }

            return displayEmployeeList(snapshot.requireData);
          } else {
            return Center(
              child: Text(
                "$errorCode: Error pulling Patients Data\n${AppEnviroment.baseApiUrl}/business-user/users/${widget.arguments.businessUser!.business_id}\n$errorBody",
                style: TextStyle(
                    fontSize: 25,
                    color: MzanziInnovationHub.of(context)!.theme.errorColor()),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    ]);
  }

  Widget displayEmployeeList(List<BusinessEmployee> employeeList) {
    if (employeeList.isNotEmpty) {
      return BuildEmployeeList(
        employees: employeeList,
        arguments: widget.arguments,
      );
    }
    return Center(
      child: Text(
        "",
        style: TextStyle(
            fontSize: 25,
            color: MzanziInnovationHub.of(context)!.theme.messageTextColor()),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget displayUserList(List<AppUser> userList) {
    if (userList.isNotEmpty) {
      return BuildUserList(
        users: userList,
        arguments: widget.arguments,
      );
    }
    return Center(
      child: Text(
        "Enter Username or Email to search",
        style: TextStyle(
            fontSize: 25,
            color: MzanziInnovationHub.of(context)!.theme.messageTextColor()),
        textAlign: TextAlign.center,
      ),
    );
  }

  void submitUserForm() {
    if (searchController.text != "") {
      setState(() {
        userSearch = searchController.text;
        userSearchResults = fetchUsers(userSearch);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    }
  }

  Widget userSearchView() {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) async {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          submitUserForm();
        }
      },
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        const Text(
          "User Search",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        //spacer
        Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),

        const SizedBox(height: 10),
        MIHSearchField(
          controller: searchController,
          hintText: "Username or Email Search",
          required: true,
          editable: true,
          onTap: () {
            submitUserForm();
          },
        ),
        //spacer
        const SizedBox(height: 10),
        FutureBuilder(
          future: userSearchResults,
          builder: (context, snapshot) {
            //print("patient Liust  ${snapshot.data}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Mihloadingcircle();
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<AppUser> patientsList;
              if (userSearch == "") {
                patientsList = [];
              } else {
                patientsList = snapshot.data!;
                //print(patientsList);
              }

              return displayUserList(patientsList);
            } else {
              return Center(
                child: Text(
                  "$errorCode: Error pulling Patients Data\n/patients/search/$userSearch\n$errorBody",
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

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void successPopUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MIHSuccessMessage(
          successType: "Success",
          successMessage: message,
        );
      },
    );
  }

  void emailError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Email");
      },
    );
  }

  Widget showSelection(int selectionIndex) {
    if (selectionIndex == 0) {
      return BusinessDetails(arguments: widget.arguments);
    } else if (selectionIndex == 1) {
      return employeesview();
    } else {
      return userSearchView();
    }
  }

  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();

        Navigator.of(context).popAndPushNamed(
          '/',
        );
      },
    );
  }

  MIHHeader getHeader() {
    bool isFullAccess = false;
    if (widget.arguments.businessUser!.access == "Full") {
      isFullAccess = true;
    }
    return MIHHeader(
      headerAlignment: MainAxisAlignment.end,
      headerItems: [
        IconButton(
          onPressed: () {
            setState(() {
              selectionIndex = 0;
            });
          },
          icon: const Icon(
            Icons.business,
            size: 35,
          ),
        ),
        Visibility(
          visible: isFullAccess,
          child: IconButton(
            onPressed: () {
              setState(() {
                selectionIndex = 1;
              });
            },
            icon: const Icon(
              Icons.people_outline,
              size: 35,
            ),
          ),
        ),
        Visibility(
          visible: isFullAccess,
          child: IconButton(
            onPressed: () {
              setState(() {
                selectionIndex = 2;
              });
            },
            icon: const Icon(
              Icons.add,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  MIHBody getBody() {
    return MIHBody(
      borderOn: true,
      bodyItems: [
        showSelection(selectionIndex),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    userSearchResults = fetchUsers("abc");
    employeeList = fetchEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      secondaryActionButton: null,
      header: getHeader(),
      body: getBody(),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
    // return Scaffold(
    //   // appBar: const MIHAppBar(
    //   //   barTitle: "Business Profile",
    //   //   propicFile: null,
    //   // ),
    //   //drawer: MIHAppDrawer(signedInUser: widget.arguments.signedInUser),
    //   body: SafeArea(
    //     child: Stack(
    //       children: [
    //         SingleChildScrollView(
    //           padding: const EdgeInsets.all(15),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             mainAxisSize: MainAxisSize.max,
    //             children: [
    //               //const SizedBox(height: 20),
    //               SizedBox(
    //                 width: screenWidth,
    //                 child: Row(
    //                   mainAxisSize: MainAxisSize.min,
    //                   crossAxisAlignment: CrossAxisAlignment.end,
    //                   mainAxisAlignment: MainAxisAlignment.end,
    //                   children: [
    //                     IconButton(
    //                       onPressed: () {
    //                         setState(() {
    //                           selectionIndex = 0;
    //                         });
    //                       },
    //                       icon: const Icon(
    //                         Icons.people_outline,
    //                         size: 35,
    //                       ),
    //                     ),
    //                     IconButton(
    //                       onPressed: () {
    //                         setState(() {
    //                           selectionIndex = 1;
    //                         });
    //                       },
    //                       icon: const Icon(
    //                         Icons.add,
    //                         size: 35,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               showSelection(selectionIndex, screenWidth, screenHeight),
    //             ],
    //           ),
    //         ),
    //         Positioned(
    //           top: 10,
    //           left: 5,
    //           width: 50,
    //           height: 50,
    //           child: IconButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             icon: const Icon(Icons.arrow_back),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
