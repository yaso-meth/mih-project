import 'dart:convert';

import 'package:http/http.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_business_details_apis.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_file_api.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_location_api.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_my_business_user_apis.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_header.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
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

  // Future<void> uploadSelectedFile(
  // PlatformFile file, TextEditingController controller) async {
  // var token = await supertokens.getaccesstoken();
  // var request = http2.multipartrequest(
  //     'post', uri.parse("${appenviroment.baseapiurl}/minio/upload/file/"));
  // request.headers['accept'] = 'application/json';
  // request.headers['authorization'] = 'bearer $token';
  // request.headers['content-type'] = 'multipart/form-data';
  // request.fields['app_id'] = widget.signedinuser.app_id;
  // request.fields['folder'] = "business_files";
  // request.files.add(await http2.multipartfile.frombytes('file', file.bytes!,
  //     filename: file.name.replaceall(regexp(r' '), '-')));
  // var response1 = await request.send();
  // if (response1.statuscode == 200) {
  // } else {
  //   internetconnectionpopup();
  // }
  // }

  Future<bool> uploadFile(String id, PlatformFile? selectedFile) async {
    print("Inside uploud file method");
    int uploadStatusCode = 0;
    uploadStatusCode = await MihFileApi.uploadFile(
      id,
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
    // var response = await http.post(
    //   Uri.parse("$baseAPI/business-user/insert/"),
    //   headers: <String, String>{
    //     "Content-Type": "application/json; charset=UTF-8"
    //   },
    //   body: jsonEncode(<String, dynamic>{
    //     "business_id": business_id,
    //     "app_id": widget.signedInUser.app_id,
    //     "signature": signtureController.text,
    //     "sig_path":
    //         "${widget.signedInUser.app_id}/business_files/${signtureController.text}",
    //     "title": titleController.text,
    //     "access": accessController.text,
    //   }),
    // );
    print("Status code: $statusCode");
    if (statusCode == 201) {
      // uploadSelectedFile(selectedSignature, signtureController);
      // bool successfullyUploadedFile =
      //     await uploadFile(business_id, selectedSignature);
      // if (successfullyUploadedFile) {
      Navigator.of(context).pop();
      Navigator.of(context).popAndPushNamed(
        '/',
        arguments: AuthArguments(false, false),
      );
      String message =
          "Your business profile is now live! You can now start connecting with customers and growing your business.";
      successPopUp(message);
      // } else {
      //   internetConnectionPopUp();
      // }
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
    // var response = await http.post(
    //   Uri.parse("$baseAPI/business/insert/"),
    //   headers: <String, String>{
    //     "Content-Type": "application/json; charset=UTF-8"
    //   },
    //   body: jsonEncode(<String, dynamic>{
    //     "Name": nameController.text,
    //     "type": typeController.text,
    //     "registration_no": regController.text,
    //     "logo_name": logonameController.text,
    //     "logo_path":
    //         "${widget.signedInUser.app_id}/business_files/${logonameController.text}",
    //     "contact_no": contactController.text,
    //     "bus_email": emailController.text,
    //     "gps_location": locationController.text,
    //     "practice_no": practiceNoController.text,
    //     "vat_no": vatNoController.text,
    //   }),
    // );
    print(response.body);
    if (response.statusCode == 201) {
      var businessResponse = jsonDecode(response.body);
      // bool successfullyUploadedFile =
      //     await uploadFile(widget.signedInUser.app_id, selectedSignature);
      // if (successfullyUploadedFile) {
      createBusinessUserAPICall(businessResponse['business_id']);
      // } else {
      //   internetConnectionPopUp();
      // }
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
    if (nameController.text.isEmpty ||
        typeController.text.isEmpty ||
        regController.text.isEmpty ||
        // logonameController.text.isEmpty ||
        fnameController.text.isEmpty ||
        lnameController.text.isEmpty ||
        titleController.text.isEmpty ||
        // signtureController.text.isEmpty ||
        accessController.text.isEmpty ||
        contactController.text.isEmpty ||
        emailController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void submitForm() {
    if (!isEmailValid()) {
      emailError();
    } else if (isFieldsFilled()) {
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

  MIHBody getBody() {
    return MIHBody(
      borderOn: true,
      bodyItems: [
        KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (event) async {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              submitForm();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                //const SizedBox(height: 15),
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
                // MihCircleAvatar(
                //   imageFile: logoPreview,
                //   width: 150,
                //   editable: true,
                //   fileNameController: logonameController,
                //   userSelectedfile: selectedLogo,
                //   frameColor:
                //       MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                //   backgroundColor:
                //       MzanziInnovationHub.of(context)!.theme.primaryColor(),
                //   onChange: (selectedfile) {
                //     setState(() {
                //       selectedLogo = selectedfile;
                //     });
                //   },
                // ),
                // const SizedBox(height: 10.0),
                // Visibility(
                //   visible: true,
                //   child: MIHTextField(
                //     controller: logonameController,
                //     hintText: "Selected Logo File Name",
                //     editable: false,
                //     required: true,
                //   ),
                // ),
                // const SizedBox(height: 10.0),
                MIHTextField(
                  controller: regController,
                  hintText: "Registration No.",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: nameController,
                  hintText: "Business Name",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MIHDropdownField(
                  controller: typeController,
                  hintText: "Business Type",
                  dropdownOptions: const ["Doctors Office", "Other"],
                  required: true,
                  editable: true,
                  enableSearch: false,
                ),
                const SizedBox(height: 10.0),
                ValueListenableBuilder(
                  valueListenable: busType,
                  builder: (BuildContext context, String value, Widget? child) {
                    return Visibility(
                      visible: value == "Doctors Office",
                      child: MIHTextField(
                        controller: practiceNoController,
                        hintText: "Practice Number",
                        editable: true,
                        required: true,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: vatNoController,
                  hintText: "VAT Number",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: contactController,
                  hintText: "Contact Number",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: emailController,
                  hintText: "Email",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                // MIHFileField(
                //   controller: logonameController,
                //   hintText: "Logo",
                //   editable: false,
                //   required: true,
                //   onPressed: () async {
                //     FilePickerResult? result =
                //         await FilePicker.platform.pickFiles(
                //       type: FileType.custom,
                //       allowedExtensions: ['jpg', 'png', 'pdf'],
                //     );
                //     if (result == null) return;
                //     final selectedFile = result.files.first;
                //     setState(() {
                //       selectedLogo = selectedFile;
                //     });
                //     setState(() {
                //       logonameController.text = selectedFile.name;
                //     });
                //   },
                // ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Flexible(
                      child: MIHTextField(
                        controller: locationController,
                        hintText: "Location",
                        editable: false,
                        required: false,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    SizedBox(
                      width: 80.0,
                      height: 50.0,
                      child: MIHButton(
                        buttonText: "Set",
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        onTap: () {
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
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15.0),
                Divider(
                  color:
                      MzanziInnovationHub.of(context)?.theme.secondaryColor(),
                ),
                //const SizedBox(height: 15.0),
                const Text(
                  "My Business User",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Divider(
                    color: MzanziInnovationHub.of(context)!
                        .theme
                        .secondaryColor()),
                const SizedBox(height: 10.0),
                MIHDropdownField(
                  controller: titleController,
                  hintText: "Title",
                  dropdownOptions: const ["Doctor", "Assistant"],
                  required: true,
                  editable: true,
                  enableSearch: false,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: fnameController,
                  hintText: "Name",
                  editable: false,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: lnameController,
                  hintText: "Surname",
                  editable: false,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                // const SizedBox(height: 10),
                // Container(
                //   width: 300,
                //   alignment: Alignment.topLeft,
                //   child: const Text(
                //     "Signature:",
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // MihImageDisplay(
                //   imageFile: signaturePreview,
                //   width: 300,
                //   editable: true,
                //   fileNameController: signtureController,
                //   userSelectedfile: selectedSignature,
                //   onChange: (selectedFile) {
                //     setState(() {
                //       selectedSignature = selectedFile;
                //     });
                //   },
                // ),
                // const SizedBox(height: 10.0),
                // MIHTextField(
                //   controller: signtureController,
                //   hintText: "Selected Signature File Name",
                //   editable: false,
                //   required: true,
                // ),
                const SizedBox(height: 10.0),
                // MIHFileField(
                //   controller: signtureController,
                //   hintText: "Signature",
                //   editable: false,
                //   required: true,
                //   onPressed: () async {
                //     FilePickerResult? result =
                //         await FilePicker.platform.pickFiles(
                //       type: FileType.custom,
                //       allowedExtensions: ['jpg', 'png', 'pdf'],
                //     );
                //     if (result == null) return;
                //     final selectedFile = result.files.first;
                //     setState(() {
                //       selectedSignature = selectedFile;
                //     });
                //     setState(() {
                //       signtureController.text = selectedFile.name;
                //     });
                //   },
                // ),
                const SizedBox(height: 15.0),
                MIHDropdownField(
                  controller: accessController,
                  hintText: "Access",
                  dropdownOptions: const ["Full", "Partial"],
                  required: true,
                  editable: false,
                  enableSearch: false,
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: 500.0,
                  height: 50.0,
                  child: MIHButton(
                    buttonText: "Add",
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    textColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    onTap: () {
                      submitForm();
                    },
                  ),
                ),
              ],
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      secondaryActionButton: null,
      header: getHeader(),
      body: getBody(),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }
}
