import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_image_display.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_location_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_my_business_user_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MihBusinessDetailsSetUp extends StatefulWidget {
  const MihBusinessDetailsSetUp({super.key});

  @override
  State<MihBusinessDetailsSetUp> createState() =>
      _MihBusinessDetailsSetUpState();
}

class _MihBusinessDetailsSetUpState extends State<MihBusinessDetailsSetUp> {
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final regController = TextEditingController();
  final addressController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final titleController = TextEditingController();
  final signtureController = TextEditingController();
  final accessController = TextEditingController();
  final countryCodeController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final practiceNoController = TextEditingController();
  final vatNoController = TextEditingController();
  final websiteController = TextEditingController();
  final ratingController = TextEditingController();
  final missionVisionController = TextEditingController();
  final logoFileNameController = TextEditingController();
  PlatformFile? newSelectedLogoPic;
  PlatformFile? newSelectedSignaturePic;
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  final ValueNotifier<String> busType = ValueNotifier("");
  late String env;

  void submitForm(MzansiProfileProvider mzansiProfileProvider) {
    if (isFieldsFilled()) {
      createBusinessProfileAPICall(mzansiProfileProvider);
    } else {
      MihAlertServices().inputErrorAlert(context);
    }
  }

  Future<void> createBusinessProfileAPICall(
      MzansiProfileProvider mzansiProfileProvider) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Mihloadingcircle();
        },
      );
      String business_id = Uuid().v4();
      int responseCode = await MihBusinessDetailsServices().addBusiness(
        mzansiProfileProvider,
        business_id,
        nameController.text,
        typeController.text,
        regController.text,
        practiceNoController.text,
        vatNoController.text,
        emailController.text,
        getNumberWithCountryCode(),
        locationController.text,
        logoFileNameController.text,
        websiteController.text,
        "0",
        missionVisionController.text,
        context,
      );
      if (responseCode == 201) {
        bool successUpload =
            await uploadFile(mzansiProfileProvider, newSelectedLogoPic);
        if (successUpload) {
          String logoUrl = MihFileApi.getMinioFileUrlV2(
              mzansiProfileProvider.business!.logo_path);
          mzansiProfileProvider.setBusinessProfilePicUrl(logoUrl);
        }
        await createBusinessUserAPICall(mzansiProfileProvider);
      } else {
        context.pop();
        MihAlertServices().internetConnectionAlert(context);
      }
    } catch (error) {
      context.pop();
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  Future<void> createBusinessUserAPICall(
      MzansiProfileProvider mzansiProfileProvider) async {
    int statusCode = await MihMyBusinessUserServices().createBusinessUser(
      mzansiProfileProvider.business!.business_id,
      mzansiProfileProvider.user!.app_id,
      signtureController.text,
      titleController.text,
      accessController.text,
      mzansiProfileProvider,
      context,
    );
    if (statusCode == 201) {
      bool successUpload =
          await uploadFile(mzansiProfileProvider, newSelectedSignaturePic);
      if (successUpload) {
        String sigUrl = MihFileApi.getMinioFileUrlV2(
            mzansiProfileProvider.businessUser!.sig_path);
        mzansiProfileProvider.setBusinessUserSignatureUrl(sigUrl);
        String message =
            "Your business profile is now live! You can now start connecting with customers and growing your business.";
        context.pop();
        mzansiProfileProvider.syncWithMihServerData();
        successPopUp(message, false);
      } else {
        MihAlertServices().internetConnectionAlert(context);
      }
    } else {
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  Future<bool> uploadFile(
      MzansiProfileProvider mzansiProfileProvider, PlatformFile? image) async {
    if (newSelectedLogoPic != null) {
      int uploadStatusCode = 0;
      uploadStatusCode = await MihFileApi.uploadFile(
        mzansiProfileProvider.business!.business_id,
        env,
        "business_files",
        image,
        context,
      );
      if (uploadStatusCode == 200) {
        return true;
      } else {
        return false;
      }
    } else {
      return true; // No file selected, so no upload needed
    }
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

  String getNumberWithCountryCode() {
    String numberWithoutBeginingZero = "";
    if (contactController.text[0] == "0") {
      numberWithoutBeginingZero = contactController.text
          .replaceAll(" ", "")
          .substring(1, contactController.text.length);
    } else {
      numberWithoutBeginingZero = contactController.text.replaceAll("-", " ");
    }
    return "${countryCodeController.text}-$numberWithoutBeginingZero";
  }

  Color getMissionVisionLimitColor(int limit) {
    if (_counter.value <= limit) {
      return MihColors.secondary();
    } else {
      return MihColors.red();
    }
  }

  void typeSelected() {
    if (typeController.text.isNotEmpty) {
      busType.value = typeController.text;
    } else {
      busType.value = "";
    }
  }

  void successPopUp(String message, bool stayOnPersonalSide) {
    MihAlertServices().successAdvancedAlert(
      "Successfully Updated Profile",
      message,
      [
        MihButton(
          onPressed: () {
            context.goNamed(
              'mihHome',
              extra: stayOnPersonalSide,
            );
          },
          buttonColor: MihColors.primary(),
          elevation: 10,
          width: 300,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.secondary(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      context,
    );
  }

  void initialiseControlers(MzansiProfileProvider mzansiProfileProvider) {
    typeController.addListener(typeSelected);
    setState(() {
      fnameController.text = mzansiProfileProvider.user!.fname;
      lnameController.text = mzansiProfileProvider.user!.lname;
      accessController.text = "Full";
      countryCodeController.text = "+27";
    });
    if (AppEnviroment.getEnv() == "Prod") {
      env = "Prod";
    } else {
      env = "Dev";
    }
    missionVisionController.addListener(() {
      setState(() {
        _counter.value = missionVisionController.text.characters.length;
      });
    });
  }

  @override
  void dispose() {
    typeController.removeListener(typeSelected);
    nameController.dispose();
    typeController.dispose();
    regController.dispose();
    addressController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    titleController.dispose();
    signtureController.dispose();
    accessController.dispose();
    countryCodeController.dispose();
    contactController.dispose();
    emailController.dispose();
    locationController.dispose();
    practiceNoController.dispose();
    vatNoController.dispose();
    websiteController.dispose();
    ratingController.dispose();
    missionVisionController.dispose();
    logoFileNameController.dispose();
    busType.dispose();
    _focusNode.dispose();
    _counter.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialiseControlers(context.read<MzansiProfileProvider>());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      bodyItem: getBody(screenWidth),
    );
  }

  Widget getBody(double width) {
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (event) async {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              if (_formKey.currentState!.validate()) {
                submitForm(mzansiProfileProvider);
              } else {
                MihAlertServices().inputErrorAlert(context);
              }
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                      ? EdgeInsets.symmetric(horizontal: width * 0.2)
                      : EdgeInsets.symmetric(horizontal: width * 0.075),
              child: Column(
                children: [
                  const Text(
                    "Business Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Divider(color: MihColors.secondary()),
                  Row(
                    children: [
                      Text(
                        "*NB: Internet connection required to set up business profile.",
                        style: TextStyle(
                          color: MihColors.red(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  MihForm(
                    formKey: _formKey,
                    formFields: [
                      Center(
                        child: MihCircleAvatar(
                          imageFile: newSelectedLogoPic != null
                              ? MemoryImage(newSelectedLogoPic!.bytes!)
                              : mzansiProfileProvider.businessProfilePicture,
                          width: 150,
                          expandable: false,
                          editable: true,
                          fileNameController: logoFileNameController,
                          userSelectedfile: newSelectedLogoPic,
                          frameColor: MihColors.secondary(),
                          backgroundColor: MihColors.primary(),
                          onChange: (selectedfile) {
                            setState(() {
                              newSelectedLogoPic = selectedfile;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      MihTextFormField(
                        fillColor: MihColors.secondary(),
                        inputColor: MihColors.primary(),
                        controller: nameController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "Business Name",
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MihColors.secondary(),
                        inputColor: MihColors.primary(),
                        controller: typeController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "Business Type",
                        validator: (value) {
                          return MihValidationServices()
                              .validateNoSpecialChars(value);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MihColors.secondary(),
                        inputColor: MihColors.primary(),
                        controller: emailController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "Business Email",
                        validator: (value) {
                          return MihValidationServices().validateEmail(value);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        width: 300,
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Contact Number:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CountryCodePicker(
                            padding: EdgeInsetsGeometry.all(0),
                            onChanged: (selectedCode) {
                              setState(() {
                                countryCodeController.text =
                                    selectedCode.toString();
                              });
                              debugPrint(
                                  "Selected Country Code: ${countryCodeController.text}");
                            },
                            initialSelection: countryCodeController.text,
                            showDropDownButton: false,
                            pickerStyle: PickerStyle.bottomSheet,
                            dialogBackgroundColor: MihColors.primary(),
                            barrierColor: MihColors.primary(),
                          ),
                          Expanded(
                            child: MihTextFormField(
                              fillColor: MihColors.secondary(),
                              inputColor: MihColors.primary(),
                              controller: contactController,
                              numberMode: true,
                              multiLineInput: false,
                              requiredText: true,
                              hintText: null,
                              validator: (value) {
                                return MihValidationServices().isEmpty(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        height: 250,
                        fillColor: MihColors.secondary(),
                        inputColor: MihColors.primary(),
                        controller: missionVisionController,
                        multiLineInput: true,
                        requiredText: true,
                        hintText: "Business Mission & Vision",
                        validator: (value) {
                          return MihValidationServices().validateLength(
                              missionVisionController.text, 256);
                        },
                      ),
                      SizedBox(
                        height: 15,
                        child: ValueListenableBuilder(
                          valueListenable: _counter,
                          builder:
                              (BuildContext context, int value, Widget? child) {
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "$value",
                                  style: TextStyle(
                                    color: getMissionVisionLimitColor(256),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "/256",
                                  style: TextStyle(
                                    color: getMissionVisionLimitColor(256),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MihColors.secondary(),
                        inputColor: MihColors.primary(),
                        controller: websiteController,
                        multiLineInput: false,
                        requiredText: false,
                        hintText: "Business Website",
                        validator: (value) {
                          return MihValidationServices()
                              .validateWebsite(value, false);
                        },
                      ),
                      const SizedBox(height: 10.0),

                      MihTextFormField(
                        fillColor: MihColors.secondary(),
                        inputColor: MihColors.primary(),
                        controller: regController,
                        multiLineInput: false,
                        requiredText: false,
                        hintText: "Registration No.",
                        validator: (value) {
                          // return MihValidationServices().isEmpty(value);
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MihColors.secondary(),
                        inputColor: MihColors.primary(),
                        controller: practiceNoController,
                        multiLineInput: false,
                        requiredText: false,
                        hintText: "Practice Number",
                        validator: (validateValue) {
                          return null;
                        },
                      ),

                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MihColors.secondary(),
                        inputColor: MihColors.primary(),
                        controller: vatNoController,
                        multiLineInput: false,
                        requiredText: false,
                        hintText: "VAT Number",
                        validator: (value) {
                          // return MihValidationServices().isEmpty(value);
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: MihTextFormField(
                              fillColor: MihColors.secondary(),
                              inputColor: MihColors.primary(),
                              controller: locationController,
                              multiLineInput: false,
                              requiredText: true,
                              readOnly: true,
                              hintText: "GPS Location",
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          MihButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const Mihloadingcircle(
                                    message: "Getting your location",
                                  );
                                },
                              );
                              MIHLocationAPI()
                                  .getGPSPosition(context)
                                  .then((position) {
                                if (position != null) {
                                  setState(() {
                                    locationController.text =
                                        "${position.latitude}, ${position.longitude}";
                                  });
                                }
                                Navigator.of(context).pop();
                              });
                            },
                            buttonColor: MihColors.secondary(),
                            width: 100,
                            child: Text(
                              "Set",
                              style: TextStyle(
                                color: MihColors.primary(),
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
                          "Business User",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Divider(color: MihColors.secondary()),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MihColors.secondary(),
                        inputColor: MihColors.primary(),
                        controller: titleController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "Title",
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                      ),
                      // MihDropdownField(
                      //   controller: titleController,
                      //   hintText: "Title",
                      //   dropdownOptions: const ["Doctor", "Assistant", "Other"],
                      //   editable: true,
                      //   enableSearch: true,
                      //   validator: (value) {
                      //     return MihValidationServices().isEmpty(value);
                      //   },
                      //   requiredText: true,
                      // ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MihColors.secondary(),
                        inputColor: MihColors.primary(),
                        controller: fnameController,
                        multiLineInput: false,
                        requiredText: true,
                        readOnly: true,
                        hintText: "First Name",
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MihColors.secondary(),
                        inputColor: MihColors.primary(),
                        controller: lnameController,
                        multiLineInput: false,
                        requiredText: true,
                        readOnly: true,
                        hintText: "Surname",
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MihColors.secondary(),
                        inputColor: MihColors.primary(),
                        controller: accessController,
                        multiLineInput: false,
                        requiredText: true,
                        readOnly: true,
                        hintText: "Access Type",
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 300,
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Signature:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: MihImageDisplay(
                          imageFile: newSelectedSignaturePic != null
                              ? MemoryImage(newSelectedSignaturePic!.bytes!)
                              : mzansiProfileProvider.businessUserSignature,
                          width: 300,
                          height: 200,
                          editable: true,
                          fileNameController: signtureController,
                          userSelectedfile: newSelectedSignaturePic,
                          onChange: (selectedFile) {
                            setState(() {
                              newSelectedSignaturePic = selectedFile;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: MihButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              submitForm(mzansiProfileProvider);
                            } else {
                              MihAlertServices().inputErrorAlert(context);
                            }
                          },
                          buttonColor: MihColors.green(),
                          width: 300,
                          child: Text(
                            "Set Up Business",
                            style: TextStyle(
                              color: MihColors.primary(),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
