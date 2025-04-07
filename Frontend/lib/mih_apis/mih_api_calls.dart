import 'dart:convert';

import 'package:mzansi_innovation_hub/mih_apis/mih_notification_apis.dart';
import 'package:flutter/material.dart';
// import '../mih_components/mih_pop_up_messages/mih_error_message.dart';
// import '../mih_components/mih_pop_up_messages/mih_success_message.dart';
// import '../mih_env/env.dart';
// import '../mih_objects/app_user.dart';
// import '../mih_objects/arguments.dart';
// import '../mih_objects/business.dart';
// import '../mih_objects/business_user.dart';
// import '../mih_objects/notification.dart';
// import '../mih_objects/patient_access.dart';
// import '../mih_objects/patient_queue.dart';
// import '../mih_objects/patients.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:supertokens_flutter/http.dart' as http;

import '../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../mih_env/env.dart';
import '../mih_objects/app_user.dart';
import '../mih_objects/arguments.dart';
import '../mih_objects/business.dart';
import '../mih_objects/business_user.dart';
import '../mih_objects/notification.dart';
import '../mih_objects/patient_access.dart';
import '../mih_objects/patient_queue.dart';
import '../mih_objects/patients.dart';

class MIHApiCalls {
  final baseAPI = AppEnviroment.baseApiUrl;

//================== PROFILE DATA ==========================================================================

  /// This function is used to get profile details of signed in user.
  ///
  /// Patameters: int notificationAmount which is used to get number of notifications to show.
  ///
  /// Returns HomeArguments which contains:-
  /// - Signed In user data.
  /// - Business user belongs to.
  /// - Business User details.
  /// - notifications.
  /// - user profile picture.
  Future<HomeArguments> getProfile(int notificationAmount) async {
    AppUser userData;
    Business? busData;
    BusinessUser? bUserData;
    Patient? patientData;
    List<MIHNotification> notifi;
    String userPic;

    // Get Userdata
    var uid = await SuperTokens.getUserId();
    var responseUser = await http.get(Uri.parse("$baseAPI/user/$uid"));
    if (responseUser.statusCode == 200) {
      // print("here");
      String body = responseUser.body;
      var decodedData = jsonDecode(body);
      AppUser u = AppUser.fromJson(decodedData);
      userData = u;
    } else {
      throw Exception(
          "Error: GetUserData status code ${responseUser.statusCode}");
    }

    // Get BusinessUserdata
    var responseBUser = await http.get(
      Uri.parse("$baseAPI/business-user/$uid"),
    );
    if (responseBUser.statusCode == 200) {
      String body = responseBUser.body;
      var decodedData = jsonDecode(body);
      BusinessUser business_User = BusinessUser.fromJson(decodedData);
      bUserData = business_User;
    } else {
      bUserData = null;
    }

    // Get Businessdata
    var responseBusiness =
        await http.get(Uri.parse("$baseAPI/business/app_id/$uid"));
    if (responseBusiness.statusCode == 200) {
      String body = responseBusiness.body;
      var decodedData = jsonDecode(body);
      Business business = Business.fromJson(decodedData);
      busData = business;
    } else {
      busData = null;
    }

    //get profile picture
    if (userData.pro_pic_path == "") {
      userPic = "";
    }
    // else if (AppEnviroment.getEnv() == "Dev") {
    //   userPic = "${AppEnviroment.baseFileUrl}/mih/${userData.pro_pic_path}";
    // }
    else {
      var url =
          "${AppEnviroment.baseApiUrl}/minio/pull/file/${AppEnviroment.getEnv()}/${userData.pro_pic_path}";
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String body = response.body;
        var decodedData = jsonDecode(body);

        userPic = decodedData['minioURL'];
      } else {
        userPic = "";
        // throw Exception(
        //     "Error: GetUserData status code ${response.statusCode}");
      }
    }

    //Get Notifications
    var responseNotification = await http.get(
        Uri.parse("$baseAPI/notifications/$uid?amount=$notificationAmount"));
    if (responseNotification.statusCode == 200) {
      String body = responseNotification.body;
      // var decodedData = jsonDecode(body);
      // MIHNotification notifications = MIHNotification.fromJson(decodedData);

      Iterable l = jsonDecode(body);
      //print("Here2");
      List<MIHNotification> notifications = List<MIHNotification>.from(
          l.map((model) => MIHNotification.fromJson(model)));
      notifi = notifications;
    } else {
      notifi = [];
    }

