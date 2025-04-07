import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/icd10_code.dart.dart';
import 'package:flutter/material.dart';

class BuildICD10CodeList extends StatefulWidget {
  final TextEditingController icd10CodeController;
  final List<ICD10Code> icd10codeList;

  const BuildICD10CodeList({
    super.key,
    required this.icd10CodeController,
    required this.icd10codeList,
  });

  @override
  State<BuildICD10CodeList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildICD10CodeList> {
  String baseAPI = AppEnviroment.baseApiUrl;
  int counter = 0;

  Widget displayCode(int index) {
    String title = "ICD-10 Code: ${widget.icd10codeList[index].icd10}";
    String description =
        "Description: ${widget.icd10codeList[index].description}";
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          text: description,
          style: DefaultTextStyle.of(context).style,
        ),
      ),
      onTap: () {
        //select code
        setState(() {
          widget.icd10CodeController.text =
              "${widget.icd10codeList[index].icd10} - ${widget.icd10codeList[index].description}";
        });
        Navigator.of(context).pop();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemCount: widget.icd10codeList.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        //print(index);
        return displayCode(index);
      },
    );
  }
}
