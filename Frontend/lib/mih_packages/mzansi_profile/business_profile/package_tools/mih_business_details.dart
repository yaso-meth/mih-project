import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_business_details_apis.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_file_api.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_location_api.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih-app_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';

class MihBusinessDetails extends StatefulWidget {
  final BusinessArguments arguments;
  const MihBusinessDetails({
    super.key,
    required this.arguments,
  });

  @override
  State<MihBusinessDetails> createState() => _MihBusinessDetailsState();
}

class _MihBusinessDetailsState extends State<MihBusinessDetails> {
  late Future<String> fileUrlFuture;
  PlatformFile? imageFile;
  final fileNameController = TextEditingController();
  final regController = TextEditingController();
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final practiceNoController = TextEditingController();
  final vatNoController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();

  Future<void> submitForm() async {
    if (!isEmailValid()) {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Invalid Email");
        },
      );
    } else if (isFormFilled()) {
      int statusCode = 0;
      statusCode = await MihBusinessDetailsApi().updateBusinessDetails(
        widget.arguments.business!.business_id,
        nameController.text,
        typeController.text,
        regController.text,
        practiceNoController.text,
        vatNoController.text,
        emailController.text,
        contactController.text,
        locationController.text,
        fileNameController.text,
        context,
      );
      if (statusCode == 200) {
        bool successfullyUploadedFile = await uploadFile();
        if (successfullyUploadedFile) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(
            '/',
            arguments: AuthArguments(
              false,
              false,
            ),
          );
          // File uploaded successfully
          showDialog(
            context: context,
            builder: (context) {
              return const MIHSuccessMessage(
                successType: "Success",
                successMessage: "Business details updated successfully",
              );
            },
          );
        } else {
          // File upload failed
          showDialog(
            context: context,
            builder: (context) {
              return MihAppAlert(
                alertIcon: Icon(
                  Icons.warning_rounded,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                alertTitle: "Error Updating Business Details",
                alertBody: Column(
                  children: [
                    Text(
                      "Hi there! To jump into the MIH Home Package, you'll need to set up biometric authentication (like fingerprint or face ID) on your device first. It looks like it's not quite ready yet.\n\nPlease head over to your device's settings to enable it, or press the button below to start the set up process now.",
                      style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                    ),
                  ],
                ),
                alertColour:
                    MzanziInnovationHub.of(context)!.theme.errorColor(),
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const MIHErrorMessage(errorType: "Error");
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    }
  }

  Future<bool> uploadFile() async {
    if (imageFile != null) {
      int uploadStatusCode = 0;
      uploadStatusCode = await MihFileApi.uploadFile(
        widget.arguments.business!.business_id,
        "business_files",
        imageFile!,
        context,
      );
      if (uploadStatusCode == 200) {
        int deleteStatusCode = 0;
        deleteStatusCode = await MihFileApi.deleteFile(
          widget.arguments.business!.logo_path.split("/").first,
          "business_files",
          widget.arguments.business!.logo_path.split("/").last,
          context,
        );
        if (deleteStatusCode == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return true; // No file selected, so no upload needed
    }
  }

  bool isFileSelected() {
    if (imageFile != null) {
      return true;
    } else {
      return false;
    }
  }

  bool isEmailValid() {
    String text = emailController.text;
    var regex = RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
    return regex.hasMatch(text);
  }

  bool isFormFilled() {
    if (regController.text.isEmpty ||
        nameController.text.isEmpty ||
        typeController.text.isEmpty ||
        practiceNoController.text.isEmpty ||
        vatNoController.text.isEmpty ||
        contactController.text.isEmpty ||
        emailController.text.isEmpty ||
        locationController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    fileNameController.dispose();
    regController.dispose();
    nameController.dispose();
    typeController.dispose();
    practiceNoController.dispose();
    vatNoController.dispose();
    contactController.dispose();
    emailController.dispose();
    locationController.dispose();
    imageFile = null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fileNameController.text =
          widget.arguments.business!.logo_path.split("/").last;
      regController.text = widget.arguments.business!.registration_no;
      nameController.text = widget.arguments.business!.Name;
      typeController.text = widget.arguments.business!.type;
      practiceNoController.text = widget.arguments.business!.practice_no;
      vatNoController.text = widget.arguments.business!.vat_no;
      contactController.text = widget.arguments.business!.contact_no;
      emailController.text = widget.arguments.business!.bus_email;
      locationController.text = widget.arguments.business!.gps_location;
    });
    fileUrlFuture = MihFileApi.getMinioFileUrl(
      widget.arguments.business!.logo_path,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    return MihSingleChildScroll(
        child: Column(
      children: [
        const Text(
          "Business Details",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        FutureBuilder(
            future: fileUrlFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Mihloadingcircle());
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data.toString().isNotEmpty) {
                return MihCircleAvatar(
                  imageFile: NetworkImage(snapshot.data.toString()),
                  width: 150,
                  editable: true,
                  fileNameController: fileNameController,
                  userSelectedfile: imageFile,
                  frameColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  onChange: (selectedfile) {
                    setState(() {
                      imageFile = selectedfile;
                    });
                  },
                );
                // MIHProfilePicture(
                //   profilePictureFile: NetworkImage(snapshot.data.toString()),
                //   proPicController: TextEditingController(),
                //   proPic: null,
                //   width: 100,
                //   radius: 50,
                //   drawerMode: false,
                //   editable: false,
                //   onChange: () {},
                //   frameColor: Colors.white,
                // );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return const Text("Error loading image");
              }
            }),
        Visibility(
          visible: true,
          child: MIHTextField(
            controller: fileNameController,
            hintText: "Selected File Name",
            editable: false,
            required: false,
          ),
        ),
        const SizedBox(height: 20),
        MIHTextField(
          controller: regController,
          hintText: "Registration No.",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: nameController,
          hintText: "Business Name",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: typeController,
          hintText: "Business Type",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: practiceNoController,
          hintText: "Practice Number",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: vatNoController,
          hintText: "VAT Number",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: contactController,
          hintText: "Contact Number",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: emailController,
          hintText: "Email",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
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
              width: 100.0,
              height: 50.0,
              child: MIHButton(
                buttonText: "Set",
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                textColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                onTap: () {
                  MIHLocationAPI().getGPSPosition(context).then((position) {
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
        // MIHTextField(
        //   controller: locationController,
        //   hintText: "Location",
        //   editable: false,
        //   required: false,
        // ),
        // const SizedBox(height: 10),
        // SizedBox(
        //   width: 100.0,
        //   height: 50.0,
        //   child: MIHButton(
        //     buttonText: "Set",
        //     buttonColor:
        //         MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        //     textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        //     onTap: () {
        //       MIHLocationAPI().getGPSPosition(context).then((position) {
        //         if (position != null) {
        //           setState(() {
        //             locationController.text =
        //                 "${position.latitude}, ${position.longitude}";
        //           });
        //         }
        //       });
        //     },
        //   ),
        // ),
        const SizedBox(height: 30),
        SizedBox(
          width: 500.0,
          height: 50.0,
          child: MIHButton(
            buttonText: "Update",
            buttonColor:
                MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            onTap: () {
              submitForm();
            },
          ),
        ),
      ],
    ));
  }
}
