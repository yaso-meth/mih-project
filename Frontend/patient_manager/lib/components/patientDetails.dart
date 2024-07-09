import 'package:flutter/material.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/objects/patients.dart';
import 'package:patient_manager/theme/mihTheme.dart';

class PatientDetails extends StatefulWidget {
  final Patient selectedPatient;
  const PatientDetails({super.key, required this.selectedPatient});

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
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: MyTheme().primaryColor(),
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(color: MyTheme().secondaryColor(), width: 3.0),
      ),
      //constraints: const BoxConstraints.expand(height: 250.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: ,
            children: [
              Text(
                "Patient Details",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MyTheme().secondaryColor(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                alignment: Alignment.topRight,
                color: MyTheme().secondaryColor(),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      '/patient-manager/patient/edit',
                      arguments: widget.selectedPatient);
                },
              )
            ],
          ),
          Divider(color: MyTheme().secondaryColor()),
          const SizedBox(height: 10),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        controller: idController,
                        hintText: "ID No.",
                        editable: false,
                        required: false),
                  ),
                  Expanded(
                    child: MyTextField(
                        controller: fnameController,
                        hintText: "Name",
                        editable: false,
                        required: false),
                  ),
                  Expanded(
                    child: MyTextField(
                        controller: lnameController,
                        hintText: "Surname",
                        editable: false,
                        required: false),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        controller: cellController,
                        hintText: "Cell No.",
                        editable: false,
                        required: false),
                  ),
                  Expanded(
                    child: MyTextField(
                        controller: emailController,
                        hintText: "Email",
                        editable: false,
                        required: false),
                  ),
                  Expanded(
                    child: MyTextField(
                        controller: addressController,
                        hintText: "Address",
                        editable: false,
                        required: false),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Medical Aid Details",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: MyTheme().secondaryColor(),
            ),
          ),
          Divider(color: MyTheme().secondaryColor()),
          const SizedBox(height: 10),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        controller: medAidController,
                        hintText: "Has Medical Aid",
                        editable: false,
                        required: false),
                  ),
                  Expanded(
                    child: MyTextField(
                        controller: medMainMemController,
                        hintText: "Main Member",
                        editable: false,
                        required: false),
                  ),
                  Expanded(
                    child: MyTextField(
                        controller: medNoController,
                        hintText: "No.",
                        editable: false,
                        required: false),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        controller: medAidCodeController,
                        hintText: "Code",
                        editable: false,
                        required: false),
                  ),
                  Expanded(
                    child: MyTextField(
                        controller: medNameController,
                        hintText: "Name",
                        editable: false,
                        required: false),
                  ),
                  Expanded(
                    child: MyTextField(
                        controller: medSchemeController,
                        hintText: "Scheme",
                        editable: false,
                        required: false),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
