import 'dart:convert';

import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_env/env.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihNotificationApis {
  final baseAPI = AppEnviroment.baseApiUrl;
//================== Notifications ==========================================================================

  /// This function is used to create notification to patient for access reviews
  ///
  /// Patameters:-
  /// String app_id,
  /// String business_name,
  /// BuildContext context,
  ///
  /// Returns void. (ON SUCCESS 201 , NAVIGATE TO /patient-manager)
  static Future<void> addAccessRequestNotificationAPICall(
    String app_id,
    String business_name,
    bool personalSelected,
    BusinessArguments args,
    BuildContext context,
  ) async {
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/notifications/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": app_id,
        "notification_type": "Forever Access Request",
        "notification_message":
            "A new Forever Access Request has been sent by $business_name in order to access your Patient Profile. Please review request.",
        "action_path": "/mih-access",
      }),
    );
    if (response.statusCode == 201) {
      String message =
          "A request has been sent to the patient advising that you have requested access to their profile. Only once access has been granted will you be able to book an appointment.";
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/patient-manager',
        arguments: PatManagerArguments(
          args.signedInUser,
          personalSelected,
          args.business,
          args.businessUser,
        ),
      );
      successPopUp(message, context);
    } else {
      internetConnectionPopUp(context);
    }
  }

  /// This function is used to create notification to patient for access reviews
  ///
  /// Patameters:-
  /// String app_id,
  /// String business_name,
  /// BuildContext context,
  ///
  /// Returns void. (ON SUCCESS 201 , NAVIGATE TO /patient-manager)
  static Future<void> reapplyAccessRequestNotificationAPICall(
    String app_id,
    bool personalSelected,
    BusinessArguments args,
    BuildContext context,
  ) async {
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/notifications/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": app_id,
        "notification_type": "Re-applying for Access",
        "notification_message":
            "${args.business!.Name} is re-applying for access to your Patient Profile. Please review request.",
        "action_path": "/mih-access",
      }),
    );
    if (response.statusCode == 201) {
      String message =
          "A request has been sent to the patient advising that you have re-applied for access to their profile. Only once access has been granted will you be able to book an appointment.";
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/patient-manager',
        arguments: PatManagerArguments(
          args.signedInUser,
          personalSelected,
          args.business,
          args.businessUser,
        ),
      );
      successPopUp(message, context);
    } else {
      internetConnectionPopUp(context);
    }
  }

  /// This function is used to create notification to patient for access reviews
  ///
  /// Patameters:-
  /// String app_id,
  /// String business_name,
  /// String origDate_time,
  /// String date,
  /// String time,
  /// BusinessArguments args,
  /// BuildContext context,
  ///
  /// Returns void. (ON SUCCESS 201 , NAVIGATE TO /patient-manager)
  static Future<void> addRescheduledAppointmentNotificationAPICall(
    String app_id,
    bool personalSelected,
    String business_name,
    String origDate_time,
    String date,
    String time,
    BusinessArguments args,
    BuildContext context,
  ) async {
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/notifications/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": app_id,
        "notification_type": "Appointment Rescheduled",
        "notification_message":
            "Your appointment with $business_name for the ${origDate_time.replaceAll("T", " ").substring(0, origDate_time.length - 3)} has been rescheduled to the ${date} ${time}.",
        "action_path": "/appointments",
      }),
    );
    if (response.statusCode == 201) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/patient-manager',
        arguments: PatManagerArguments(
          args.signedInUser,
          personalSelected,
          args.business,
          args.businessUser,
        ),
      );
      String message = "The appointment has been successfully rescheduled.";

      successPopUp(message, context);
    } else {
      internetConnectionPopUp(context);
    }
  }

  /// This function is used to create notification to patient for access reviews
  ///
  /// Patameters:-
  /// String app_id,
  /// String business_name,
  /// String origDate_time,
  /// String date,
  /// String time,
  /// BusinessArguments args,
  /// BuildContext context,
  ///
  /// Returns void. (ON SUCCESS 201 , NAVIGATE TO /patient-manager)
  static Future<void> addCancelledAppointmentNotificationAPICall(
    String app_id,
    bool personalSelected,
    String date_time,
    BusinessArguments args,
    BuildContext context,
  ) async {
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/notifications/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": app_id,
        "notification_type": "Appointment Cancelled",
        "notification_message":
            "Your appointment with ${args.business!.Name} for the ${date_time.replaceAll("T", " ")} has been cancelled.",
        "action_path": "/appointments",
      }),
    );
    if (response.statusCode == 201) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/patient-manager',
        arguments: PatManagerArguments(
          args.signedInUser,
          personalSelected,
          args.business,
          args.businessUser,
        ),
      );
      String message =
          "The appointment has been cancelled successfully. This means it will no longer be visible in your waiting room and calender.";
      successPopUp(message, context);
    } else {
      internetConnectionPopUp(context);
    }
  }

  /// This function is used to create notification to patient for access reviews
  ///
  /// Patameters:-
  /// String app_id,
  /// String business_name,
  /// String origDate_time,
  /// String date,
  /// String time,
  /// BusinessArguments args,
  /// BuildContext context,
  ///
  /// Returns void. (ON SUCCESS 201 , NAVIGATE TO /patient-manager)
  static Future<void> addNewAppointmentNotificationAPICall(
    String app_id,
    bool personalSelected,
    String date,
    String time,
    BusinessArguments args,
    BuildContext context,
  ) async {
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/notifications/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": app_id,
        "notification_type": "New Appointment Booked",
        "notification_message":
            "An appointment with ${args.business!.Name} has been booked for the $date $time.",
        "action_path": "/appointments",
      }),
    );
    if (response.statusCode == 201) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/patient-manager',
        arguments: PatManagerArguments(
          args.signedInUser,
          personalSelected,
          args.business,
          args.businessUser,
        ),
      );
      String message =
          "The appointment was been created successfully. This means it will now be visible in your waiting room and calender.";
      successPopUp(message, context);
    } else {
      internetConnectionPopUp(context);
    }
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
}
