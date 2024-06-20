import 'package:flutter/material.dart';
import 'package:patient_manager/components/patientDetailItem.dart';
import 'package:patient_manager/objects/patients.dart';

class PatientDetails extends StatefulWidget {
  final Patient selectedPatient;
  const PatientDetails({super.key, required this.selectedPatient});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  double? headingFontSize = 35.0;
  double? bodyFonstSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 219, 218, 218),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        //constraints: const BoxConstraints.expand(height: 250.0),
        child: SelectionArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Patient Details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    alignment: Alignment.topRight,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          '/patient-manager/patient/edit',
                          arguments: widget.selectedPatient);
                    },
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    children: [
                      PatientDetailItem(
                        category: "ID No.   ",
                        value: widget.selectedPatient.id_no,
                      ),
                      PatientDetailItem(
                        category: "Name ",
                        value: widget.selectedPatient.first_name,
                      ),
                      PatientDetailItem(
                        category: "Surname ",
                        value: widget.selectedPatient.last_name,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      PatientDetailItem(
                        category: "Cell No ",
                        value: widget.selectedPatient.cell_no,
                      ),
                      PatientDetailItem(
                        category: "Email  ",
                        value: widget.selectedPatient.email,
                      ),
                      PatientDetailItem(
                        category: "Address  ",
                        value: widget.selectedPatient.address,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Medical Aid Details",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    children: [
                      PatientDetailItem(
                        category: "No. ",
                        value: widget.selectedPatient.medical_aid_no,
                      ),
                      PatientDetailItem(
                        category: "Name ",
                        value: widget.selectedPatient.medical_aid_name,
                      ),
                      PatientDetailItem(
                        category: "Scheme ",
                        value: widget.selectedPatient.medical_aid_scheme,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
