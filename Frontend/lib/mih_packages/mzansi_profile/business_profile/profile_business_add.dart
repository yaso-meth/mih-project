import 'dart:convert';

import 'package:http/http.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_location_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_my_business_user_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_header.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class ProfileBusinessAdd extends StatefulWidget {
  //final BusinessUserScreenArguments arguments;
  final AppUser signedInUser;
  const ProfileBusinessAdd({
    super.key,
    required this.signedInUser,
  });

  @override
  State<ProfileBusinessAdd> createState() => _ProfileBusinessAddState();
}

class _ProfileBusinessAddState extends State<ProfileBusinessAdd> {
  final FocusNode _focusNode = FocusNode();
  final baseAPI = AppEnviroment.baseApiUrl;

  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final regController = TextEditingController();
  final addressController = TextEditingController();
  final logonameController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final titleController = TextEditingController();
  final signtureController = TextEditingController();
  final accessController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final practiceNoController = TextEditingController();
  final vatNoController = TextEditingController();

  ImageProvider<Object>? logoPreview;
  ImageProvider<Object>? signaturePreview;
  PlatformFile? selectedLogo;
  PlatformFile? selectedSignature;

  final ValueNotifier<String> busType = ValueNotifier("");
  final _formKey = GlobalKey<FormState>();
  late String env;

