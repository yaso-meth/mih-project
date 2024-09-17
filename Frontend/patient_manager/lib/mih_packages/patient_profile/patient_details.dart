import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_objects/arguments.dart';
import 'package:patient_manager/mih_objects/patients.dart';

class PatientDetails extends StatefulWidget {
  final AppUser signedInUser;
  final Patient selectedPatient;
  final String type;
  const PatientDetails({
    super.key,
    required this.signedInUser,
    required this.selectedPatient,
    required this.type,
  });

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  final idController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final cellController = TextEditingController();
  final emailController = TextEditingController();
  final medNoController = TextEditingController();
  final medNameController = TextEditingController();
  final medSchemeController = TextEditingController();
  final addressController = TextEditingController();
  final medAidController = TextEditingController();
  final medMainMemController = TextEditingController();
  final medAidCodeController = TextEditingController();
  double? headingFontSize = 35.0;
  double? bodyFonstSize = 20.0;
  double textFieldWidth = 400.0;
  late String medAid;

  Widget getPatientDetailsField() {
    return Wrap(
      spacing: 15,
      runSpacing: 10,
      children: [
        SizedBox(
          width: textFieldWidth,
          child: MIHTextField(
              controller: idController,
              hintText: "ID No.",
              editable: false,
              required: false),
        ),
        SizedBox(
          width: textFieldWidth,
          child: MIHTextField(
              controller: fnameController,
              hintText: "Name",
              editable: false,
              required: false),
        ),
        SizedBox(
          width: textFieldWidth,
          child: MIHTextField(
              controller: lnameController,
              hintText: "Surname",
              editable: false,
              required: false),
        ),
        SizedBox(
          width: textFieldWidth,
          child: MIHTextField(
              controller: cellController,
              hintText: "Cell No.",
              editable: false,
              required: false),
        ),
        SizedBox(
          width: textFieldWidth,
          child: MIHTextField(
              controller: emailController,
              hintText: "Email",
              editable: false,
              required: false),
        ),
        SizedBox(
          width: textFieldWidth,
          child: MIHTextField(
              controller: addressController,
              hintText: "Address",
              editable: false,
              required: false),
        ),
      ],
    );
  }

  Widget getMedAidDetailsFields() {
    List<Widget> medAidDet = [];
    medAidDet.add(SizedBox(
      width: textFieldWidth,
      child: MIHTextField(
          controller: medAidController,
          hintText: "Medical Aid",
          editable: false,
          required: false),
    ));
    bool req;
    if (medAid == "Yes") {
      req = true;
    } else {
      req = false;
    }
    medAidDet.addAll([
      Visibility(
        visible: req,
        child: SizedBox(
          width: textFieldWidth,
          child: MIHTextField(
              controller: medMainMemController,
              hintText: "Main Member",
              editable: false,
              required: false),
        ),
      ),
      //const SizedBox(height: 10.0),
      Visibility(
        visible: req,
        child: SizedBox(
          width: textFieldWidth,
          child: MIHTextField(
              controller: medNoController,
              hintText: "No.",
              editable: false,
              required: false),
        ),
      ),
      //const SizedBox(height: 10.0),
      Visibility(
        visible: req,
        child: SizedBox(
          width: textFieldWidth,
          child: MIHTextField(
              controller: medAidCodeController,
              hintText: "Code",
              editable: false,
              required: false),
        ),
      ),
      //const SizedBox(height: 10.0),
      Visibility(
        visible: req,
        child: SizedBox(
          width: textFieldWidth,
          child: MIHTextField(
              controller: medNameController,
              hintText: "Name",
              editable: false,
              required: false),
        ),
      ),
      //const SizedBox(height: 10.0),
      Visibility(
        visible: req,
        child: SizedBox(
          width: textFieldWidth,
          child: MIHTextField(
              controller: medSchemeController,
              hintText: "Scheme",
              editable: false,
              required: false),
        ),
      ),
      //),
    ]);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: medAidDet,
    );
  }

  List<Widget> setIcons() {
    if (widget.type == "personal") {
      return [
        Text(
          "Personal Details",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          alignment: Alignment.topRight,
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          onPressed: () {
            Navigator.of(context).pushNamed('/patient-profile/edit',
                arguments: PatientEditArguments(
                    widget.signedInUser, widget.selectedPatient));
          },
        )
      ];
    } else {
      return [
        Text(
          "Patient Details",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
      ];
    }
  }

  @override
  void dispose() {
    idController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    cellController.dispose();
    emailController.dispose();
    medNameController.dispose();
    medNoController.dispose();
    medSchemeController.dispose();
    addressController.dispose();
    medAidController.dispose();
    medMainMemController.dispose();
    medAidCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      idController.value = TextEditingValue(text: widget.selectedPatient.id_no);
      fnameController.value =
          TextEditingValue(text: widget.selectedPatient.first_name);
      lnameController.value =
          TextEditingValue(text: widget.selectedPatient.last_name);
      cellController.value =
          TextEditingValue(text: widget.selectedPatient.cell_no);
      emailController.value =
          TextEditingValue(text: widget.selectedPatient.email);
      medNameController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_name);
      medNoController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_no);
      medSchemeController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_scheme);
      addressController.value =
          TextEditingValue(text: widget.selectedPatient.address);
      medAidController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid);
      medMainMemController.value = TextEditingValue(
          text: widget.selectedPatient.medical_aid_main_member);
      medAidCodeController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_code);
      medAid = widget.selectedPatient.medical_aid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: ,
              children: setIcons(),
            ),
            Divider(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
            const SizedBox(height: 10),
            getPatientDetailsField(),
            const SizedBox(height: 10),
            Text(
              "Medical Aid Details",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
            Divider(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
            const SizedBox(height: 10),
            getMedAidDetailsFields(),
          ],
        ),
      ),
    );
  }
}
