import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_apis/mih_claim_statement_generation_api.dart';
import 'package:Mzansi_Innovation_Hub/mih_apis/mih_icd10_code_api.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_date_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_search_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_window.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/icd10_code.dart.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/patients.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/icd10_search_window.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClaimStatementWindow extends StatefulWidget {
  final Patient selectedPatient;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  const ClaimStatementWindow({
    super.key,
    required this.selectedPatient,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
  });

  @override
  State<ClaimStatementWindow> createState() => _ClaimStatementWindowState();
}

class _ClaimStatementWindowState extends State<ClaimStatementWindow> {
  final TextEditingController _docTypeController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _medAidController = TextEditingController();
  final TextEditingController _medAidNoController = TextEditingController();
  final TextEditingController _medAidCodeController = TextEditingController();
  final TextEditingController _medAidNameController = TextEditingController();
  final TextEditingController _medAidSchemeController = TextEditingController();
  final TextEditingController _providerNameController = TextEditingController();
  final TextEditingController _practiceNoController = TextEditingController();
  final TextEditingController _vatNoController = TextEditingController();
  final TextEditingController _serviceDateController = TextEditingController();
  final TextEditingController _serviceDescController = TextEditingController();
  final TextEditingController _serviceDescOptionsController =
      TextEditingController();
  final TextEditingController _prcedureNameController = TextEditingController();
  // final TextEditingController _procedureDateController =
  //     TextEditingController();
  final TextEditingController _proceedureAdditionalInfoController =
      TextEditingController();
  final TextEditingController _icd10CodeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _preauthNoController = TextEditingController();
  final ValueNotifier<String> serviceDesc = ValueNotifier("");
  final ValueNotifier<String> medAid = ValueNotifier("");
  List<ICD10Code> icd10codeList = [];

