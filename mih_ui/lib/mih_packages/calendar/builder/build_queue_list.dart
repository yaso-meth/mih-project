import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_queue.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';

class BuildQueueList extends StatefulWidget {
  final List<PatientQueue> patientQueue;
  final AppUser signedInUser;

  const BuildQueueList({
    super.key,
    required this.patientQueue,
    required this.signedInUser,
  });

  @override
  State<BuildQueueList> createState() => _BuildQueueListState();
}

class _BuildQueueListState extends State<BuildQueueList> {
  String baseAPI = AppEnviroment.baseApiUrl;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController daysExtensionController = TextEditingController();
  int counter = 0;

  Widget displayQueue(int index) {
    String title = widget.patientQueue[index].business_name.toUpperCase();
    // widget.patientQueue[index].date_time.split('T')[1].substring(0, 5);
    String line234 = "";
    // var nowDate = DateTime.now();
    // var expireyDate = DateTime.parse(widget.patientQueue[index].revoke_date);

    line234 +=
        widget.patientQueue[index].date_time.split('T')[1].substring(0, 5);

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          text: "Time: $line234",
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
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
