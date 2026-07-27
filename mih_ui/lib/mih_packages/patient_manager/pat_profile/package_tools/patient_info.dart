import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/components/mih_edit_patient_details_window.dart';
import 'package:provider/provider.dart';

class PatientInfo extends StatefulWidget {
  const PatientInfo({
    super.key,
  });

  @override
  State<PatientInfo> createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  double textFieldWidth = 300;
  late String medAid;
  late bool medAidPosition;

  String getDisplayText(
      PatientManagerProvider patientManagerProvider, String originalText) {
    int textLength = originalText.length >= 13 ? 13 : 6;
    String displayText = "";
    if (patientManagerProvider.hidePatientDetails) {
      for (int i = 0; i < textLength; i++) {
        displayText += "●";
      }
    } else {
      displayText = originalText;
    }
    return displayText;
  }

  Widget buildPatientInfoCard(PatientManagerProvider patientManagerProvider) {
    TextStyle titleStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: MihColors.primary(),
    );
    TextStyle subtitleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: MihColors.primary(),
    );
    TextStyle subtitleHeadingStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: MihColors.primary(),
    );
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "Patient Details Card",
      onWindowTapClose: null,
      backgroundColor: MihColors.secondary(),
      foregroundColor: MihColors.primary(),
      windowBody: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${patientManagerProvider.selectedPatient!.first_name} ${patientManagerProvider.selectedPatient!.last_name}",
                      style: titleStyle,
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "ID No: ",
                            style: subtitleHeadingStyle,
                          ),
                          TextSpan(
                            text: getDisplayText(patientManagerProvider,
                                patientManagerProvider.selectedPatient!.id_no),
                            style: subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Cell No: ",
                            style: subtitleHeadingStyle,
                          ),
                          TextSpan(
                            text: getDisplayText(
                                patientManagerProvider,
                                patientManagerProvider
                                    .selectedPatient!.cell_no),
                            style: subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Email: ",
                  style: subtitleHeadingStyle,
                ),
                TextSpan(
                  text: getDisplayText(patientManagerProvider,
                      patientManagerProvider.selectedPatient!.email),
                  style: subtitleStyle,
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Address: ",
                  style: subtitleHeadingStyle,
                ),
                TextSpan(
                  text: getDisplayText(patientManagerProvider,
                      patientManagerProvider.selectedPatient!.address),
                  style: subtitleStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMedAidInfoCard(PatientManagerProvider patientManagerProvider) {
    TextStyle titleStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: MihColors.primary(),
    );
    TextStyle subtitleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: MihColors.primary(),
    );
    TextStyle subtitleHeadingStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: MihColors.primary(),
    );
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "Medical Aid Card",
      onWindowTapClose: null,
      backgroundColor: MihColors.secondary(),
      foregroundColor: MihColors.primary(),
      windowBody: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${patientManagerProvider.selectedPatient!.medical_aid_name} - ${patientManagerProvider.selectedPatient!.medical_aid_scheme}",
                      style: titleStyle,
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Main Member: ",
                            style: subtitleHeadingStyle,
                          ),
                          TextSpan(
                            text: getDisplayText(
                                patientManagerProvider,
                                patientManagerProvider
                                    .selectedPatient!.medical_aid_main_member),
                            style: subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "No: ",
                            style: subtitleHeadingStyle,
                          ),
                          TextSpan(
                            text: getDisplayText(
                                patientManagerProvider,
                                patientManagerProvider
                                    .selectedPatient!.medical_aid_no),
                            style: subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Code: ",
                            style: subtitleHeadingStyle,
                          ),
                          TextSpan(
                            text: getDisplayText(
                                patientManagerProvider,
                                patientManagerProvider
                                    .selectedPatient!.medical_aid_code),
                            style: subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void initialiseControllers(PatientManagerProvider patientManagerProvider) {
    medAid = patientManagerProvider.selectedPatient!.medical_aid;
    if (medAid == "Yes") {
      medAidPosition = true;
    } else {
      medAidPosition = false;
    }
  }

  void showEditPatientWindow() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return MihEditPatientDetailsWindow();
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(screenWidth),
    );
  }

  Widget getBody(double width) {
    return Consumer2<MzansiProfileProvider, PatientManagerProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        initialiseControllers(patientManagerProvider);
        return Stack(
          children: [
            MihSingleChildScroll(
              scrollbarOn: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MihCircleAvatar(
                    imageFile:
                        patientManagerProvider.selectedPatientProfilePicture,
                    width: 160,
                    expandable: true,
                    editable: false,
                    fileNameController: null,
                    userSelectedfile: null,
                    frameColor: MihColors.secondary(),
                    backgroundColor: MihColors.primary(),
                    onChange: null,
                  ),
                  if (patientManagerProvider.personalMode)
                    const SizedBox(height: 10),
                  if (patientManagerProvider.personalMode)
                    MihButton(
                      onPressed: () {
                        showEditPatientWindow();
                      },
                      buttonColor: MihColors.green(),
                      width: 100,
                      height: 35,
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: MihColors.primary(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  buildPatientInfoCard(patientManagerProvider),
                  const SizedBox(height: 10),
                  if (patientManagerProvider.selectedPatient!.medical_aid ==
                      "Yes")
                    buildMedAidInfoCard(patientManagerProvider),
                ],
              ),
            ),
            Positioned(
              right: 5,
              top: 5,
              child: MihButton(
                width: 40,
                height: 40,
                onPressed: () {
                  patientManagerProvider.setHidePatientDetails(
                      !patientManagerProvider.hidePatientDetails);
                },
                buttonColor: patientManagerProvider.hidePatientDetails
                    ? MihColors.green()
                    : MihColors.red(),
                child: Icon(
                  patientManagerProvider.hidePatientDetails
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: MihColors.primary(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
