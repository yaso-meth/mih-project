import 'package:flutter/material.dart';
import 'package:patient_manager/components/popUpMessages/mihWarningMessage.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/accessRequest.dart';
import 'package:patient_manager/objects/appUser.dart';

class BuildAccessRequestList extends StatefulWidget {
  final List<AccessRequest> accessRequests;
  final AppUser signedInUser;

  const BuildAccessRequestList({
    super.key,
    required this.accessRequests,
    required this.signedInUser,
  });

  @override
  State<BuildAccessRequestList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildAccessRequestList> {
  String baseAPI = AppEnviroment.baseApiUrl;

  Widget displayQueue(int index) {
    String title =
        "Appointment: ${widget.accessRequests[index].date_time.substring(0, 10)}";
    String subtitle = "";
    subtitle += "Requestor: ${widget.accessRequests[index].Name}\n";
    subtitle += "Business Type: ${widget.accessRequests[index].type}\n";
    subtitle += "Access: ${widget.accessRequests[index].access.toUpperCase()}";

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      onTap: () {
        //popup to approve
      },
      trailing: Icon(
        Icons.arrow_forward,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      ),
    );
  }

  void noAccessWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "No Access");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemCount: widget.accessRequests.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        //print(index);
        return displayQueue(index);
      },
    );
  }
}
