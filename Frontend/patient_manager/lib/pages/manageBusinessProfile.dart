import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/builders/buildEmployeeList.dart';
import 'package:patient_manager/components/popUpMessages/mihLoadingCircle.dart';
import 'package:patient_manager/components/popUpMessages/mihErrorMessage.dart';
import 'package:patient_manager/components/popUpMessages/mihSuccessMessage.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/businessEmployee.dart';
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

class BusinessUserScreenArguments {}

class _ManageBusinessProfileState extends State<ManageBusinessProfile> {
  final FocusNode _focusNode = FocusNode();
  final baseAPI = AppEnviroment.baseApiUrl;
  final TextEditingController searchController = TextEditingController();

  String userSearch = "";
  String errorCode = "";
  String errorBody = "";

  late Future<List<BusinessEmployee>> employeeList;

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

  Widget employeesview(double w, double h) {
    return SizedBox(
      width: w,
      height: h - 157,
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        //const SizedBox(height: 15),
        FutureBuilder(
          future: employeeList,
          builder: (context, snapshot) {
            //print("patient Queue List  ${snapshot.hasData}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Expanded(
                child: Container(
                  height: 500,
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
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              //List<BusinessEmployee> employeeListResults;
              // if (searchString == "") {
              //   patientQueueList = [];
              // } else {

              //   print(patientQueueList);
              // }

              return Expanded(
                child: displayEmployeeList(snapshot.requireData),
              );
            } else {
              return Expanded(
                child: Container(
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
                      "$errorCode: Error pulling Patients Data\n${AppEnviroment.baseApiUrl}/business-user/users/${widget.arguments.businessUser!.business_id}\n$errorBody",
                      style: TextStyle(
                          fontSize: 25,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .errorColor()),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ]),
    );
  }

  Widget displayEmployeeList(List<BusinessEmployee> employeeList) {
    if (employeeList.isNotEmpty) {
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
        child: BuildEmployeeList(
          employees: employeeList,
          arguments: widget.arguments,
        ),
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
          "",
          style: TextStyle(
              fontSize: 25,
              color: MzanziInnovationHub.of(context)!.theme.messageTextColor()),
          textAlign: TextAlign.center,
        ),
      ),
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

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    employeeList = fetchEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: const MIHAppBar(
      //   barTitle: "Business Profile",
      //   propicFile: null,
      // ),
      //drawer: MIHAppDrawer(signedInUser: widget.arguments.signedInUser),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    "Business Team",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 20),
                  employeesview(screenWidth, screenHeight),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 5,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            )
          ],
        ),
      ),
    );
  }
}
