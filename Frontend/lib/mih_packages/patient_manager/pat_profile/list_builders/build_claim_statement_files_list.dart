import 'dart:async';

import 'package:fl_downloader/fl_downloader.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
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

class BuildClaimStatementFileList extends StatefulWidget {
  const BuildClaimStatementFileList({
    super.key,
  });

  @override
  State<BuildClaimStatementFileList> createState() =>
      _BuildClaimStatementFileListState();
}

class _BuildClaimStatementFileListState
    extends State<BuildClaimStatementFileList> {
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
  //         //API Call here
  //         await MIHClaimStatementGenerationApi
  //             .deleteClaimStatementFilesByFileID(
  //           PatientViewArguments(
  //             widget.signedInUser,
  //             widget.selectedPatient,
  //             widget.businessUser,
  //             widget.business,
  //             "business",
  //           ),
  //           widget.env,
  //           filePath,
  //           fileID,
  //           context,
  //         );
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
    // Navigator.of(context).pushNamed(
    //   '/file-veiwer/print-preview',
    //   arguments: PrintPreviewArguments(
    //     pdfData,
    //     getFileName(path),
    //   ),
    // );
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
          // printDocument(url, filePath);
        },
      ),
    );

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
    return Consumer2<MzansiProfileProvider, PatientManagerProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        if (patientManagerProvider.patientClaimsDocuments!.isNotEmpty) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              );
            },
            itemCount: patientManagerProvider.patientClaimsDocuments!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  patientManagerProvider
                      .patientClaimsDocuments![index].file_name,
                  style: TextStyle(
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
                subtitle: Text(
                  patientManagerProvider
                      .patientClaimsDocuments![index].insert_date,
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
                  await getFileUrlApiCall(patientManagerProvider
                          .patientClaimsDocuments![index].file_path)
                      .then((urlHere) {
                    //print(url);
                    setState(() {
                      fileUrl = urlHere;
                    });
                  });

                  viewFilePopUp(
                      patientManagerProvider,
                      patientManagerProvider
                          .patientClaimsDocuments![index].file_name,
                      patientManagerProvider
                          .patientClaimsDocuments![index].file_path,
                      patientManagerProvider.patientClaimsDocuments![index]
                          .idclaim_statement_file,
                      fileUrl);
                },
              );
            },
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
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
                      Icons.file_open_outlined,
                      size: 110,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "No Claims or Statements have been added to this profile.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Visibility(
                  visible: !patientManagerProvider.personalMode,
                  child: Center(
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
                          TextSpan(text: " to generate the first document"),
                        ],
                      ),
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
