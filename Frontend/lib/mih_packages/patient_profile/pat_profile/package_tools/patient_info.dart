import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';
import 'package:flutter/material.dart';

class PatientInfo extends StatefulWidget {
  final AppUser signedInUser;
  final Patient selectedPatient;
  final String type;
  const PatientInfo({
    super.key,
    required this.signedInUser,
    required this.selectedPatient,
    required this.type,
  });

  @override
  State<PatientInfo> createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  final idController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final cellController = TextEditingController();
  final emailController = TextEditingController();
  final medNoController = TextEditingController();
  final medNameController = TextEditingController();
  final medSchemeController = TextEditingController();
  final addressController = TextEditingController();
  final medAidController = TextEditingController();
  final medMainMemController = TextEditingController();
  final medAidCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double textFieldWidth = 400.0;
  late String medAid;

  Widget getPatientDetailsField() {
    return Center(
      child: Wrap(
        spacing: 15,
        runSpacing: 10,
        children: [
          MihTextFormField(
            width: textFieldWidth,
            fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            controller: idController,
            multiLineInput: false,
            requiredText: true,
            readOnly: true,
            hintText: "ID No.",
            // validator: (value) {
            //   return MihValidationServices().isEmpty(value);
            // },
          ),
          MihTextFormField(
            width: textFieldWidth,
            fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            controller: fnameController,
            multiLineInput: false,
            requiredText: true,
            readOnly: true,
            hintText: "First Name",
          ),
          MihTextFormField(
            width: textFieldWidth,
            fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            controller: lnameController,
            multiLineInput: false,
            requiredText: true,
            hintText: "Surname",
            readOnly: true,
          ),
          MihTextFormField(
            width: textFieldWidth,
            fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            controller: cellController,
            multiLineInput: false,
            requiredText: true,
            readOnly: true,
            hintText: "Cell No.",
          ),
          MihTextFormField(
            width: textFieldWidth,
            fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            controller: emailController,
            multiLineInput: false,
            requiredText: true,
            readOnly: true,
            hintText: "Email",
          ),
          MihTextFormField(
            width: textFieldWidth,
            height: 100,
            fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            controller: addressController,
            multiLineInput: true,
            requiredText: true,
            readOnly: true,
            hintText: "Address",
          ),
        ],
      ),
    );
  }

  Widget getMedAidDetailsFields() {
    List<Widget> medAidDet = [];
    medAidDet.add(
      MihTextFormField(
        width: textFieldWidth,
        fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        controller: medAidController,
        multiLineInput: false,
        requiredText: true,
        readOnly: true,
        hintText: "Medical Aid",
      ),
    );
    bool req;
    if (medAid == "Yes") {
      req = true;
    } else {
      req = false;
    }
    medAidDet.addAll([
      Visibility(
        visible: req,
        child: MihTextFormField(
          width: textFieldWidth,
          fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          controller: medMainMemController,
          multiLineInput: false,
          requiredText: true,
          readOnly: true,
          hintText: "Main Member",
        ),
      ),
      Visibility(
        visible: req,
        child: MihTextFormField(
          width: textFieldWidth,
          fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          controller: medNoController,
          multiLineInput: false,
          requiredText: true,
          readOnly: true,
          hintText: "No.",
        ),
      ),
      Visibility(
        visible: req,
        child: MihTextFormField(
          width: textFieldWidth,
          fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          controller: medAidCodeController,
          multiLineInput: false,
          requiredText: true,
          readOnly: true,
          hintText: "Code",
        ),
      ),
      Visibility(
        visible: req,
        child: MihTextFormField(
          width: textFieldWidth,
          fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          controller: medNameController,
          multiLineInput: false,
          requiredText: true,
          readOnly: true,
          hintText: "Name",
        ),
      ),
      Visibility(
        visible: req,
        child: MihTextFormField(
          width: textFieldWidth,
          fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          controller: medSchemeController,
          multiLineInput: false,
          requiredText: true,
          readOnly: true,
          hintText: "Plan",
        ),
      ),
    ]);
    return Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: medAidDet,
      ),
    );
  }

  @override
  void dispose() {
    idController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    cellController.dispose();
    emailController.dispose();
    medNameController.dispose();
    medNoController.dispose();
    medSchemeController.dispose();
    addressController.dispose();
    medAidController.dispose();
    medMainMemController.dispose();
    medAidCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      idController.value = TextEditingValue(text: widget.selectedPatient.id_no);
      fnameController.value =
          TextEditingValue(text: widget.selectedPatient.first_name);
      lnameController.value =
          TextEditingValue(text: widget.selectedPatient.last_name);
      cellController.value =
          TextEditingValue(text: widget.selectedPatient.cell_no);
      emailController.value =
          TextEditingValue(text: widget.selectedPatient.email);
      medNameController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_name);
      medNoController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_no);
      medSchemeController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_scheme);
      addressController.value =
          TextEditingValue(text: widget.selectedPatient.address);
      medAidController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid);
      medMainMemController.value = TextEditingValue(
          text: widget.selectedPatient.medical_aid_main_member);
      medAidCodeController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_code);
      medAid = widget.selectedPatient.medical_aid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MihForm(
                formKey: _formKey,
                formFields: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: ,
                      children: [
                        Text(
                          "Personal",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                          ),
                        ),
                      ]),
                  Divider(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor()),
                  const SizedBox(height: 10),
                  getPatientDetailsField(),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Medical Aid",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                    ),
                  ),
                  Divider(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor()),
                  const SizedBox(height: 10),
                  getMedAidDetailsFields(),
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.type == "personal",
          child: Positioned(
            right: 10,
            bottom: 10,
            child: MihFloatingMenu(
              icon: Icons.add,
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.edit,
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  label: "Edit Profile",
                  labelBackgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  labelStyle: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  onTap: () {
                    Navigator.of(context).pushNamed('/patient-profile/edit',
                        arguments: PatientEditArguments(
                            widget.signedInUser, widget.selectedPatient));
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
