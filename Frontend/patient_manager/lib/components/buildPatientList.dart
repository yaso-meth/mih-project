import 'package:flutter/material.dart';
import 'package:patient_manager/components/mihErrorMessage.dart';
import 'package:patient_manager/components/mihButton.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/patients.dart';

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
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  void submitApointment() {}

  bool isAppointmentFieldsFilled() {
    if (dateController.text.isEmpty || timeController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void appointmentPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 700.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add Patient to appointment",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: MIHButton(
                      buttonText: "Generate",
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      textColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      onTap: () {
                        if (isAppointmentFieldsFilled()) {
                          submitApointment();
                          Navigator.pop(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const MIHErrorMessage(
                                  errorType: "Input Error");
                            },
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
