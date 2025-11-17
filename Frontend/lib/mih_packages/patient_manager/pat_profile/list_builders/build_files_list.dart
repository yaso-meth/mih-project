import 'dart:async';

import 'package:fl_downloader/fl_downloader.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_file_viewer_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/list_builders/build_file_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:http/http.dart' as http2;
import "package:universal_html/html.dart" as html;

class BuildFilesList extends StatefulWidget {
  const BuildFilesList({
    super.key,
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
    ).then((value) {
      teporaryFileUrl = value;
    });
    return teporaryFileUrl;
  }

  // Future<void> deleteFileApiCall(PatientManagerProvider patientManagerProvider,
  //     String filePath, int fileID) async {
  //   var response = await MihFileApi.deleteFile(
  //     patientManagerProvider.selectedPatient!.app_id,
  //     widget.env,
  //     "patient_files",
  //     filePath.split("/").last,
  //     context,
  //   );
  //   if (response == 200) {
  //     // delete file from database
  //     await deletePatientFileLocationToDB(fileID);
  //   } else {
  //     String message =
  //         "The File has not been deleted successfully. Please try again.";
  //     successPopUp(message);
  //   }
  // }

  // Future<void> deletePatientFileLocationToDB(int fileID) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return const Mihloadingcircle();
  //     },
  //   );
  //   var response2 = await http.delete(
  //     Uri.parse("$baseAPI/patient_files/delete/"),
  //     headers: <String, String>{
  //       "Content-Type": "application/json; charset=UTF-8"
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       "idpatient_files": fileID,
  //       "env": widget.env,
  //     }),
  //   );
  //   if (response2.statusCode == 200) {
  //     context.pop(); //Remove Loading Dialog
  //     context.pop(); //Remove Delete Dialog
  //     context.pop(); //Remove File View Dialog
  //     context.pop(); //Remove File List Dialog
  //     //print(widget.business);
  //     if (widget.business == null) {
  //       context.pushNamed('patientManagerPatient',
  //           extra: PatientViewArguments(
  //               widget.signedInUser,
  //               widget.selectedPatient,
  //               widget.businessUser,
  //               widget.business,
  //               "personal"));
  //     } else {
  //       context.pushNamed('patientManagerPatient',
  //           extra: PatientViewArguments(
  //               widget.signedInUser,
  //               widget.selectedPatient,
  //               widget.businessUser,
  //               widget.business,
  //               "business"));
  //     }
  //     String message =
  //         "The File has been deleted successfully. This means it will no longer be visible on your and cannot be used for future appointments.";
  //     successPopUp(message);
  //   } else {
  //     internetConnectionPopUp();
  //   }
  // }

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

  // void deleteFilePopUp(String filePath, int fileID) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => MIHDeleteMessage(
  //       deleteType: "File",
  //       onTap: () async {
  //         await deleteFileApiCall(filePath, fileID);
  //       },
  //     ),
  //   );
  // }

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

  void viewFilePopUp(PatientManagerProvider patientManagerProvider,
      String fileName, String filePath, int fileID, String url) {
    bool hasAccessToDelete = false;
    if (!patientManagerProvider.personalMode) {
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
            // deleteFilePopUp(filePath, fileID);
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

  Widget getFileIcon(String extension) {
    switch (extension) {
      case ("pdf"):
        return Icon(
          Icons.picture_as_pdf,
          size: 50,
          color: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      case ("jpg"):
        return Icon(
          FontAwesomeIcons.image,
          size: 50,
          color: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      case ("png"):
        return Icon(
          FontAwesomeIcons.image,
          size: 50,
          color: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      case ("gif"):
        return Icon(
          FontAwesomeIcons.image,
          size: 50,
          color: MihColors.getOrangeColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      default:
        return Icon(
          Icons.image_not_supported,
          size: 50,
          color: MihColors.getSilverColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
    }
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
    return Consumer2<MzansiProfileProvider, PatientManagerProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        if (patientManagerProvider.patientDocuments!.isNotEmpty) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              );
            },
            itemCount: patientManagerProvider.patientDocuments!.length,
            itemBuilder: (context, index) {
              String fileExtension = patientManagerProvider
                  .patientDocuments![index].file_name
                  .split(".")[1]
                  .toLowerCase();
              KenLogger.success(fileExtension);
              return ListTile(
                leading: getFileIcon(fileExtension),
                title: Text(
                  patientManagerProvider.patientDocuments![index].file_name,
                  style: TextStyle(
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
                subtitle: Text(
                  patientManagerProvider.patientDocuments![index].insert_date,
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
                  MihFileViewerProvider fileViewerProvider =
                      context.read<MihFileViewerProvider>();
                  await getFileUrlApiCall(patientManagerProvider
                          .patientDocuments![index].file_path)
                      .then((urlHere) {
                    //print(url);
                    fileViewerProvider.setFilePath(patientManagerProvider
                        .patientDocuments![index].file_path);
                    fileViewerProvider.setFileLink(urlHere);
                  });

                  viewFilePopUp(
                      patientManagerProvider,
                      patientManagerProvider.patientDocuments![index].file_name,
                      patientManagerProvider.patientDocuments![index].file_path,
                      patientManagerProvider
                          .patientDocuments![index].idpatient_files,
                      fileViewerProvider.fileLink);
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
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                    Icon(
                      Icons.file_present,
                      size: 110,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
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
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
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
                        !patientManagerProvider.personalMode
                            ? TextSpan(
                                text: " or generate a the first document")
                            : TextSpan(text: " the first document"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
