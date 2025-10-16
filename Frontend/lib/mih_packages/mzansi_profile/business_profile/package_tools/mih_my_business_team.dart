import 'dart:convert';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_employee.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/builders/build_employee_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihMyBusinessTeam extends StatefulWidget {
  const MihMyBusinessTeam({
    super.key,
  });

  @override
  State<MihMyBusinessTeam> createState() => _MihMyBusinessTeamState();
}

class _MihMyBusinessTeamState extends State<MihMyBusinessTeam> {
  String errorCode = "";
  String errorBody = "";

  // Future<void> fetchEmployees(
  //     MzansiProfileProvider mzansiProfileProvider) async {
  //   //print("Patien manager page: $endpoint");
  //   final response = await http.get(Uri.parse(
  //       "${AppEnviroment.baseApiUrl}/business-user/employees/${mzansiProfileProvider.businessUser!.business_id}"));
  //   errorCode = response.statusCode.toString();
  //   errorBody = response.body;
  //   if (response.statusCode == 200) {
  //     //print("Here1");
  //     Iterable l = jsonDecode(response.body);
  //     //print("Here2");
  //     List<BusinessEmployee> employeeList = List<BusinessEmployee>.from(
  //         l.map((model) => BusinessEmployee.fromJson(model)));
  //     mzansiProfileProvider.setEmployeeList(employeeList: employeeList);
  //     //print("Here3");
  //     //print(patientQueue);
  //     // return patientQueue;
  //   } else {
  //     throw Exception('failed to load employees');
  //   }
  // }

  Widget displayEmployeeList(List<BusinessEmployee> employeeList) {
    if (employeeList.isNotEmpty) {
      return BuildEmployeeList(
        employees: employeeList,
      );
    }
    return Center(
      child: Text(
        "",
        style: TextStyle(
            fontSize: 25,
            color: MihColors.getGreyColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark")),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // fetchEmployees(context.read<MzansiProfileProvider>()).catchError((e) {
    //   // Handle the error thrown in fetchEmployees
    //   print('Error fetching employees: $e');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        if (mzansiProfileProvider.employeeList == null) {
          return Center(
            child: Mihloadingcircle(),
          );
        }
        return MihSingleChildScroll(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            displayEmployeeList(mzansiProfileProvider.employeeList!),
          ]),
        );
      },
    );
  }
}
