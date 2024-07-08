import 'package:flutter/material.dart';
import 'package:patient_manager/objects/patients.dart';

class BuildPatientsList extends StatefulWidget {
  final List<Patient> patients;
  //final searchString;

  const BuildPatientsList({
    super.key,
    required this.patients,
    //required this.searchString,
  });

  @override
  State<BuildPatientsList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildPatientsList> {
  Widget isMainMember(int index) {
    if (widget.patients[index].medical_aid_main_member == "Yes") {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(Icons.star_border_rounded),
          Text(
              "${widget.patients[index].first_name} ${widget.patients[index].last_name}"),
        ],
      );
    } else {
      return Text(
          "${widget.patients[index].first_name} ${widget.patients[index].last_name}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, index) {
        return const Divider();
      },
      itemCount: widget.patients.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        //print(index);
        return ListTile(
          title: isMainMember(index),
          subtitle: Text(
              "ID No.: ${widget.patients[index].id_no}\nMedical Aid No.: ${widget.patients[index].medical_aid_no}"),
          onTap: () {
            setState(() {
              Navigator.of(context).pushNamed('/patient-manager/patient',
                  arguments: widget.patients[index]);
            });
          },
          trailing: const Icon(Icons.arrow_forward),
        );
      },
    );
  }
}
