import 'package:flutter/material.dart';
import 'package:patient_manager/objects/patients.dart';

class BuildPatientsList extends StatefulWidget {
  final List<Patient> patients;
  final searchString;
  const BuildPatientsList({
    super.key,
    required this.patients,
    required this.searchString,
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
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        return widget.patients[index].id_no.contains(widget.searchString)
            ? ListTile(
                title: Text(widget.patients[index].first_name +
                    " " +
                    widget.patients[index].last_name),
                subtitle: Text(widget.patients[index].id_no),
              )
            : Container();
      },
    );
  }
}
