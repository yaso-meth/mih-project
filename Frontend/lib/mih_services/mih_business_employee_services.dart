import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_employee.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihBusinessEmployeeServices {
  Future<int> fetchEmployees(
      MzansiProfileProvider mzansiProfileProvider, BuildContext context) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/business-user/employees/${mzansiProfileProvider.businessUser!.business_id}"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<BusinessEmployee> employeeList = List<BusinessEmployee>.from(
          l.map((model) => BusinessEmployee.fromJson(model)));
      mzansiProfileProvider.setEmployeeList(employeeList: employeeList);
    } else {
      throw Exception('failed to load employees');
    }
    return response.statusCode;
  }

  Future<int> addEmployee(
    MzansiProfileProvider provider,
    AppUser newEmployee,
    String access,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/business-user/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": provider.business!.business_id,
        "app_id": newEmployee.app_id,
        "signature": "",
        "sig_path": "",
        "title": "",
        "access": access,
      }),
    );
    if (response.statusCode == 201) {
      provider.addEmployee(
        newEmployee: BusinessEmployee(
          provider.business!.business_id,
          newEmployee.app_id,
          "",
          access,
          newEmployee.fname,
          newEmployee.lname,
          newEmployee.email,
          newEmployee.username,
        ),
      );
      provider.setBusinessIndex(2);
    }
    context.pop();
    return response.statusCode;
  }

  Future<int> updateEmployeeDetails(
      MzansiProfileProvider provider,
      BusinessEmployee employee,
      String newTitle,
      String newAccess,
      BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/business-user/employees/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": employee.business_id,
        "app_id": employee.app_id,
        "title": newTitle,
        "access": newAccess,
      }),
    );
    if (response.statusCode == 200) {
      provider.updateEmplyeeDetails(
        updatedEmployee: BusinessEmployee(
          employee.business_id,
          employee.app_id,
          newTitle,
          newAccess,
          employee.fname,
          employee.lname,
          employee.email,
          employee.username,
        ),
      );
    }
    context.pop();
    return response.statusCode;
  }

  Future<int> deleteEmployee(
    MzansiProfileProvider provider,
    BusinessEmployee employee,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var response = await http.delete(
      Uri.parse("${AppEnviroment.baseApiUrl}/business-user/employees/delete/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": employee.business_id,
        "app_id": employee.app_id,
      }),
    );
    if (response.statusCode == 200) {
      provider.deleteEmplyee(deletedEmployee: employee);
    }
    context.pop();
    return response.statusCode;
  }
}
