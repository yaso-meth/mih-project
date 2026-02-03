import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_objects/icd10_code.dart.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/list_builders/build_icd10_code_list.dart';
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
        MihTextFormField(
          fillColor: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          inputColor: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          controller: widget.icd10CodeController,
          multiLineInput: false,
          requiredText: true,
          numberMode: true,
          hintText: "ICD-10 Code Searched",
          validator: (value) {
            return MihValidationServices().isEmpty(value);
          },
        ),
        const SizedBox(height: 15),
        Text(
          "Search for ICD-10 Codes",
          style: TextStyle(
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark")),
        BuildICD10CodeList(
          icd10CodeController: widget.icd10CodeController,
          icd10codeList: widget.icd10codeList,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "ICD-10 Search",
      onWindowTapClose: () {
        // medicineController.clear();
        // quantityController.clear();
        // dosageController.clear();
        // timesDailyController.clear();
        // noDaysController.clear();
        // noRepeatsController.clear();
        Navigator.pop(context);
      },
      windowBody: getWindowBody(),
    );
  }
}
