import 'dart:async';

import 'package:fl_downloader/fl_downloader.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_claim_statement_generation_api.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_api.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_delete_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/claim_statement_file.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/list_builders/build_file_view.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:http/http.dart' as http2;
import "package:universal_html/html.dart" as html;

class BuildClaimStatementFileList extends StatefulWidget {
  final AppUser signedInUser;
  final List<ClaimStatementFile> files;
  final Patient selectedPatient;
  final Business? business;
  final BusinessUser? businessUser;
  final String type;
  final String env;
  const BuildClaimStatementFileList({
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

  void deleteFilePopUp(String filePath, int fileID) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MIHDeleteMessage(
        deleteType: "File",
        onTap: () async {
          //API Call here
          await MIHClaimStatementGenerationApi
              .deleteClaimStatementFilesByFileID(
            PatientViewArguments(
              widget.signedInUser,
              widget.selectedPatient,
              widget.businessUser,
              widget.business,
              "business",
            ),
            widget.env,
            filePath,
            fileID,
            context,
          );
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
    Navigator.of(context).pushNamed(
      '/file-veiwer/print-preview',
      arguments: PrintPreviewArguments(
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
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        ),
        label: "Download",
        labelBackgroundColor:
            MzanziInnovationHub.of(context)!.theme.successColor(),
        labelStyle: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: MzanziInnovationHub.of(context)!.theme.successColor(),
        onTap: () {
          if (MzanziInnovationHub.of(context)!.theme.getPlatform() == "Web") {
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
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        ),
        label: "Print",
        labelBackgroundColor:
            MzanziInnovationHub.of(context)!.theme.successColor(),
        labelStyle: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: MzanziInnovationHub.of(context)!.theme.successColor(),
        onTap: () {
          printDocument(url, filePath);
        },
      ),
    );
    menuList.add(
      SpeedDialChild(
        child: Icon(
          Icons.fullscreen,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        ),
        label: "Full Screen",
        labelBackgroundColor:
            MzanziInnovationHub.of(context)!.theme.successColor(),
        labelStyle: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: MzanziInnovationHub.of(context)!.theme.successColor(),
        onTap: () {
          printDocument(url, filePath);
        },
      ),
    );

    if (hasAccessToDelete) {
      menuList.add(
        SpeedDialChild(
          child: Icon(
            Icons.delete,
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          ),
          label: "Delete Document",
          labelBackgroundColor:
              MzanziInnovationHub.of(context)!.theme.successColor(),
          labelStyle: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            fontWeight: FontWeight.bold,
          ),
          backgroundColor:
              MzanziInnovationHub.of(context)!.theme.successColor(),
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
                  widget.files[index].idclaim_statement_file,
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
