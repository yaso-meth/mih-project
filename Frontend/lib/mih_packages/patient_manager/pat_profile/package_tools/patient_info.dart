import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
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
    int textLength = originalText.length >= 13 ? 13 : originalText.length;
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
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
    TextStyle subtitleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
    TextStyle subtitleHeadingStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "Patient Details Card",
      onWindowTapClose: null,
      backgroundColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      foregroundColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
    TextStyle subtitleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
    TextStyle subtitleHeadingStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "Medical Aid Card",
      onWindowTapClose: null,
      backgroundColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      foregroundColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                      "${patientManagerProvider.selectedPatient!.medical_aid} - ${patientManagerProvider.selectedPatient!.medical_aid_scheme}",
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MihCircleAvatar(
                  imageFile:
                      patientManagerProvider.selectedPatientProfilePicture,
                  width: 160,
                  editable: false,
                  fileNameController: null,
                  userSelectedfile: null,
                  frameColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  backgroundColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  onChange: () {},
                ),
                const SizedBox(height: 10),
                buildPatientInfoCard(patientManagerProvider),
                const SizedBox(height: 10),
                if (patientManagerProvider.selectedPatient!.medical_aid ==
                    "Yes")
                  buildMedAidInfoCard(patientManagerProvider),
              ],
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
                    ? MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark")
                    : MihColors.getRedColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                child: Icon(
                  patientManagerProvider.hidePatientDetails
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
            ),
            Visibility(
              visible: patientManagerProvider.personalMode,
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
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                      label: "Edit Profile",
                      labelBackgroundColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      labelStyle: TextStyle(
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      onTap: () {
                        showEditPatientWindow();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
