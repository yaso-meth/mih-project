import 'dart:async';
import 'dart:convert';

import 'package:fl_downloader/fl_downloader.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_delete_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/files.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/list_builders/build_file_view.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:http/http.dart' as http2;
import "package:universal_html/html.dart" as html;

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
  int progress = 0;
  late StreamSubscription progressStream;

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
      context.pop(); //Remove Loading Dialog
      context.pop(); //Remove Delete Dialog
      context.pop(); //Remove File View Dialog
      Navigator.of(context).pop(); //Remove File List Dialog
      //print(widget.business);
      if (widget.business == null) {
        context.pushNamed('patientManagerPatient',
            extra: PatientViewArguments(
                widget.signedInUser,
                widget.selectedPatient,
                widget.businessUser,
                widget.business,
                "personal"));
      } else {
        context.pushNamed('patientManagerPatient',
            extra: PatientViewArguments(
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

  String getFileName(String path) {
    //print(pdfLink.split(".")[1]);
    return path.split("/").last;
  }

  void printDocument(String link, String path) async {
    http2.Response response = await http.get(Uri.parse(link));
    var pdfData = response.bodyBytes;
    context.pop();
    context.pushNamed(
      'printPreview',
      extra: PrintPreviewArguments(
        pdfData,
        getFileName(path),
      ),
    );
  }

  void nativeFileDownload(String fileLink) async {
    var permission = await FlDownloader.requestPermission();
    if (permission == StoragePermissionStatus.granted) {
      try {
        mihLoadingPopUp();
        await FlDownloader.download(fileLink);
        Navigator.of(context).pop();
      } on Exception catch (error) {
        Navigator.of(context).pop();
        print(error);
      }
    } else {
      print("denied");
    }
  }

  void viewFilePopUp(String fileName, String filePath, int fileID, String url) {
    bool hasAccessToDelete = false;
    if (widget.type == "business") {
      hasAccessToDelete = true;
    }

    List<SpeedDialChild>? menuList = [
      SpeedDialChild(
        child: Icon(
          Icons.download,
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
        label: "Download",
        labelBackgroundColor: MihColors.getGreenColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        labelStyle: TextStyle(
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: MihColors.getGreenColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        onTap: () {
          if (MzansiInnovationHub.of(context)!.theme.getPlatform() == "Web") {
            html.window.open(url, 'download');
          } else {
            nativeFileDownload(url);
          }
        },
      ),
    ];
    if (filePath.split(".").last.toLowerCase() == "pdf") {
      menuList.add(
        SpeedDialChild(
          child: Icon(
            Icons.print,
            color: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          label: "Print",
          labelBackgroundColor: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          labelStyle: TextStyle(
            color: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          onTap: () {
            printDocument(url, filePath);
          },
        ),
      );
    }
    menuList.add(
      SpeedDialChild(
        child: Icon(
          Icons.fullscreen,
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
        label: "Full Screen",
        labelBackgroundColor: MihColors.getGreenColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        labelStyle: TextStyle(
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: MihColors.getGreenColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        onTap: () {
          context.pop();
          context.pushNamed(
            'fileViewer',
            extra: FileViewArguments(
              url,
              filePath,
            ),
          );
        },
      ),
    );
    // }
    if (hasAccessToDelete) {
      menuList.add(
        SpeedDialChild(
          child: Icon(
            Icons.delete,
            color: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          label: "Delete Document",
          labelBackgroundColor: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          labelStyle: TextStyle(
            color: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          onTap: () {
            deleteFilePopUp(filePath, fileID);
          },
        ),
      );
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: fileName,
        windowBody: BuildFileView(
          link: url,
          path: filePath,
          //pdfLink: '${AppEnviroment.baseFileUrl}/mih/$filePath',
        ),
        menuOptions: menuList,
        onWindowTapClose: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void mihLoadingPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FlDownloader.initialize();
    progressStream = FlDownloader.progressStream.listen((event) {
      if (event.status == DownloadStatus.successful) {
        setState(() {
          progress = event.progress;
        });
        //Navigator.of(context).pop();
        print("Progress $progress%: Success Downloading");
        FlDownloader.openFile(filePath: event.filePath);
      } else if (event.status == DownloadStatus.failed) {
        print("Progress $progress%: Error Downloading");
      } else if (event.status == DownloadStatus.running) {
        print("Progress $progress%: Download Running");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.files.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          );
        },
        itemCount: widget.files.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              widget.files[index].file_name,
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            subtitle: Text(
              widget.files[index].insert_date,
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            // trailing: Icon(
            //   Icons.arrow_forward,
            //   color: MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Icon(
                  MihIcons.mihRing,
                  size: 165,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                Icon(
                  Icons.file_present,
                  size: 110,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "No Documents have been added to this profile.",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                  children: [
                    TextSpan(text: "Press "),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.menu,
                        size: 20,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                    TextSpan(text: " to add "),
                    widget.business != null
                        ? TextSpan(text: " or generate a the first document")
                        : TextSpan(text: " the first document"),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      // return const Center(
      //   child: Text(
      //     "No Documents Available",
      //     style: TextStyle(fontSize: 25, color: Colors.grey),
      //     textAlign: TextAlign.center,
      //   ),
      // );
    }
  }
}
