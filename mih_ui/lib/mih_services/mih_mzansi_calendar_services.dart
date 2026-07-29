import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihMzansiCalendarApis {
  final baseAPI = AppEnviroment.baseApiUrl;

  static Future<List<Appointment>> getPersonalAppointmentsV2(
    String app_id,
    String date,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/appointments/personal/$app_id?date=$date"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Appointment> personalAppointments =
          List<Appointment>.from(l.map((model) => Appointment.fromJson(model)));
      return personalAppointments;
    } else {
      throw Exception('failed to fatch personal appointments');
    }
  }

  static Future<List<Appointment>> getBusinessAppointmentsV2(
    String business_id,
    String date,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/appointments/business/$business_id?date=$date"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Appointment> businessAppointments =
          List<Appointment>.from(l.map((model) => Appointment.fromJson(model)));
      return businessAppointments;
    } else {
      throw Exception('failed to fatch business appointments');
    }
  }

  static Future<int?> deleteAppointment(
    Appointment deleteAppointment,
  ) async {
    try {
      var response = await http.delete(
        Uri.parse("${AppEnviroment.baseApiUrl}/appointment/delete/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{
          "idappointments": deleteAppointment.idappointments
        }),
      );
      return response.statusCode;
    } catch (error) {
      return null;
    }
  }

  static Future<int?> addAppointment(
    Appointment newAppointment,
  ) async {
    try {
      var response = await http.post(
        Uri.parse("${AppEnviroment.baseApiUrl}/appointment/insert/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{
          "app_id": newAppointment.app_id,
          "business_id": newAppointment.business_id,
          "title": newAppointment.title,
          "description": newAppointment.description,
          "date": newAppointment.date_time.split(' ')[0],
          "time": newAppointment.date_time.split(' ')[1],
        }),
      );
      return response.statusCode;
    } catch (error) {
      return null;
    }
  }

  /// This function is used to add an appointment to users mzansi Calendar.
  ///
  /// Patameters:-
  /// AppUser signedInUser,
  /// String app_id,
  /// String title,
  /// String description,
  /// String date,
  /// String time,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS SUCCESS pop up)
  static Future<int> addPatientAppointment(
    AppUser signedInUser,
    bool personalSelected,
    String patientAppId,
    String businessId,
    String title,
    String description,
    String date,
    String time,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/appointment/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": patientAppId,
        "business_id": businessId,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
      }),
    );
    context.pop();
    return response.statusCode;
  }

  /// This function is used to update an appointment to users mzansi Calendar.
  ///
  /// Patameters:-
  /// AppUser signedInUser,
  /// String app_id,
  /// int idappointments,
  /// String title,
  /// String description,
  /// String date,
  /// String time,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS SUCCESS pop up)
  static Future<int> updatePersonalAppointment(
    AppUser signedInUser,
    Business? business,
    BusinessUser? businessUser,
    int idappointments,
    String title,
    String description,
    String date,
    String time,
    MihCalendarProvider mihCalendarProvider,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/appointment/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "idappointments": idappointments,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
      }),
    );
    context.pop();
    if (response.statusCode == 200) {
      mihCalendarProvider.editPersonalAppointment(
        updatedAppointment: Appointment(
          idappointments: idappointments,
          app_id: signedInUser.app_id,
          business_id: "",
          date_time: "$date $time",
          title: title,
          description: description,
        ),
      );
    }
    return response.statusCode;
  }

  static Future<int?> updateAppointment(
    Appointment updatedAppointment,
  ) async {
    try {
      var response = await http.put(
        Uri.parse("${AppEnviroment.baseApiUrl}/appointment/update/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{
          "idappointments": updatedAppointment.idappointments,
          "title": updatedAppointment.title,
          "description": updatedAppointment.description,
          "date": updatedAppointment.date_time.split(' ')[0],
          "time": updatedAppointment.date_time.split(' ')[1],
        }),
      );
      return response.statusCode;
    } catch (error) {
      return null;
    }
  }

  /// This function is used to update an appointment to users mzansi Calendar.
  ///
  /// Patameters:-
  /// AppUser signedInUser,
  /// String app_id,
  /// int idappointments,
  /// String title,
  /// String description,
  /// String date,
  /// String time,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS SUCCESS pop up)
  static Future<int> updateBusinessAppointment(
    AppUser signedInUser,
    Business? business,
    BusinessUser? businessUser,
    int idappointments,
    String title,
    String description,
    String date,
    String time,
    MihCalendarProvider mihCalendarProvider,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/appointment/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "idappointments": idappointments,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
      }),
    );
    context.pop();
    if (response.statusCode == 200) {
      mihCalendarProvider.editBusinessAppointment(
        updatedAppointment: Appointment(
          idappointments: idappointments,
          app_id: "",
          business_id: business!.business_id,
          date_time: "$date $time",
          title: title,
          description: description,
        ),
      );
    }
    return response.statusCode;
    // if (response.statusCode == 200) {
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    //   String message =
    //       "Your appointment \"$title\" has been updates to the $date $title.";

    //   Navigator.pop(context);
    //   Navigator.of(context).pushNamed(
    //     '/calendar',
    //     arguments: CalendarArguments(
    //       signedInUser,
    //       false,
    //       business,
    //       businessUser,
    //     ),
    //   );
    //   successPopUp(message, context);
    // } else {
    //   Navigator.pop(context);
    //   internetConnectionPopUp(context);
    // }
  }

  /// This function is used to update an appointment to users mzansi Calendar.
  ///
  /// Patameters:-
  /// AppUser signedInUser,
  /// String app_id,
  /// int idappointments,
  /// String title,
  /// String description,
  /// String date,
  /// String time,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS SUCCESS pop up)
  static Future<int> updatePatientAppointment(
    AppUser signedInUser,
    Business? business,
    BusinessUser? businessUser,
    int idappointments,
    String title,
    String description,
    String date,
    String time,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/appointment/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "idappointments": idappointments,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
      }),
    );
    context.pop();
    return response.statusCode;
    // if (response.statusCode == 200) {
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    //   String message =
    //       "Your appointment \"$title\" has been updates to the $date $title.";

    //   // Navigator.pop(context);
    //   Navigator.of(context).pushNamed(
    //     '/patient-manager',
    //     arguments: PatManagerArguments(
    //       signedInUser,
    //       false,
    //       business,
    //       businessUser,
    //     ),
    //   );
    //   successPopUp(message, context);
    // } else {
    //   Navigator.pop(context);
    //   internetConnectionPopUp(context);
    // }
  }

  //================== POP UPS ==========================================================================

  static void loadingPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
  }
}
