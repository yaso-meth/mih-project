import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_window.dart';
import 'package:mzansi_innovation_hub/mih_objects/icd10_code.dart.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/list_builders/build_icd10_code_list.dart';
import 'package:flutter/material.dart';

class ICD10SearchWindow extends StatefulWidget {
  final TextEditingController icd10CodeController;
  final List<ICD10Code> icd10codeList;
  const ICD10SearchWindow({
    super.key,
    required this.icd10CodeController,
    required this.icd10codeList,
  });

  @override
  State<ICD10SearchWindow> createState() => _ICD10SearchWindowState();
}

class _ICD10SearchWindowState extends State<ICD10SearchWindow> {
  Widget getWindowBody() {
    return Column(
      children: [
        MIHTextField(
          controller: widget.icd10CodeController,
          hintText: "Search Text",
          editable: false,
          required: false,
        ),
        BuildICD10CodeList(
          icd10CodeController: widget.icd10CodeController,
          icd10codeList: widget.icd10codeList,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MIHWindow(
      fullscreen: false,
      windowTitle: "ICD-10 Search",
      windowTools: const [],
      onWindowTapClose: () {
        // medicineController.clear();
        // quantityController.clear();
        // dosageController.clear();
        // timesDailyController.clear();
        // noDaysController.clear();
        // noRepeatsController.clear();
        Navigator.pop(context);
      },
      windowBody: [
        getWindowBody(),
      ],
    );
  }
}