  void icd10SearchWindow(List<ICD10Code> codeList) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ICD10SearchWindow(
        icd10CodeController: _icd10CodeController,
        icd10codeList: codeList,
      ),
    );
  }

  Widget getWindowBody() {
    return Column(
      children: [
        MIHDropdownField(
          controller: _docTypeController,
          hintText: "Document Type",
          dropdownOptions: const ["Claim", "Statement"],
          required: true,
          editable: true,
        ),
        const SizedBox(height: 10),
        // Text(
        //   "Patient Details",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.bold,
        //     color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        //   ),
        // ),
        // Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        // const SizedBox(height: 10),
        // MIHTextField(
        //   controller: _fullNameController,
        //   hintText: "Full Name",
        //   editable: false,
        //   required: true,
        // ),
        // const SizedBox(height: 10),
        // MIHTextField(
        //   controller: _idController,
        //   hintText: "ID No.",
        //   editable: false,
        //   required: true,
        // ),
        // const SizedBox(height: 10),
        // MIHTextField(
        //   controller: _medAidController,
        //   hintText: "Has Medical Aid",
        //   editable: false,
        //   required: true,
        // ),
        // const SizedBox(height: 10),
        // ValueListenableBuilder(
        //   valueListenable: serviceDesc,
        //   builder: (BuildContext context, String value, Widget? child) {
        //     return Visibility(
        //       visible: value == "Yes",
        //       child: Column(
        //         children: [
        //           MIHTextField(
        //             controller: _medAidNoController,
        //             hintText: "Medical Aid No.",
        //             editable: false,
        //             required: true,
        //           ),
        //           const SizedBox(height: 10),
        //           MIHTextField(
        //             controller: _medAidCodeController,
        //             hintText: "Medical Aid Code",
        //             editable: false,
        //             required: true,
        //           ),
        //           const SizedBox(height: 10),
        //           MIHTextField(
        //             controller: _medAidNameController,
        //             hintText: "Medical Aid Name",
        //             editable: false,
        //             required: true,
        //           ),
        //           const SizedBox(height: 10),
        //           MIHTextField(
        //             controller: _medAidSchemeController,
        //             hintText: "Medical Aid Scheme",
        //             editable: false,
        //             required: true,
        //           ),
        //           const SizedBox(height: 10),
        //         ],
        //       ),
        //     );
        //   },
        // ),
        // Text(
        //   "Provider Details",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.bold,
        //     color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        //   ),
        // ),
        // Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        // const SizedBox(height: 10),
        // MIHTextField(
        //   controller: _providerNameController,
        //   hintText: "Provider Name",
        //   editable: false,
        //   required: true,
        // ),
        // const SizedBox(height: 10),
        // MIHTextField(
        //   controller: _practiceNoController,
        //   hintText: "Practice No.",
        //   editable: false,
        //   required: true,
        // ),
        // const SizedBox(height: 10),
        // MIHTextField(
        //   controller: _vatNoController,
        //   hintText: "VAT No.",
        //   editable: false,
        //   required: true,
        // ),
        // const SizedBox(height: 10),
        Text(
          "Service Details",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        const SizedBox(height: 10),
        MIHDateField(
          controller: _serviceDateController,
          lableText: "Date of Service",
          required: true,
        ),
        const SizedBox(height: 10),
        MIHDropdownField(
          controller: _serviceDescController,
          hintText: "Service Decription",
          dropdownOptions: const [
            "Consultation",
            "Procedure",
            "Other",
          ],
          required: true,
          editable: true,
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder(
          valueListenable: serviceDesc,
          builder: (BuildContext context, String value, Widget? child) {
            Widget returnWidget;
            switch (value) {
              case 'Consultation':
                returnWidget = Column(
                  children: [
                    MIHDropdownField(
                      controller: _serviceDescOptionsController,
                      hintText: "Service Decription Options",
                      dropdownOptions: const [
                        "General Consultation",
                        "Follow-Up Consultation",
                        "Specialist Consultation",
                        "Emergency Consultation",
                      ],
                      required: true,
                      editable: true,
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              case 'Procedure':
                returnWidget = Column(
                  children: [
                    MIHTextField(
                      controller: _prcedureNameController,
                      hintText: "Procedure Name",
                      editable: true,
                      required: true,
                    ),
                    const SizedBox(height: 10),
                    // MIHDateField(
                    //   controller: _procedureDateController,
                    //   lableText: "Procedure Date",
                    //   required: true,
                    // ),
                    // const SizedBox(height: 10),
                    MIHTextField(
                      controller: _proceedureAdditionalInfoController,
                      hintText: "Additional Information",
                      editable: true,
                      required: true,
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              case 'Other':
                returnWidget = Column(
                  children: [
                    MIHTextField(
                      controller: _serviceDescOptionsController,
                      hintText: "Service Decription text",
                      editable: false,
                      required: true,
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              default:
                returnWidget = const SizedBox();
            }
            return returnWidget;
          },
        ),
        //const SizedBox(height: 10),
        MIHSearchField(
          controller: _icd10CodeController,
          hintText: "ICD-10 Code & Description",
          required: true,
          editable: true,
          onTap: () {
            //api
            MIHIcd10CodeApis.getIcd10Codes(_icd10CodeController.text, context)
                .then((result) {
              icd10SearchWindow(result);
            });
          },
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: _amountController,
          hintText: "Amount",
          editable: true,
          required: true,
        ),
        Text(
          "Additional Infomation",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        const SizedBox(height: 10),
        MIHTextField(
          controller: _preauthNoController,
          hintText: "Pre-authorisation No.",
          editable: true,
          required: false,
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: 500,
          height: 50,
          child: MIHButton(
            onTap: () {
              //generate document and uploud it
              if (isInputValid()) {
                MIHClaimStatementGenerationApi().generateClaimStatement(
                    ClaimStatementGenerationArguments(
                      _docTypeController.text,
                      widget.selectedPatient.app_id,
                      _fullNameController.text,
                      _idController.text,
                      _medAidController.text,
                      _medAidNoController.text,
                      _medAidCodeController.text,
                      _medAidNameController.text,
                      _medAidSchemeController.text,
                      widget.business!.Name,
                      "*To-Be Added*",
                      widget.business!.contact_no,
                      widget.business!.bus_email,
                      _providerNameController.text,
                      _practiceNoController.text,
                      _vatNoController.text,
                      _serviceDateController.text,
                      _serviceDescController.text,
                      _serviceDescOptionsController.text,
                      _prcedureNameController.text,
                      _proceedureAdditionalInfoController.text,
                      _icd10CodeController.text,
                      _amountController.text,
                      _preauthNoController.text,
                      widget.business!.logo_path,
                      widget.businessUser!.sig_path,
                    ),
                    PatientViewArguments(
                      widget.signedInUser,
                      widget.selectedPatient,
                      widget.businessUser,
                      widget.business,
                      "business",
                    ),
                    context);
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const MIHErrorMessage(errorType: "Input Error");
                  },
                );
              }
            },
            buttonText: "Generate",
            buttonColor:
                MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          ),
        )
      ],
    );
  }

  void serviceDescriptionSelected() {
    if (_serviceDescController.text.isNotEmpty) {
      serviceDesc.value = _serviceDescController.text;
    } else {
      serviceDesc.value = "";
    }
  }

  void hasMedAid() {
    if (_medAidController.text.isNotEmpty) {
      medAid.value = _medAidController.text;
    } else {
      medAid.value = "";
    }
  }

  bool isInputValid() {
    switch (_serviceDescController.text) {
      case 'Procedure':
        if (_docTypeController.text.isEmpty ||
            _serviceDateController.text.isEmpty ||
            _icd10CodeController.text.isEmpty ||
            _amountController.text.isEmpty ||
            _prcedureNameController.text.isEmpty ||
            _proceedureAdditionalInfoController.text.isEmpty) {
          return false;
        } else {
          return true;
        }
      default:
        if (_docTypeController.text.isEmpty ||
            _serviceDateController.text.isEmpty ||
            _icd10CodeController.text.isEmpty ||
            _amountController.text.isEmpty ||
            _serviceDescOptionsController.text.isEmpty) {
          return false;
        } else {
          return true;
        }
    }
  }

  String getUserTitle() {
    if (widget.businessUser!.title == "Doctor") {
      return "Dr.";
    } else {
      return widget.businessUser!.title;
    }
  }

  String getTodayDate() {
    DateTime today = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(today);
  }

  @override
  void dispose() {
    _docTypeController.dispose();
    _fullNameController.dispose();
    _idController.dispose();
    _medAidController.dispose();
    _medAidNoController.dispose();
    _medAidCodeController.dispose();
    _medAidNameController.dispose();
    _medAidSchemeController.dispose();
    _providerNameController.dispose();
    _practiceNoController.dispose();
    _vatNoController.dispose();
    _serviceDateController.dispose();
    _serviceDescController.dispose();
    _serviceDescOptionsController.dispose();
    _prcedureNameController.dispose();
    // _procedureDateController.dispose();
    _proceedureAdditionalInfoController.dispose();
    _icd10CodeController.dispose();
    _preauthNoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _serviceDescController.addListener(serviceDescriptionSelected);
    _medAidController.addListener(hasMedAid);
    _fullNameController.text =
        "${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}";
    _idController.text = widget.selectedPatient.id_no;
    _medAidController.text = widget.selectedPatient.medical_aid;
    _medAidNameController.text = widget.selectedPatient.medical_aid_name;
    _medAidCodeController.text = widget.selectedPatient.medical_aid_code;
    _medAidNoController.text = widget.selectedPatient.medical_aid_no;
    _medAidSchemeController.text = widget.selectedPatient.medical_aid_scheme;
    _serviceDateController.text = getTodayDate();
    _providerNameController.text =
        "${getUserTitle()} ${widget.signedInUser.fname} ${widget.signedInUser.lname}";
    _practiceNoController.text = widget.business!.practice_no;
    _vatNoController.text = widget.business!.vat_no;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MIHWindow(
      fullscreen: false,
      windowTitle: "Generate Claim/ Statement Document",
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