  Future<bool> uploadFile(String id, PlatformFile? selectedFile) async {
    print("Inside uploud file method");
    int uploadStatusCode = 0;
    uploadStatusCode = await MihFileApi.uploadFile(
      id,
      env,
      "business_files",
      selectedFile,
      context,
    );
    print("Status code: $uploadStatusCode");
    if (uploadStatusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> createBusinessUserAPICall(String business_id) async {
    print("Inside create bus user method");
    int statusCode = await MihMyBusinessUserApi().createBusinessUser(
      business_id,
      widget.signedInUser.app_id,
      signtureController.text,
      titleController.text,
      accessController.text,
      context,
    );
    print("Status code: $statusCode");
    if (statusCode == 201) {
      Navigator.of(context).pop();
      Navigator.of(context).popAndPushNamed(
        '/',
        arguments: AuthArguments(false, false),
      );
      String message =
          "Your business profile is now live! You can now start connecting with customers and growing your business.";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> createBusinessProfileAPICall() async {
    print("Inside create business profile method");
    Response response = await MihBusinessDetailsApi().createBusinessDetails(
      widget.signedInUser.app_id,
      nameController.text,
      typeController.text,
      regController.text,
      practiceNoController.text,
      vatNoController.text,
      emailController.text,
      contactController.text,
      locationController.text,
      logonameController.text,
      context,
    );
    print(response.body);
    if (response.statusCode == 201) {
      var businessResponse = jsonDecode(response.body);
      createBusinessUserAPICall(businessResponse['business_id']);
    } else {
      internetConnectionPopUp();
    }
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void successPopUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MIHSuccessMessage(
          successType: "Success",
          successMessage: message,
        );
      },
    );
  }

  bool isFieldsFilled() {
    if (typeController.text.isEmpty ||
        titleController.text.isEmpty ||
        accessController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void submitForm() {
    if (isFieldsFilled()) {
      print("Inside submit method");
      createBusinessProfileAPICall();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    }
  }

  void emailError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Email");
      },
    );
  }

  bool isEmailValid() {
    String text = emailController.text;
    var regex = RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
    return regex.hasMatch(text);
  }

  // bool validEmail() {
  //   String text = emailController.text;
  //   var regex = RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
  //   return regex.hasMatch(text);
  // }

  void typeSelected() {
    if (typeController.text.isNotEmpty) {
      busType.value = typeController.text;
    } else {
      busType.value = "";
    }
  }

  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "Add Business Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  MIHBody getBody(double width) {
    return MIHBody(
      borderOn: false,
      bodyItems: [
        KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (event) async {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              if (_formKey.currentState!.validate()) {
                submitForm();
              } else {
                MihAlertServices().formNotFilledCompletely(context);
              }
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  MzanziInnovationHub.of(context)!.theme.screenType == "desktop"
                      ? EdgeInsets.symmetric(horizontal: width * 0.2)
                      : EdgeInsets.symmetric(horizontal: width * 0.075),
              child: Column(
                children: [
                  const Text(
                    "My Business Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Divider(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor()),
                  const SizedBox(height: 10.0),
                  MihForm(
                    formKey: _formKey,
                    formFields: [
                      MihTextFormField(
                        fillColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        inputColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        controller: regController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "Registration No.",
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        inputColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        controller: nameController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "Business Name",
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                      ),
                      const SizedBox(height: 15.0),
                      MihDropdownField(
                        controller: typeController,
                        hintText: "Business Type",
                        dropdownOptions: const ["Doctors Office", "Other"],
                        editable: true,
                        enableSearch: true,
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                        requiredText: true,
                      ),
                      const SizedBox(height: 10.0),
                      ValueListenableBuilder(
                        valueListenable: busType,
                        builder: (BuildContext context, String value,
                            Widget? child) {
                          return Visibility(
                            visible: value == "Doctors Office",
                            child: MihTextFormField(
                              fillColor: MzanziInnovationHub.of(context)!
                                  .theme
                                  .secondaryColor(),
                              inputColor: MzanziInnovationHub.of(context)!
                                  .theme
                                  .primaryColor(),
                              controller: practiceNoController,
                              multiLineInput: false,
                              requiredText: true,
                              hintText: "Practice Number",
                              validator: (validateValue) {
                                if (value == "Doctors Office") {
                                  return MihValidationServices()
                                      .isEmpty(validateValue);
                                }
                                return null;
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        inputColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        controller: vatNoController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "VAT Number",
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        inputColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        controller: contactController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "Contact Number",
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        inputColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        controller: emailController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "Business Email",
                        validator: (value) {
                          return MihValidationServices().validateEmail(value);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: MihTextFormField(
                              fillColor: MzanziInnovationHub.of(context)!
                                  .theme
                                  .secondaryColor(),
                              inputColor: MzanziInnovationHub.of(context)!
                                  .theme
                                  .primaryColor(),
                              controller: locationController,
                              multiLineInput: false,
                              requiredText: true,
                              hintText: "GPS Location",
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          MihButton(
                            onPressed: () {
                              MIHLocationAPI()
                                  .getGPSPosition(context)
                                  .then((position) {
                                if (position != null) {
                                  setState(() {
                                    locationController.text =
                                        "${position.latitude}, ${position.longitude}";
                                  });
                                }
                              });
                            },
                            buttonColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            width: 100,
                            child: Text(
                              "Set",
                              style: TextStyle(
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .primaryColor(),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      //const SizedBox(height: 15.0),
                      const Center(
                        child: Text(
                          "My Business User",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Divider(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor()),
                      const SizedBox(height: 10.0),
                      MihDropdownField(
                        controller: titleController,
                        hintText: "Title",
                        dropdownOptions: const ["Doctor", "Assistant", "Other"],
                        editable: true,
                        enableSearch: true,
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                        requiredText: true,
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        inputColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        controller: fnameController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "First Name",
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        inputColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        controller: lnameController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "Surname",
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                      ),
                      const SizedBox(height: 15.0),
                      MihDropdownField(
                        controller: accessController,
                        hintText: "Access Type",
                        dropdownOptions: const ["Full", "Partial"],
                        editable: true,
                        enableSearch: true,
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                        requiredText: true,
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: MihButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              submitForm();
                            } else {
                              MihAlertServices()
                                  .formNotFilledCompletely(context);
                            }
                          },
                          buttonColor: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          width: 300,
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: MzanziInnovationHub.of(context)!
                                  .theme
                                  .primaryColor(),
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
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    regController.dispose();
    logonameController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    titleController.dispose();
    signtureController.dispose();
    accessController.dispose();
    contactController.dispose();
    emailController.dispose();
    locationController.dispose();
    practiceNoController.dispose();
    vatNoController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    typeController.addListener(typeSelected);
    setState(() {
      fnameController.text = widget.signedInUser.fname;
      lnameController.text = widget.signedInUser.lname;
      accessController.text = "Full";
    });
    if (AppEnviroment.getEnv() == "Prod") {
      env = "Prod";
    } else {
      env = "Dev";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      secondaryActionButton: null,
      header: getHeader(),
      body: getBody(screenWidth),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }
}
