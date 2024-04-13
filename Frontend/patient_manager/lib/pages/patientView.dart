import 'package:flutter/material.dart';
import 'package:patient_manager/components/PatientDetails.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/objects/patients.dart';

class PatientView extends StatefulWidget {
  final Patient selectedPatient;
  const PatientView({super.key, required this.selectedPatient});

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(barTitle: "Patient View"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(
          children: [
            PatientDetails(selectedPatient: widget.selectedPatient),
          ],
        ),
      ),
    );
    // Center(
    //   child: Text(widget.selectedPatient.first_name),
    // ),
  }
}
