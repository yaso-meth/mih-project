import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/patients.dart';
//import 'package:patient_manager/pages/patientView.dart';

class BuildPatientsList extends StatefulWidget {
  final List<Patient> patients;
  final AppUser signedInUser;

  const BuildPatientsList({
    super.key,
    required this.patients,
    required this.signedInUser,
  });

  @override
  State<BuildPatientsList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildPatientsList> {
  Widget isMainMember(int index) {
    //var matchRE = RegExp(r'^[a-z]+$');
    var firstLetterFName = widget.patients[index].first_name[0];
    var firstLetterLName = widget.patients[index].last_name[0];
    var fnameStar = '*' * 8;
    var lnameStar = '*' * 8;

    if (widget.patients[index].medical_aid_main_member == "Yes") {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "$firstLetterFName$fnameStar $firstLetterLName$lnameStar",
            style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.star_border_rounded,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ],
      );
    } else {
      return Text(
        "$firstLetterFName$fnameStar $firstLetterLName$lnameStar",
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      );
    }
  }

  Widget hasMedicalAid(int index) {
    var medAidNoStar = '*' * 8;
    if (widget.patients[index].medical_aid == "Yes") {
      return ListTile(
        title: isMainMember(index),
        subtitle: Text(
          "ID No.: ${widget.patients[index].id_no}\nMedical Aid No.: $medAidNoStar",
          style: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        onTap: () {
          setState(() {
            // Add popup to add patienmt to queue
            // Navigator.of(context).pushNamed('/patient-manager/patient',
            //     arguments: PatientViewArguments(
            //         widget.signedInUser, widget.patients[index], "business"));
          });
        },
        trailing: Icon(
          Icons.arrow_forward,
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      );
    } else {
      return ListTile(
        title: isMainMember(index),
        subtitle: Text(
          "ID No.: ${widget.patients[index].id_no}\nMedical Aid No.: $medAidNoStar",
          style: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        onTap: () {
          setState(() {
            Navigator.of(context).pushNamed('/patient-manager/patient',
                arguments: PatientViewArguments(
                    widget.signedInUser, widget.patients[index], "business"));
          });
        },
        trailing: Icon(
          Icons.arrow_forward,
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemCount: widget.patients.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        //print(index);
        return hasMedicalAid(index);
      },
    );
  }
}
