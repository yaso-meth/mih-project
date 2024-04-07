import 'package:flutter/material.dart';
import 'package:patient_manager/objects/patients.dart';

class BuildPatientsList extends StatefulWidget {
  final List<Patient> patients;
  const BuildPatientsList({
    super.key,
    required this.patients,
  });

  @override
  State<BuildPatientsList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildPatientsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.patients.length,
      itemBuilder: (context, index) {
        final patient = widget.patients[index];
        return ListTile(
          title: Text(patient.first_name + " " + patient.last_name),
          subtitle: Text(patient.id_no),
        );
      },
    );
  }
}
