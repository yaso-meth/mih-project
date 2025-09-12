import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/patient_add.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/patient_profile.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';

class AddOrViewPatient extends StatefulWidget {
  //final AppUser signedInUser;
  final PatientViewArguments arguments;
  const AddOrViewPatient({
    super.key,
    required this.arguments,
  });

  @override
  State<AddOrViewPatient> createState() => _AddOrViewPatientState();
}

class _AddOrViewPatientState extends State<AddOrViewPatient> {
  late double width;
  late double height;
  late Widget loading;
  late Future<Patient?> patient;

  Future<Patient?> fetchPatientData() async {
    return await MihPatientServices()
        .getPatientDetails(widget.arguments.signedInUser.app_id);
  }

  @override
  void initState() {
    super.initState();
    patient = fetchPatientData();
  }

  @override
  Widget build(BuildContext context) {
    print("AddOrViewPatient");
    var size = MediaQuery.of(context).size;
    setState(() {
      width = size.width;
      height = size.height;
    });
    return FutureBuilder(
      future: patient,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          // Extracting data from snapshot object
          //final data = snapshot.data as String;
          return PatientProfile(
              arguments: PatientViewArguments(
            widget.arguments.signedInUser,
            snapshot.requireData,
            null,
            null,
            widget.arguments.type,
          ));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          loading = Container(
            width: width,
            height: height,
            color: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            child: const Mihloadingcircle(),
          );

          return loading;
        } else {
          return AddPatient(signedInUser: widget.arguments.signedInUser);
        }
      },
    );
  }
}
