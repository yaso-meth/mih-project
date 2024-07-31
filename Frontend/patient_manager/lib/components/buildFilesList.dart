import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/BuildFileView.dart';
import 'package:patient_manager/components/mihDeleteMessage.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/mySuccessMessage.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/files.dart';
import 'package:supertokens_flutter/http.dart' as http;
import "package:universal_html/html.dart" as html;

class BuildFilesList extends StatefulWidget {
  final AppUser signedInUser;
  final List<PFile> files;
  const BuildFilesList({
    super.key,
    required this.files,
    required this.signedInUser,
  });

  @override
  State<BuildFilesList> createState() => _BuildFilesListState();
}

class _BuildFilesListState extends State<BuildFilesList> {
  int indexOn = 0;
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<void> deleteFileApiCall(String filePath, int fileID) async {
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
        Navigator.of(context)
            .pushNamed('/patient-profile', arguments: widget.signedInUser);
        setState(() {});
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
        return const MyErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void successPopUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MySuccessMessage(
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
        onTap: () {
          deleteFileApiCall(filePath, fileID);
        },
      ),
    );
  }

  void viewFilePopUp(String fileName, String filePath, int fileID) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      IconButton(
                        onPressed: () {
                          deleteFilePopUp(filePath, fileID);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25.0),
                  Expanded(
                      child: BuildFileView(
                          pdfLink:
                              "${AppEnviroment.baseFileUrl}/mih/$filePath")),
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: MyButton(
                      onTap: () {
                        html.window.open(
                            '${AppEnviroment.baseFileUrl}/mih/$filePath',
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.files.isNotEmpty) {
      return SizedBox(
        height: 290.0,
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
              onTap: () {
                viewFilePopUp(
                  widget.files[index].file_name,
                  widget.files[index].file_path,
                  widget.files[index].idpatient_files,
                );
              },
            );
          },
        ),
      );
    } else {
      return const SizedBox(
        height: 290.0,
        child: Center(
          child: Text(
            "No Files Available",
            style: TextStyle(fontSize: 25, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
