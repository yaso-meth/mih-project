import 'dart:convert';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_file_api.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_delete_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/files.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/list_builders/build_file_view.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildFilesList extends StatefulWidget {
  final AppUser signedInUser;
  final List<PFile> files;
  final Patient selectedPatient;
  final Business? business;
  final BusinessUser? businessUser;
  final String type;
  final String env;
  const BuildFilesList({
    super.key,
    required this.files,
    required this.signedInUser,
    required this.selectedPatient,
    required this.business,
    required this.businessUser,
    required this.type,
    required this.env,
  });

  @override
  State<BuildFilesList> createState() => _BuildFilesListState();
}

class _BuildFilesListState extends State<BuildFilesList> {
  int indexOn = 0;
  final baseAPI = AppEnviroment.baseApiUrl;
  final basefile = AppEnviroment.baseFileUrl;
  String fileUrl = "";

  Future<String> getFileUrlApiCall(String filePath) async {
    String teporaryFileUrl = "";
    await MihFileApi.getMinioFileUrl(
      filePath,
      context,
    ).then((value) {
      teporaryFileUrl = value;
    });
    return teporaryFileUrl;
  }

  Future<void> deleteFileApiCall(String filePath, int fileID) async {
    var response = await MihFileApi.deleteFile(
      widget.selectedPatient.app_id,
      widget.env,
      "patient_files",
      filePath.split("/").last,
      context,
    );
    if (response == 200) {
      // delete file from database
      await deletePatientFileLocationToDB(fileID);
    } else {
      String message =
          "The File has not been deleted successfully. Please try again.";
      successPopUp(message);
    }
  }

  Future<void> deletePatientFileLocationToDB(int fileID) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var response2 = await http.delete(
      Uri.parse("$baseAPI/patient_files/delete/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "idpatient_files": fileID,
        "env": widget.env,
      }),
    );
    if (response2.statusCode == 200) {
      Navigator.of(context).pop(); //Remove Loading Dialog
      Navigator.of(context).pop(); //Remove Delete Dialog
      Navigator.of(context).pop(); //Remove File View Dialog
      Navigator.of(context).pop(); //Remove File List Dialog
      //print(widget.business);
      if (widget.business == null) {
        Navigator.of(context).pushNamed('/patient-manager/patient',
            arguments: PatientViewArguments(
                widget.signedInUser,
                widget.selectedPatient,
                widget.businessUser,
                widget.business,
                "personal"));
      } else {
        Navigator.of(context).pushNamed('/patient-manager/patient',
            arguments: PatientViewArguments(
                widget.signedInUser,
                widget.selectedPatient,
                widget.businessUser,
                widget.business,
                "business"));
      }
      String message =
          "The File has been deleted successfully. This means it will no longer be visible on your and cannot be used for future appointments.";
      successPopUp(message);
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

  void deleteFilePopUp(String filePath, int fileID) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MIHDeleteMessage(
        deleteType: "File",
        onTap: () async {
          await deleteFileApiCall(filePath, fileID);
        },
      ),
    );
  }

  void viewFilePopUp(String fileName, String filePath, int fileID, String url) {
    bool hasAccessToDelete = false;
    if (widget.type == "business") {
      hasAccessToDelete = true;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: true,
        windowTitle: fileName,
        windowBody: Column(
          children: [
            BuildFileView(
              link: url,
              path: filePath,
              //pdfLink: '${AppEnviroment.baseFileUrl}/mih/$filePath',
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
        windowTools: Visibility(
          visible: hasAccessToDelete,
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: MihFloatingMenu(
              animatedIcon: AnimatedIcons.menu_close,
              direction: SpeedDialDirection.down,
              children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.delete,
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  label: "Delete Document",
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
                    deleteFilePopUp(filePath, fileID);
                  },
                ),
              ],
            ),
          ),
        ),
        onWindowTapClose: () {
          Navigator.pop(context);
        },
      ),
    );
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => Dialog(
    //     child: Stack(
    //       children: [
    //         Container(
    //           padding: const EdgeInsets.all(10.0),
    //           width: 800.0,
    //           //height: 475.0,
    //           decoration: BoxDecoration(
    //             color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    //             borderRadius: BorderRadius.circular(25.0),
    //             border: Border.all(
    //                 color:
    //                     MzanziInnovationHub.of(context)!.theme.secondaryColor(),
    //                 width: 5.0),
    //           ),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               const SizedBox(
    //                 height: 25,
    //               ),
    //               Text(
    //                 fileName,
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                   color: MzanziInnovationHub.of(context)!
    //                       .theme
    //                       .secondaryColor(),
    //                   fontSize: 35.0,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //               const SizedBox(height: 25.0),
    //               Expanded(
    //                   child: BuildFileView(
    //                 link: url,
    //                 path: filePath,
    //                 //pdfLink: '${AppEnviroment.baseFileUrl}/mih/$filePath',
    //               )),
    //               const SizedBox(height: 30.0),
    //               SizedBox(
    //                 width: 300,
    //                 height: 50,
    //                 child: MIHButton(
    //                   onTap: () {
    //                     html.window.open(
    //                         url,
    //                         // '${AppEnviroment.baseFileUrl}/mih/$filePath',
    //                         'download');
    //                   },
    //                   buttonText: "Dowload",
    //                   buttonColor: MzanziInnovationHub.of(context)!
    //                       .theme
    //                       .secondaryColor(),
    //                   textColor:
    //                       MzanziInnovationHub.of(context)!.theme.primaryColor(),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //         Positioned(
    //           top: 5,
    //           right: 5,
    //           width: 50,
    //           height: 50,
    //           child: IconButton(
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //             icon: Icon(
    //               Icons.close,
    //               color: MzanziInnovationHub.of(context)!.theme.errorColor(),
    //               size: 35,
    //             ),
    //           ),
    //         ),
    //         Positioned(
    //           top: 5,
    //           left: 5,
    //           width: 50,
    //           height: 50,
    //           child: IconButton(
    //             onPressed: () {
    //               deleteFilePopUp(filePath, fileID);
    //             },
    //             icon: Icon(
    //               Icons.delete,
    //               color:
    //                   MzanziInnovationHub.of(context)!.theme.secondaryColor(),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.files.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          );
        },
        itemCount: widget.files.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              widget.files[index].file_name,
              style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
            subtitle: Text(
              widget.files[index].insert_date,
              style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
            // trailing: Icon(
            //   Icons.arrow_forward,
            //   color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            // ),
            onTap: () async {
              await getFileUrlApiCall(widget.files[index].file_path)
                  .then((urlHere) {
                //print(url);
                setState(() {
                  fileUrl = urlHere;
                });
              });

              viewFilePopUp(
                  widget.files[index].file_name,
                  widget.files[index].file_path,
                  widget.files[index].idpatient_files,
                  fileUrl);
            },
          );
        },
      );
    } else {
      return const Center(
        child: Text(
          "No Documents Available",
          style: TextStyle(fontSize: 25, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
