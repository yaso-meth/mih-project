import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_claim_statement_generation_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_icd10_code_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_date_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_radio_options.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/icd10_code.dart.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/components/icd10_search_window.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClaimStatementWindow extends StatefulWidget {
  final Patient selectedPatient;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final String env;
  const ClaimStatementWindow({
    super.key,
    required this.selectedPatient,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.env,
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
  final FocusNode _searchFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

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

  Widget getWindowBody(double width) {
    return Padding(
      padding: MzanziInnovationHub.of(context)!.theme.screenType == "desktop"
          ? EdgeInsets.symmetric(horizontal: width * 0.05)
          : const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          MihForm(
            formKey: _formKey,
            formFields: [
              MihRadioOptions(
                controller: _docTypeController,
                hintText: "Document Type",
                fillColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                secondaryFillColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                requiredText: true,
                radioOptions: const ["Claim", "Statement"],
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Service Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ),
              Divider(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor()),
              const SizedBox(height: 10),
              MihDateField(
                controller: _serviceDateController,
                labelText: "Date of Service",
                required: true,
                validator: (value) {
                  return MihValidationServices().isEmpty(value);
                },
              ),
              const SizedBox(height: 10),
              MihRadioOptions(
                controller: _serviceDescController,
                hintText: "Serviced Description",
                fillColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                secondaryFillColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                requiredText: true,
                radioOptions: const [
                  "Consultation",
                  "Procedure",
                  "Other",
                ],
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: serviceDesc,
                builder: (BuildContext context, String value, Widget? child) {
                  Widget returnWidget;
                  switch (value) {
                    case 'Consultation':
                      returnWidget = Column(
                        key: const ValueKey('consultation_fields'), // Added key
                        children: [
                          MihRadioOptions(
                            key: const ValueKey('consultation_type_dropdown'),
                            controller: _serviceDescOptionsController,
                            hintText: "Consultation Type",
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            secondaryFillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
                            requiredText: true,
                            radioOptions: const [
                              "General Consultation",
                              "Follow-Up Consultation",
                              "Specialist Consultation",
                              "Emergency Consultation",
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                      break;
                    case 'Procedure':
                      returnWidget = Column(
                        key: const ValueKey('procedure_fields'), // Added key
                        children: [
                          MihTextFormField(
                            key: const ValueKey(
                                'procedure_name_field'), // Added key
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
                            controller: _prcedureNameController,
                            multiLineInput: false,
                            requiredText: true,
                            hintText: "Procedure Name",
                            validator: (value) {
                              return MihValidationServices().isEmpty(value);
                            },
                          ),
                          const SizedBox(height: 10),
                          MihTextFormField(
                            key: const ValueKey(
                                'procedure_additional_info_field'), // Added key
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
                            controller: _proceedureAdditionalInfoController,
                            multiLineInput: false,
                            requiredText: true,
                            hintText: "Additional Procedure Information",
                            validator: (value) {
                              return MihValidationServices().isEmpty(value);
                            },
                          ),
                          const SizedBox(height: 15),
                        ],
                      );
                      break;
                    case 'Other':
                      returnWidget = Column(
                        key: const ValueKey('other_fields'), // Added key
                        children: [
                          MihTextFormField(
                            key: const ValueKey(
                                'other_service_description_field'), // Added key
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
                            controller: _serviceDescOptionsController,
                            multiLineInput: false,
                            requiredText: true,
                            hintText: "Service Description Details",
                            validator: (value) {
                              return MihValidationServices().isEmpty(value);
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                      break;
                    default:
                      returnWidget = const SizedBox(
                          key: const ValueKey('empty_fields')); // Added key
                  }
                  return returnWidget;
                },
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ICD-10 Code & Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                        )),
                  ),
                  const SizedBox(height: 4),
                  MihSearchBar(
                    controller: _icd10CodeController,
                    hintText: "ICD-10 Search",
                    prefixIcon: Icons.search,
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    hintColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    onPrefixIconTap: () {
                      MIHIcd10CodeApis.getIcd10Codes(
                              _icd10CodeController.text, context)
                          .then((result) {
                        icd10SearchWindow(result);
                      });
                    },
                    onClearIconTap: () {
                      _icd10CodeController.clear();
                    },
                    searchFocusNode: _searchFocusNode,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              MihTextFormField(
                fillColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                inputColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                controller: _amountController,
                multiLineInput: false,
                requiredText: true,
                numberMode: true,
                hintText: "Service Cost",
                validator: (value) {
                  return MihValidationServices().isEmpty(value);
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Additional Infomation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ),
              Divider(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor()),
              const SizedBox(height: 10),
              MihTextFormField(
                fillColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                inputColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                controller: _preauthNoController,
                multiLineInput: false,
                requiredText: false,
                hintText: "Pre-authorisation No.",
              ),
              const SizedBox(height: 20),
              Center(
                child: MihButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
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
                            widget.env,
                            context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const MIHErrorMessage(
                                errorType: "Input Error");
                          },
                        );
                      }
                    } else {
                      MihAlertServices().formNotFilledCompletely(context);
                    }
                  },
                  buttonColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  width: 300,
                  child: Text(
                    "Generate",
                    style: TextStyle(
                      color:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void serviceDescriptionSelected() {
    String selectedType = _serviceDescController.text;
    serviceDesc.value = selectedType;
    if (selectedType == 'Consultation') {
      _prcedureNameController.clear();
      _proceedureAdditionalInfoController.clear();
    } else if (selectedType == 'Procedure') {
      _serviceDescOptionsController.clear();
    } else if (selectedType == 'Other') {
      _prcedureNameController.clear();
      _proceedureAdditionalInfoController.clear();
    } else {
      _prcedureNameController.clear();
      _proceedureAdditionalInfoController.clear();
      _serviceDescOptionsController.clear();
    }
  }

  void hasMedAid() {
    if (_medAidController.text.isNotEmpty) {
    } else {
      medAid.value = "";
    }
  }

  bool isInputValid() {
    if (_docTypeController.text.isEmpty ||
        _serviceDateController.text.isEmpty ||
        _icd10CodeController.text.isEmpty ||
        _amountController.text.isEmpty) {
      return false;
    }
    switch (_serviceDescController.text) {
      case 'Consultation':
      case 'Other':
        if (_serviceDescOptionsController.text.isEmpty) {
          return false;
        }
        break;
      case 'Procedure':
        if (_prcedureNameController.text.isEmpty ||
            _proceedureAdditionalInfoController.text.isEmpty) {
          return false;
        }
        break;
      default:
        return false;
    }
    return true;
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
    _searchFocusNode.dispose();
    serviceDesc.dispose();
    medAid.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _serviceDescController.text = "Consultation";
    _serviceDescController.addListener(serviceDescriptionSelected);
    serviceDesc.value = "Consultation";
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
    hasMedAid();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "Generate Claim/ Statement Document",
      onWindowTapClose: () {
        Navigator.pop(context);
      },
      windowBody: getWindowBody(screenWidth),
    );
  }
}
