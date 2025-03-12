import 'dart:convert';

import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:Mzansi_Innovation_Hub/mih_env/env.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business_employee.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_profile/business_profile/builders/build_employee_list.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihMyBusinessTeam extends StatefulWidget {
  final BusinessArguments arguments;
  const MihMyBusinessTeam({
    super.key,
    required this.arguments,
  });

  @override
  State<MihMyBusinessTeam> createState() => _MihMyBusinessTeamState();
}

class _MihMyBusinessTeamState extends State<MihMyBusinessTeam> {
  late Future<List<BusinessEmployee>> employeeList;

  String errorCode = "";
  String errorBody = "";

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

  @override
  void initState() {
    super.initState();
    employeeList = fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
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
}
