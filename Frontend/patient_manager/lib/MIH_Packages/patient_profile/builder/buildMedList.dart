import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/medicine.dart';

class BuildMedicinesList extends StatefulWidget {
  final TextEditingController contoller;
  final List<Medicine> medicines;
  //final searchString;

  const BuildMedicinesList({
    super.key,
    required this.contoller,
    required this.medicines,
    //required this.searchString,
  });

  @override
  State<BuildMedicinesList> createState() => _BuildMedicinesListState();
}

class _BuildMedicinesListState extends State<BuildMedicinesList> {
  int indexOn = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemCount: widget.medicines.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        return ListTile(
          title: Text(
            widget.medicines[index].name,
            style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          subtitle: Text(
            "${widget.medicines[index].unit} - ${widget.medicines[index].form}",
            style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          onTap: () {
            setState(() {
              widget.contoller.text =
                  "${widget.medicines[index].name}%t${widget.medicines[index].unit}%t${widget.medicines[index].form}";
              Navigator.of(context).pop();
            });
          },
          trailing: Icon(
            Icons.arrow_forward,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        );
      },
    );
  }
}
