import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_calendar_provider.dart';
import 'package:supertokens_flutter/http.dart' as http;
import '../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../mih_config/mih_env.dart';

class MihMzansiCalendarApis {
  final baseAPI = AppEnviroment.baseApiUrl;

  /// This function is used to fetch a list of appointment for a personal user.
  ///
  /// Patameters:
  /// app_id,
  /// date (yyyy-mm-dd),
  ///
  /// Returns Future<List<Appointment>>.
  static Future<int> getPersonalAppointments(
    String app_id,
    String date,
    MihCalendarProvider mihCalendarProvider,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/appointments/personal/$app_id?date=$date"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Appointment> personalAppointments =
          List<Appointment>.from(l.map((model) => Appointment.fromJson(model)));
      mihCalendarProvider.setPersonalAppointments(
          appointments: personalAppointments);
      return response.statusCode;
    } else {
      throw Exception('failed to fatch personal appointments');
    }
  }

  /// This function is used to fetch a list of appointment for a personal user.
  ///
  /// Patameters:
  /// app_id,
  /// date (yyyy-mm-dd),
  ///
  /// Returns Future<List<Appointment>>.
  static Future<int> getBusinessAppointments(
    String business_id,
    bool waitingRoom,
    String date,
    MihCalendarProvider mihCalendarProvider,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/appointments/business/$business_id?date=$date"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Appointment> businessAppointments =
          List<Appointment>.from(l.map((model) => Appointment.fromJson(model)));
      mihCalendarProvider.setBusinessAppointments(
          appointments: businessAppointments);
      return response.statusCode;
    } else {
      throw Exception('failed to fatch business appointments');
    }
  }

  /// This function is used to Delete loyalty card from users mzansi Calendar.
  ///
  /// Patameters:-
  /// AppUser signedInUser,
  /// int idloyalty_cards,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS NOTIGICATIOPN ON SUCCESS)
  static Future<int> deleteAppointmentAPICall(
    AppUser signedInUser,
    bool personalSelected,
    Business? business,
    BusinessUser? businessUser,
    bool inWaitingRoom,
    int idappointments,
    MihCalendarProvider mihCalendarProvider,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http.delete(
      Uri.parse("${AppEnviroment.baseApiUrl}/appointment/delete/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{"idappointments": idappointments}),
    );
    context.pop();
    if (response.statusCode == 200) {
      if (personalSelected == true) {
        mihCalendarProvider.deletePersonalAppointment(
            appointmentId: idappointments);
        getPersonalAppointments(signedInUser.app_id,
            mihCalendarProvider.selectedDay, mihCalendarProvider);
      } else {
        mihCalendarProvider.deleteBusinessAppointment(
            appointmentId: idappointments);
        getBusinessAppointments(business!.business_id, inWaitingRoom,
            mihCalendarProvider.selectedDay, mihCalendarProvider);
      }
    }
    return response.statusCode;
    //print("Here4");
    //print(response.statusCode);
    // if (response.statusCode == 200) {
    //   Navigator.of(context).pop();
    //   Navigator.of(context).pop();
    //   Navigator.of(context).pop();
    //   if (inWaitingRoom == true && personalSelected == false) {
    //     Navigator.of(context).pushNamed(
    //       '/patient-manager',
    //       arguments: PatManagerArguments(
    //         signedInUser,
    //         false,
    //         business,
    //         businessUser,
    //       ),
    //     );
    //   } else {
    //     Navigator.of(context).pushNamed(
    //       '/calendar',
    //       arguments: CalendarArguments(
    //         signedInUser,
    //         personalSelected,
    //         business,
    //         businessUser,
    //       ),
    //     );
    //   }
    //   String message =
    //       "The appointment has been deleted successfully. This means it will no longer be visible in your Calendar.";
    //   successPopUp(message, context);
    // } else {
    //   internetConnectionPopUp(context);
    // }
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
  static Future<int> addPersonalAppointment(
    AppUser signedInUser,
    String title,
    String description,
    String date,
    String time,
    MihCalendarProvider mihCalendarProvider,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/appointment/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": signedInUser.app_id,
        "business_id": "",
        "title": title,
        "description": description,
        "date": date,
        "time": time,
      }),
    );
    context.pop();
    if (response.statusCode == 201) {
      mihCalendarProvider.addPersonalAppointment(
        newAppointment: Appointment(
          idappointments: 0,
          app_id: signedInUser.app_id,
          business_id: "",
          date_time: "$date $time",
          title: title,
          description: description,
        ),
      );
    }
    return response.statusCode;
    // if (response.statusCode == 201) {
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    //   String message =
    //       "Your appointment \"$title\" for the $date $title has been deleted.";

    //   // Navigator.pop(context);
    //   Navigator.of(context).pushNamed(
    //     '/calendar',
    //     arguments: CalendarArguments(
    //       signedInUser,
    //       true,
    //       null,
    //       null,
    //     ),
    //   );
    //   successPopUp(message, context);
    // } else {
    //   Navigator.pop(context);
    //   internetConnectionPopUp(context);
    // }
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
  static Future<int> addBusinessAppointment(
    AppUser signedInUser,
    Business business,
    BusinessUser businessUser,
    bool inWaitingRoom,
    String title,
    String description,
    String date,
    String time,
    MihCalendarProvider mihCalendarProvider,
    BuildContext context,
  ) async {
    loadingPopUp(context);
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/appointment/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": "",
        "business_id": business.business_id,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
      }),
    );
    context.pop();
    if (response.statusCode == 201) {
      mihCalendarProvider.addBusinessAppointment(
        newAppointment: Appointment(
          idappointments: 0,
          app_id: "",
          business_id: business.business_id,
          date_time: "$date $time",
          title: title,
          description: description,
        ),
      );
    }
    return response.statusCode;
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
    BusinessArguments businessArgs,
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
        "business_id": businessArgs.business?.business_id,
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
    //       true,
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

  static void internetConnectionPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(
          errorType: "Internet Connection",
        );
      },
    );
  }

  static void successPopUp(String message, BuildContext context) {
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

  static void loadingPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
  }
}