    //get patient profile
    //print("Patien manager page: $endpoint");
    final response = await http.get(
        Uri.parse("${AppEnviroment.baseApiUrl}/patients/${userData.app_id}"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    // var errorCode = response.statusCode.toString();
    // var errorBody = response.body;

    if (response.statusCode == 200) {
      // print("Here1");
      var decodedData = jsonDecode(response.body);
      // print("Here2");
      Patient patients = Patient.fromJson(decodedData as Map<String, dynamic>);
      // print("Here3");
      // print(patients);
      patientData = patients;
    } else {
      patientData = null;
    }
    //print(userPic);
    return HomeArguments(
        userData, bUserData, busData, patientData, notifi, userPic);
  }

  /// This function is used to get business details by business _id.
  ///
  /// Patameters: String business_id & app_id (app_id of patient).
  ///
  /// Returns List<PatientAccess> (List of access that match the above parameters).
  static Future<Business?> getBusinessDetails(String business_id) async {
    var responseBusiness = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/business/business_id/$business_id"));
    if (responseBusiness.statusCode == 200) {
      String body = responseBusiness.body;
      var decodedData = jsonDecode(body);
      Business business = Business.fromJson(decodedData);
      return business;
    } else {
      return null;
    }
  }

//================== BUSINESS PATIENT/PERSONAL ACCESS ==========================================================================

  /// This function is used to check if a business has access to a specific patients profile.
  ///
  /// Patameters: String business_id & app_id (app_id of patient).
  ///
  /// Returns List<PatientAccess> (List of access that match the above parameters).
  static Future<List<PatientAccess>> checkBusinessAccessToPatient(
    String business_id,
    String app_id,
  ) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/access-requests/patient/check/$business_id?app_id=$app_id"));
    // var errorCode = response.statusCode.toString();
    //print(response.body);

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<PatientAccess> patientAccesses = List<PatientAccess>.from(
          l.map((model) => PatientAccess.fromJson(model)));
      return patientAccesses;
    } else {
      throw Exception('failed to pull patient access for business');
    }
  }

  /// This function is used to get list of access the business has.
  ///
  /// Patameters: String business_id.
  ///
  /// Returns List<PatientAccess> (List of access that match the above parameters).
  static Future<List<PatientAccess>> getPatientAccessListOfBusiness(
      String business_id) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/access-requests/business/patient/$business_id"));
    // var errorCode = response.statusCode.toString();
    // print(response.statusCode);
    // print(response.body);

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<PatientAccess> patientAccesses = List<PatientAccess>.from(
          l.map((model) => PatientAccess.fromJson(model)));
      return patientAccesses;
    } else {
      throw Exception('failed to pull patient access List for business');
    }
  }

  /// This function is used to get list of access the business has.
  ///
  /// Patameters: String business_id.
  ///
  /// Returns List<PatientAccess> (List of access that match the above parameters).
  static Future<List<PatientAccess>> getBusinessAccessListOfPatient(
      String app_id) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/access-requests/personal/patient/$app_id"));
    // var errorCode = response.statusCode.toString();
    // print(response.statusCode);
    // print(response.body);

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<PatientAccess> patientAccesses = List<PatientAccess>.from(
          l.map((model) => PatientAccess.fromJson(model)));
      return patientAccesses;
    } else {
      throw Exception('failed to pull patient access List for business');
    }
  }

  /// This function is used to UPDATE access the business has.
  ///
  /// Patameters:-
  /// String business_id,
  /// String business_name,
  /// String app_id,
  /// String status,
  /// String approved_by,
  /// AppUser signedInUser,
  /// BuildContext context,
  ///
  /// Returns void (on success 200 navigate to /mih-access ).
  static Future<void> updatePatientAccessAPICall(
    String business_id,
    String business_name,
    String app_id,
    String status,
    String approved_by,
    AppUser signedInUser,
    BuildContext context,
  ) async {
    var response = await http.put(
      Uri.parse(
          "${AppEnviroment.baseApiUrl}/access-requests/update/permission/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      // business_id: str
      // app_id: str
      // status: str
      // approved_by: str
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": app_id,
        "status": status,
        "approved_by": approved_by,
      }),
    );
    if (response.statusCode == 200) {
      //Navigator.of(context).pushNamed('/home');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/mih-access',
        arguments: signedInUser,
      );
      String message = "";
      if (status == "approved") {
        message =
            "You've successfully approved the access request! $business_name now has access to your profile forever.";
      } else {
        message =
            "You've declined the access request. $business_name will not have access to your profile.";
      }
      successPopUp(message, context);
    } else {
      internetConnectionPopUp(context);
    }
  }

  /// This function is used to reapply for access to patient.
  ///
  /// Patameters:-
  /// String business_id,
  /// String app_id,
  /// BuildContext context,
  ///
  /// Returns void (on success 200 navigate to /mih-access ).
  static Future<void> reapplyPatientAccessAPICall(
    String business_id,
    String app_id,
    bool personalSelected,
    BusinessArguments args,
    BuildContext context,
  ) async {
    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/access-requests/re-apply/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      // business_id: str
      // app_id: str
      // status: str
      // approved_by: str
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": app_id,
      }),
    );
    if (response.statusCode == 200) {
      MihNotificationApis.reapplyAccessRequestNotificationAPICall(
          app_id, personalSelected, args, context);
      //notification here
    } else {
      internetConnectionPopUp(context);
    }
  }

  /// This function is used to create patient access and trigger notification to patient
  ///
  /// Patameters:-
  /// String business_id,
  /// String app_id,
  /// String type,
  /// String requested_by,
  /// BuildContext context,
  ///
  /// Returns void (triggers notification of success 201).
  static Future<void> addPatientAccessAPICall(
    String business_id,
    String app_id,
    String type,
    String requested_by,
    bool personalSelected,
    BusinessArguments args,
    BuildContext context,
  ) async {
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/access-requests/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      // business_id: str
      // app_id: str
      // type: str
      // requested_by: str
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": app_id,
        "type": type,
        "requested_by": requested_by,
      }),
    );
    if (response.statusCode == 201) {
      MihNotificationApis.addAccessRequestNotificationAPICall(
          app_id, requested_by, personalSelected, args, context);
    } else {
      internetConnectionPopUp(context);
    }
  }

  //================== PATIENT DATA ==========================================================================

  /// This function is used to fetch a list of patients matching a search criteria
  ///
  /// Patameters: String dsearch.
  ///
  /// Returns List<Patient>.
  static Future<List<Patient>> fetchPatients(String search) async {
    final response = await http
        .get(Uri.parse("${AppEnviroment.baseApiUrl}/patients/search/$search"));
    // errorCode = response.statusCode.toString();
    // errorBody = response.body;

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Patient> patients =
          List<Patient>.from(l.map((model) => Patient.fromJson(model)));
      return patients;
    } else {
      throw Exception('failed to load patients');
    }
  }

  /// This function is used to fetch a patient matching a app_id
  ///
  /// Patameters: String app_id.
  ///
  /// Returns Patient.
  static Future<Patient> fetchPatientByAppId(
    String app_id,
  ) async {
    final response = await http
        .get(Uri.parse("${AppEnviroment.baseApiUrl}/patients/$app_id"));
    // errorCode = response.statusCode.toString();
    // errorBody = response.body;
    //print(response.body);
    if (response.statusCode == 200) {
      Patient patient = Patient.fromJson(jsonDecode(response.body));
      // userData = u;
      // Iterable l = jsonDecode(response.body);
      // List<Patient> patients =
      //     List<Patient>.from(l.map((model) => Patient.fromJson(model)));
      return patient;
    } else {
      throw Exception('failed to load patient');
    }
  }

  //================== APPOINTMENT/ PATIENT QUEUE ==========================================================================

  /// This function is used to fetch a list of appointments for a doctors office for a date.
  ///
  /// Patameters: String date & business_id .
  ///
  /// Returns List<PatientQueue>.
  static Future<List<PatientQueue>> fetchBusinessAppointmentsAPICall(
    String date,
    String business_id,
  ) async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/queue/appointments/business/$business_id?date=$date"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    // errorCode = response.statusCode.toString();
    // errorBody = response.body;

    if (response.statusCode == 200) {
      //print("Here1");
      Iterable l = jsonDecode(response.body);
      //print("Here2");
      List<PatientQueue> patientQueue = List<PatientQueue>.from(
          l.map((model) => PatientQueue.fromJson(model)));
      //print("Here3");
      //print(patientQueue);
      return patientQueue;
    } else {
      throw Exception('failed to fatch patient queue');
    }
  }

  /// This function is used to fetch a list of appointments for a doctors office for a date.
  ///
  /// Patameters: String date & business_id .
  ///
  /// Returns List<PatientQueue>.
  static Future<List<PatientQueue>> fetchPersonalAppointmentsAPICall(
    String date,
    String app_id,
  ) async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/queue/appointments/personal/$app_id?date=$date"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    // errorCode = response.statusCode.toString();
    // errorBody = response.body;

    if (response.statusCode == 200) {
      //print("Here1");
      Iterable l = jsonDecode(response.body);
      //print("Here2");
      List<PatientQueue> patientQueue = List<PatientQueue>.from(
          l.map((model) => PatientQueue.fromJson(model)));
      //print("Here3");
      //print(patientQueue);
      return patientQueue;
    } else {
      throw Exception('failed to fatch patient queue');
    }
  }

  /// This function is used to UPDATE AN appointments for a doctors office for a date.
  ///
  /// Patameters:-
  /// int idpatient_queue,
  /// String app_id,
  /// String business_name,
  /// String origDate_time,
  /// String date,
  /// String time,
  /// BusinessArguments args,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS NOTIGICATIOPN ON SUCCESS)
  static Future<void> updateApointmentAPICall(
    int idpatient_queue,
    String app_id,
    bool personalSelected,
    String business_name,
    String origDate_time,
    String date,
    String time,
    BusinessArguments args,
    BuildContext context,
  ) async {
    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/queue/appointment/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "idpatient_queue": idpatient_queue,
        "date": date,
        "time": time,
      }),
    );
    if (response.statusCode == 200) {
      MihNotificationApis.addRescheduledAppointmentNotificationAPICall(
        app_id,
        personalSelected,
        business_name,
        origDate_time,
        date,
        time,
        args,
        context,
      );
    } else {
      internetConnectionPopUp(context);
    }
  }

  /// This function is used to Delete/ cancel AN appointments for a doctors office for a date.
  ///
  /// Patameters:-
  /// int idpatient_queue,
  /// PatientViewArguments args,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS NOTIGICATIOPN ON SUCCESS)
  static Future<void> deleteApointmentAPICall(
    int idpatient_queue,
    String app_id,
    bool personalSelected,
    String date_time,
    BusinessArguments args,
    BuildContext context,
  ) async {
    var response = await http.delete(
      Uri.parse("${AppEnviroment.baseApiUrl}/queue/appointment/delete/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{"idpatient_queue": idpatient_queue}),
    );
    //print("Here4");
    //print(response.statusCode);
    if (response.statusCode == 200) {
      MihNotificationApis.addCancelledAppointmentNotificationAPICall(
        app_id,
        personalSelected,
        date_time,
        args,
        context,
      );
      // Navigator.of(context).pop();
      // Navigator.of(context).pop();
      // String message =
      //     "The note has been deleted successfully. This means it will no longer be visible on your and cannot be used for future appointments.";
      // successPopUp(message, context);
    } else {
      internetConnectionPopUp(context);
    }
  }

  /// This function is used to create AN appointments for a doctors office for a date.
  ///
  /// Patameters:-
  /// int idpatient_queue,
  /// PatientViewArguments args,
  /// BuildContext context,
  ///
  /// Returns VOID (TRIGGERS NOTIGICATIOPN ON SUCCESS)
  static Future<void> addAppointmentAPICall(
    String business_id,
    String app_id,
    bool personalSelected,
    String date,
    String time,
    BusinessArguments args,
    BuildContext context,
  ) async {
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/queue/appointment/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": app_id,
        "date": date,
        "time": time,
      }),
    );
    if (response.statusCode == 201) {
      // Navigator.pushNamed(context, '/patient-manager/patient',
      //     arguments: widget.signedInUser);
      // String message =
      //     "The appointment has been successfully booked!\n\nAn approval request as been sent to the patient.Once the access request has been approved, you will be able to access the patientAccesses profile. ou can check the status of your request in patient queue under the appointment.";
      //     "${fnameController.text} ${lnameController.text} patient profiole has been successfully added!\n";
      // Navigator.pop(context);
      // Navigator.pop(context);
      // Navigator.pop(context);
      // setState(() {
      //   dateController.text = "";
      //   timeController.text = "";
      // });
      // Navigator.of(context).pushNamed(
      //   '/patient-manager',
      //   arguments: BusinessArguments(
      //     widget.arguments.signedInUser,
      //     widget.arguments.businessUser,
      //     widget.arguments.business,
      //   ),
      // );
      // successPopUp(message);
      // String app_id,
      // String date,
      // String time,
      // BusinessArguments args,
      // BuildContext context,
      MihNotificationApis.addNewAppointmentNotificationAPICall(
        app_id,
        personalSelected,
        date,
        time,
        args,
        context,
      );
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
