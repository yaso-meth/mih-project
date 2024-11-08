import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_warning_message.dart';
import 'package:patient_manager/mih_env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_objects/patient_queue.dart';

class BuildAppointmentList extends StatefulWidget {
  final List<PatientQueue> patientQueue;
  final AppUser signedInUser;

  const BuildAppointmentList({
    super.key,
    required this.patientQueue,
    required this.signedInUser,
  });

  @override
  State<BuildAppointmentList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildAppointmentList> {
  String baseAPI = AppEnviroment.baseApiUrl;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController daysExtensionController = TextEditingController();
  int counter = 0;

  Widget displayQueue(int index) {
    String title =
        widget.patientQueue[index].date_time.split('T')[1].substring(0, 5);
    String line234 = "";
    // var nowDate = DateTime.now();
    // var expireyDate = DateTime.parse(widget.patientQueue[index].revoke_date);

    line234 +=
        "Name: ${widget.patientQueue[index].first_name} ${widget.patientQueue[index].last_name}\nID No.: ${widget.patientQueue[index].id_no}\nMedical Aid No: ";
    if (widget.patientQueue[index].medical_aid_no == "") {
      line234 += "No Medical Aid";
    } else {
      // subtitle +=
      //     "\nMedical Aid No: ";
      line234 += widget.patientQueue[index].medical_aid_no;
    }

    // String line5 = "\nAccess Request: ";
    // String access = "";
    // if (expireyDate.isBefore(nowDate) &&
    //     widget.patientQueue[index].access != "cacelled") {
    //   access += "EXPIRED";
    // } else {
    //   access += widget.patientQueue[index].access.toUpperCase();
    // }
    // TextSpan accessWithColour;
    // if (access == "APPROVED") {
    //   accessWithColour = TextSpan(
    //       text: access,
    //       style: TextStyle(
    //           color: MzanziInnovationHub.of(context)!.theme.successColor()));
    // } else if (access == "PENDING") {
    //   accessWithColour = TextSpan(
    //       text: access,
    //       style: TextStyle(
    //           color:
    //               MzanziInnovationHub.of(context)!.theme.messageTextColor()));
    // } else {
    //   accessWithColour = TextSpan(
    //       text: access,
    //       style: TextStyle(
    //           color: MzanziInnovationHub.of(context)!.theme.errorColor()));
    // }
    // String line6 = "";
    // line6 +=
    //     "\nAccess Expiration date: ${widget.patientQueue[index].revoke_date.substring(0, 16).replaceAll("T", " ")}";
    return ListTile(
      title: Text(
        "Appointment: $title",
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          text: line234,
          style: DefaultTextStyle.of(context).style,
          // children: [
          //   TextSpan(text: line5),
          //   accessWithColour,
          //   TextSpan(text: line6),
          // ]
        ),
      ),
      // Text(
      //   subtitle,
      //   style: TextStyle(
      //     color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      //   ),
      // ),
      onTap: () {
        // var todayDate = DateTime.now();
        // var revokeDate = DateTime.parse(widget.patientQueue[index].revoke_date);
        // // print(
        // //     "Todays: $todayDate\nRevoke Date: $revokeDate\nHas revoke date passed: ${revokeDate.isBefore(todayDate)}");
        // if (revokeDate.isBefore(todayDate)) {
        //   expiredAccessWarning();
        // } else if (widget.patientQueue[index].access == "approved") {
        //   viewConfirmationPopUp(index);
        //   // Patient selectedPatient;
        //   // fetchPatients(widget.patientQueue[index].app_id).then(
        //   //   (result) {
        //   //     setState(() {
        //   //       selectedPatient = result;
        //   //       Navigator.of(context).pushNamed('/patient-manager/patient',
        //   //           arguments: PatientViewArguments(
        //   //             widget.signedInUser,
        //   //             selectedPatient,
        //   //             widget.businessUser,
        //   //             widget.business,
        //   //             "business",
        //   //           ));
        //   //     });
        //   //   },
        //   // );
        // } else if (widget.patientQueue[index].access == "declined") {
        //   accessDeclinedWarning();
        // } else if (widget.patientQueue[index].access == "cancelled") {
        //   appointmentCancelledWarning();
        // } else {
        //viewConfirmationPopUp(index);
        //noAccessWarning();
        // }
      },
      //leading: getExtendAccessButton(access),
      //trailing: getExtendAccessButton(access, index),
      // Icon(
      //   Icons.arrow_forward,
      //   color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      // ),
    );
  }

