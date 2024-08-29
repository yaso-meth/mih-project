import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/builders/BuildFileView.dart';
import 'package:patient_manager/components/popUpMessages/mihLoadingCircle.dart';
import 'package:patient_manager/components/popUpMessages/mihDeleteMessage.dart';
import 'package:patient_manager/components/popUpMessages/mihErrorMessage.dart';
import 'package:patient_manager/components/popUpMessages/mihSuccessMessage.dart';
import 'package:patient_manager/components/inputsAndButtons/mihButton.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/business.dart';
import 'package:patient_manager/objects/businessUser.dart';
import 'package:patient_manager/objects/files.dart';
import 'package:patient_manager/objects/patients.dart';
import 'package:supertokens_flutter/http.dart' as http;
import "package:universal_html/html.dart" as html;

class BuildFilesList extends StatefulWidget {
  final AppUser signedInUser;
  final List<PFile> files;
  final Patient selectedPatient;
  final Business? business;
  final BusinessUser? businessUser;

  const BuildFilesList({
    super.key,
    required this.files,
    required this.signedInUser,
    required this.selectedPatient,
    required this.business,
    required this.businessUser,
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
    if (AppEnviroment.getEnv() == "Dev") {
      return "$basefile/mih/$filePath";
    } else {
      var url = "$baseAPI/minio/pull/file/$filePath/prod";
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
        throw Exception(
            "Error: GetUserData status code ${response.statusCode}");
      }
    }
    //print(url);
    // var response = await http.get(Uri.parse(url));
    // // print("here1");
    // //print(response.statusCode);

    // if (response.statusCode == 200) {
    //   //print("here2");
    //   String body = response.body;
    //   //print(body);
    //   //print("here3");
    //   var decodedData = jsonDecode(body);
    //   //print("Dedoced: ${decodedData['minioURL']}");

    //   return decodedData['minioURL'];
    //   //AppUser u = AppUser.fromJson(decodedData);
    //   // print(u.email);
    //   //return "AlometThere";
    // } else {
    //   throw Exception("Error: GetUserData status code ${response.statusCode}");
    // }
  }

  Future<void> deleteFileApiCall(String filePath, int fileID) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    // delete file from minio
    var response = await http.delete(
      Uri.parse("$baseAPI/minio/delete/file/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{"file_path": filePath}),
    );
    //print("Here4");
    //print(response.statusCode);
    if (response.statusCode == 200) {
      //SQL delete
      var response2 = await http.delete(
        Uri.parse("$baseAPI/files/delete/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{"idpatient_files": fileID}),
      );
      if (response2.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
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

        // Navigator.of(context)
        //     .pushNamed('/patient-profile', arguments: widget.signedInUser);
        // setState(() {});
        String message =
            "The File has been deleted successfully. This means it will no longer be visible on your and cannot be used for future appointments.";
        successPopUp(message);
      } else {
        internetConnectionPopUp();
      }
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 800.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    fileName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Expanded(
                      child: BuildFileView(
                    link: url,
                    path: filePath,
                    //pdfLink: '${AppEnviroment.baseFileUrl}/mih/$filePath',
                  )),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: MIHButton(
                      onTap: () {
                        html.window.open(
                            url,
                            // '${AppEnviroment.baseFileUrl}/mih/$filePath',
                            'download');
                      },
                      buttonText: "Dowload",
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      textColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                  size: 35,
                ),
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  deleteFilePopUp(filePath, fileID);
                },
                icon: Icon(
                  Icons.delete,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
            ),
          ],
        ),
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
    final Size size = MediaQuery.sizeOf(context);
    //double width = size.width;
    double height = size.height;
    if (widget.files.isNotEmpty) {
      return SizedBox(
        height: height - 254,
        child: ListView.separated(
          shrinkWrap: true,
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
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              subtitle: Text(
                widget.files[index].insert_date,
                style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
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
        ),
      );
    } else {
      return SizedBox(
        height: height - 250,
        child: const Center(
          child: Text(
            "No Documents Available",
            style: TextStyle(fontSize: 25, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
