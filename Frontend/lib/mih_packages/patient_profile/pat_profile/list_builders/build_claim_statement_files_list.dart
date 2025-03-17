import 'dart:convert';

import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_apis/mih_claim_statement_generation_api.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_window.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_delete_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_env/env.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/claim_statement_file.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/patients.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_profile/list_builders/build_file_view.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildClaimStatementFileList extends StatefulWidget {
  final AppUser signedInUser;
  final List<ClaimStatementFile> files;
  final Patient selectedPatient;
  final Business? business;
  final BusinessUser? businessUser;
  final String type;
  const BuildClaimStatementFileList({
    super.key,
    required this.files,
    required this.signedInUser,
    required this.selectedPatient,
    required this.business,
    required this.businessUser,
    required this.type,
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

  Future<String> getFileUrlApiCall(String filePath) async {
    var url = "$baseAPI/minio/pull/file/${AppEnviroment.getEnv()}/$filePath";
    //print(url);
    var response = await http.get(Uri.parse(url));
    // print("here1");
    //print(response.statusCode);

    if (response.statusCode == 200) {
      //print("here2");
      String body = response.body;
      //print(body);
      //print("here3");
      var decodedData = jsonDecode(body);
      //print("Dedoced: ${decodedData['minioURL']}");

      return decodedData['minioURL'];
      //AppUser u = AppUser.fromJson(decodedData);
      // print(u.email);
      //return "AlometThere";
    } else {
      throw Exception("Error: GetUserData status code ${response.statusCode}");
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
            filePath,
            fileID,
            context,
          );
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
      builder: (context) => MIHWindow(
        fullscreen: true,
        windowTitle: fileName,
        windowBody: [
          BuildFileView(
            link: url,
            path: filePath,
            //pdfLink: '${AppEnviroment.baseFileUrl}/mih/$filePath',
          ),
          const SizedBox(
            height: 10,
          )
        ],
        windowTools: [
          Visibility(
            visible: hasAccessToDelete,
            child: IconButton(
              onPressed: () {
                deleteFilePopUp(filePath, fileID);
              },
              icon: Icon(
                size: 35,
                Icons.delete,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
          ),
        ],
        onWindowTapClose: () {
          Navigator.pop(context);
        },
      ),
    );
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
