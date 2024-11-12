import 'package:flutter/material.dart';
import 'package:patient_manager/mih_apis/mih_api_calls.dart';
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
        "Office: ${widget.patientQueue[index].business_name.toUpperCase()}";

    return ListTile(
      title: Text(
        "Time: $title",
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
      onTap: () {},
    );
  }

  bool isAccessExpired(String accessType) {
    if (accessType == "EXPIRED") {
      return true;
    } else {
      return false;
    }
  }

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
