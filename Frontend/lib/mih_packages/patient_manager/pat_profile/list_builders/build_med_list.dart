import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/medicine.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

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
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
      itemCount: widget.medicines.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        return ListTile(
          title: Text(
            widget.medicines[index].name,
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
          ),
          subtitle: Text(
            "${widget.medicines[index].unit} - ${widget.medicines[index].form}",
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
        );
      },
    );
  }
}
