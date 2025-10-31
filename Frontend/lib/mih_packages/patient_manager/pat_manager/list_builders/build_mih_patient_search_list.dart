import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_access_controls_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_service_calls.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_warning_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildMihPatientSearchList extends StatefulWidget {
  const BuildMihPatientSearchList({
    super.key,
  });

  @override
  State<BuildMihPatientSearchList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildMihPatientSearchList> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController accessStatusController = TextEditingController();
  final baseAPI = AppEnviroment.baseApiUrl;

  void noAccessWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "No Access");
      },
    );
  }

  Future<bool> hasAccessToProfile(MzansiProfileProvider profileProvider,
      PatientManagerProvider patientManagerProvider, int index) async {
    var hasAccess = false;
    await MIHApiCalls.checkBusinessAccessToPatient(
            profileProvider.business!.business_id,
            patientManagerProvider.patientSearchResults[index].app_id)
        .then((results) {
      if (results.isEmpty) {
        setState(() {
          hasAccess = false;
        });
      } else if (results[0].status == "approved") {
        setState(() {
          hasAccess = true;
        });
      } else {
        setState(() {
          hasAccess = false;
        });
      }
    });
    return hasAccess;
  }

  Future<String> getAccessStatusOfProfile(MzansiProfileProvider profileProvider,
      PatientManagerProvider patientManagerProvider, int index) async {
    var accessStatus = "";
    await MIHApiCalls.checkBusinessAccessToPatient(
            profileProvider.business!.business_id,
            patientManagerProvider.patientSearchResults[index].app_id)
        .then((results) {
      if (results.isEmpty) {
        setState(() {
          accessStatus = "";
        });
      } else {
        setState(() {
          accessStatus = results[0].status;
        });
      }
    });
    return accessStatus;
  }

  void patientProfileChoicePopUp(
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patientManagerProvider,
    int index,
  ) async {
    var hasAccess = false;
    String accessStatus = "";
    await hasAccessToProfile(profileProvider, patientManagerProvider, index)
        .then((result) {
      setState(() {
        hasAccess = result;
      });
    });
    await getAccessStatusOfProfile(
            profileProvider, patientManagerProvider, index)
        .then((result) {
      setState(() {
        accessStatus = result;
      });
    });
    if (accessStatus == "") {
      accessStatus = "No Access";
    }
    String patientIdNo =
        patientManagerProvider.patientSearchResults[index].id_no;
    String displayedIdNo;

    if (patientIdNo.length >= 6) {
      var idStars = '*' * (patientIdNo.length - 6);
      displayedIdNo = "${patientIdNo.substring(0, 6)}$idStars";
    } else {
      displayedIdNo = "${patientIdNo}******";
    }
    setState(() {
      idController.text = displayedIdNo;
      fnameController.text =
          patientManagerProvider.patientSearchResults[index].first_name;
      lnameController.text =
          patientManagerProvider.patientSearchResults[index].last_name;
      accessStatusController.text = accessStatus.toUpperCase();
    });
    //print(accessStatus);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Patient Profile",
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowBody: Column(
          children: [
            MihTextFormField(
              fillColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              inputColor: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              controller: idController,
              multiLineInput: false,
              requiredText: true,
              readOnly: true,
              hintText: "ID No.",
              validator: (value) {
                return MihValidationServices().isEmpty(value);
              },
            ),
            const SizedBox(height: 10.0),
            MihTextFormField(
              fillColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              inputColor: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
              fillColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              inputColor: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
              fillColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              inputColor: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              controller: accessStatusController,
              multiLineInput: false,
              requiredText: true,
              readOnly: true,
              hintText: "Access Status",
              validator: (value) {
                return MihValidationServices().isEmpty(value);
              },
            ),
            const SizedBox(height: 20.0),
            Visibility(
              visible: !hasAccess,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Important Notice: Requesting Patient Profile Access",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MihColors.getRedColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                  Text(
                    "You are about to request access to a patient's profile. Please be aware of the following important points:",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: MihColors.getRedColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                  SizedBox(
                    width: 600,
                    child: Text(
                      "1. Permanent Access: Once the patient accepts your access request, it will become permanent.",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 600,
                    child: Text(
                      "2. Shared Information: Any updates you make to the patient's profile will be visible to others who have access to the profile.",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 600,
                    child: Text(
                      "3. Irreversible Access: Once granted, you cannot revoke your access to the patient's profile.",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                  Text(
                    "By pressing the \"Request Access\" button you accept the above terms.\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MihColors.getRedColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 15.0),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 10,
                spacing: 10,
                children: [
                  Visibility(
                    visible: hasAccess,
                    child: Center(
                      child: MihButton(
                        onPressed: () async {
                          if (hasAccess) {
                            await MihPatientServices().getPatientDetails(
                                patientManagerProvider
                                    .patientSearchResults[index].app_id,
                                patientManagerProvider);
                            context.pop();
                            context.pushNamed(
                              'patientManagerPatient',
                            );
                            // context.pushNamed(
                            //   'patientPatient',
                            //   extra: patientManagerProvider
                            //       .patientSearchResults![index].app_id,
                            // );
                            // Navigator.of(context)
                            //     .pushNamed('/patient-manager/patient',
                            //         arguments: PatientViewArguments(
                            //           widget.signedInUser,
                            //           widget.patients[index],
                            //           widget.businessUser,
                            //           widget.business,
                            //           "business",
                            //         ));
                          } else {
                            noAccessWarning();
                          }
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "View Profile",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !hasAccess && accessStatus == "No Access",
                    child: Center(
                      child: MihButton(
                        onPressed: () async {
                          await MihAccessControlsServices
                              .addPatientAccessAPICall(
                            profileProvider.business!.business_id,
                            patientManagerProvider
                                .patientSearchResults[index].app_id,
                            "patient",
                            profileProvider.business!.Name,
                            patientManagerProvider.personalMode,
                            BusinessArguments(
                              profileProvider.user!,
                              profileProvider.businessUser,
                              profileProvider.business,
                            ),
                            context,
                          );
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "Request Access",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !hasAccess && accessStatus == "declined",
                    child: Center(
                      child: MihButton(
                        onPressed: () async {
                          await MIHApiCalls.reapplyPatientAccessAPICall(
                            profileProvider.business!.business_id,
                            patientManagerProvider
                                .patientSearchResults[index].app_id,
                            patientManagerProvider.personalMode,
                            BusinessArguments(
                              profileProvider.user!,
                              profileProvider.businessUser,
                              profileProvider.business,
                            ),
                            context,
                          );
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "Re-apply",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !hasAccess && accessStatus == "pending",
                    child: const SizedBox(
                      width: 500,
                      //height: 50,
                      child: Text(
                          "Patient has not approved access to their profile. Once access has been approved you can book and appointment or view their profile."),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget isMainMember(
      PatientManagerProvider patientManagerProvider, int index) {
    if (patientManagerProvider
            .patientSearchResults[index].medical_aid_main_member ==
        "Yes") {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            // "$firstLetterFName$fnameStar $firstLetterLName$lnameStar",
            "${patientManagerProvider.patientSearchResults[index].first_name} ${patientManagerProvider.patientSearchResults[index].last_name}",
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.star_border_rounded,
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
        ],
      );
    } else {
      return Text(
        // "$firstLetterFName$fnameStar $firstLetterLName$lnameStar",
        "${patientManagerProvider.patientSearchResults[index].first_name} ${patientManagerProvider.patientSearchResults[index].last_name}",
        style: TextStyle(
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      );
    }
  }

  Widget hasMedicalAid(
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patientManagerProvider,
    int index,
  ) {
    String patientIdNo =
        patientManagerProvider.patientSearchResults[index].id_no;
    String displayedIdNo;
    var medAidNoStar = '*' * 8;
    if (patientIdNo.length >= 6) {
      var idStars = '*' * (patientIdNo.length - 6);
      displayedIdNo = "${patientIdNo.substring(0, 6)}$idStars";
    } else {
      // If ID is shorter than 6 characters, just show it with stars
      displayedIdNo = "${patientIdNo}******";
    }

    if (patientManagerProvider.patientSearchResults[index].medical_aid ==
        "Yes") {
      return ListTile(
        title: isMainMember(patientManagerProvider, index),
        subtitle: Text(
          "ID No.: $displayedIdNo\nMedical Aid No.: $medAidNoStar",
          style: TextStyle(
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
        ),
        onTap: () {
          patientProfileChoicePopUp(
              profileProvider, patientManagerProvider, index);
          // setState(() {
          //   appointmentPopUp(index);
          //   // Add popup to add patienmt to queue
          //   // Navigator.of(context).pushNamed('/patient-manager/patient',
          //   //     arguments: PatientViewArguments(
          //   //         widget.signedInUser, widget.patients[index], "business"));
          // });
        },
        trailing: Icon(
          Icons.arrow_forward,
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      );
    } else {
      return ListTile(
        title: isMainMember(patientManagerProvider, index),
        subtitle: Text(
          "ID No.: $displayedIdNo\nMedical Aid No.: $medAidNoStar",
          style: TextStyle(
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
        ),
        onTap: () {
          patientProfileChoicePopUp(
              profileProvider, patientManagerProvider, index);
          // setState(() {
          //   appointmentPopUp(index);
          //   // Navigator.of(context).pushNamed('/patient-manager/patient',
          //   //     arguments: PatientViewArguments(
          //   //         widget.signedInUser, widget.patients[index], "business"));
          // });
        },
        trailing: Icon(
          Icons.add,
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      );
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    idController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    accessStatusController.dispose();
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    patientManagerProvider.setPatientSearchResults(patientSearchResults: []);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MzansiProfileProvider, PatientManagerProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, index) {
            return Divider(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            );
          },
          itemCount: patientManagerProvider.patientSearchResults.length,
          itemBuilder: (context, index) {
            KenLogger.success(
                "Search Results Count: ${patientManagerProvider.patientSearchResults.length}");
            return hasMedicalAid(
                profileProvider, patientManagerProvider, index);
          },
        );
      },
    );
  }
}