  bool isAccessExpired(String accessType) {
    if (accessType == "EXPIRED") {
      return true;
    } else {
      return false;
    }
  }

  // Widget getExtendAccessButton(String accessType, int index) {
  //   if (isAccessExpired(accessType)) {
  //     return IconButton(
  //       icon: const Icon(Icons.cached),
  //       onPressed: () {
  //         setState(() {
  //           daysExtensionController.text = counter.toString();
  //         });
  //         reapplyForAccess(index);
  //       },
  //     );
  //   } else {
  //     return Icon(
  //       Icons.arrow_forward,
  //       color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //     );
  //   }
  // }

  // void reapplyForAccess(int index) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => MIHWindow(
  //       fullscreen: false,
  //       windowTitle: "Extend Access",
  //       windowTools: const [],
  //       onWindowTapClose: () {
  //         Navigator.pop(context);
  //       },
  //       windowBody: [
  //         Text(
  //           "Current Expiration Date : ${widget.patientQueue[index].revoke_date.replaceAll("T", " ")}",
  //           style: TextStyle(
  //             color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //             fontSize: 15,
  //             fontWeight: FontWeight.normal,
  //           ),
  //         ),
  //         const SizedBox(height: 5),
  //         Text(
  //           "Select the number of days you would like to extend the access by.",
  //           style: TextStyle(
  //             color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //             fontSize: 15,
  //             fontWeight: FontWeight.normal,
  //           ),
  //         ),
  //         const SizedBox(height: 5),
  //         Text(
  //           "Once you click \"Apply\", an access review request will be triggered to the patient.",
  //           style: TextStyle(
  //             color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //             fontSize: 15,
  //             fontWeight: FontWeight.normal,
  //           ),
  //         ),
  //         const SizedBox(height: 30),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             IconButton.filled(
  //               onPressed: () {
  //                 if (counter > 0) {
  //                   counter--;
  //                   setState(() {
  //                     daysExtensionController.text = counter.toString();
  //                   });
  //                 }
  //               },
  //               icon: const Icon(Icons.remove),
  //             ),
  //             const SizedBox(width: 15),
  //             SizedBox(
  //               width: 100,
  //               child: MIHTextField(
  //                 controller: daysExtensionController,
  //                 hintText: "Days",
  //                 editable: false,
  //                 required: true,
  //               ),
  //             ),
  //             const SizedBox(width: 15),
  //             IconButton.filled(
  //               onPressed: () {
  //                 counter++;
  //                 setState(() {
  //                   daysExtensionController.text = counter.toString();
  //                 });
  //               },
  //               icon: const Icon(Icons.add),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 30),
  //         SizedBox(
  //           width: 300,
  //           height: 50,
  //           child: MIHButton(
  //             onTap: () {
  //               print(
  //                   "Revoke Date (String): ${widget.patientQueue[index].revoke_date}");
  //               var revokeDate = DateTime.parse(widget
  //                   .patientQueue[index].revoke_date
  //                   .replaceAll("T", " "));
  //               var newRevokeDate = revokeDate.add(
  //                   Duration(days: int.parse(daysExtensionController.text)));
  //               print("Revoke Date (DateTime): $revokeDate");
  //               print("New Revoke Date (DateTime): $newRevokeDate");
  //               print(
  //                 "${widget.business!.Name} would like to extend the access expirey date for your appointment on the ${widget.patientQueue[index].date_time}.\nNew Expirey Date: $revokeDate",
  //               );
  //               extendAccessAPICall(index, "$newRevokeDate");
  //             },
  //             buttonText: "Apply",
  //             buttonColor:
  //                 MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //             textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void noAccessWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "No Access");
      },
    );
  }

  void accessDeclinedWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "Access Declined");
      },
    );
  }

  void appointmentCancelledWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "Appointment Canelled");
      },
    );
  }

  void expiredAccessWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "Expired Access");
      },
    );
  }

  @override
  void dispose() {
    daysExtensionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemCount: widget.patientQueue.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        //print(index);
        return displayQueue(index);
      },
    );
  }
}
