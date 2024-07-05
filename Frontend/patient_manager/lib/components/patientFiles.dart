import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:patient_manager/components/buildFilesList.dart';
import 'package:patient_manager/components/medCertInput.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/mySuccessMessage.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/components/prescipInput.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/files.dart';

import 'package:http/http.dart' as http;

import '../objects/patients.dart';

class PatientFiles extends StatefulWidget {
  final int patientIndex;
  final Patient selectedPatient;
  const PatientFiles({
    super.key,
    required this.patientIndex,
    required this.selectedPatient,
  });

  @override
  State<PatientFiles> createState() => _PatientFilesState();
}

class _PatientFilesState extends State<PatientFiles> {
  String endpointFiles = "http://localhost:80/files/patients/";
  String endpointUser = "http://localhost:80/users/profile/";
  String endpointGenFiles = "http://localhost:80/files/generate/med-cert/";
  String endpointFileUpload = "http://localhost:80/files/upload/file/";
  String endpointInsertFiles = "http://localhost:80/files/insert/";

  final startDateController = TextEditingController();
  final endDateTextController = TextEditingController();
  final retDateTextController = TextEditingController();
  final selectedFileController = TextEditingController();
  final medicineController = TextEditingController();
  final quantityController = TextEditingController();
  final dosageController = TextEditingController();
  final timesDailyController = TextEditingController();
  final noDaysController = TextEditingController();
  final noRepeatsController = TextEditingController();
  final outputController = TextEditingController();

  late Future<List<PFile>> futueFiles;
  late String userEmail = "";
  late AppUser appUser;
  late PlatformFile selected;

  Future<void> generateMedCert() async {
    //start loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    var response1 = await http.post(
      Uri.parse(endpointGenFiles),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "fullName":
            "${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}",
        "docfname": "${appUser.title} ${appUser.fname} ${appUser.lname}",
        "startDate": startDateController.text,
        "endDate": endDateTextController.text,
        "returnDate": retDateTextController.text,
      }),
    );
    //print(response1.statusCode);
    String fileName =
        "Med-Cert-${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}-${startDateController.text}.pdf";
    if (response1.statusCode == 200) {
      var response2 = await http.post(
        Uri.parse(endpointInsertFiles),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{
          "file_path": fileName,
          "file_name": fileName,
          "patient_id": widget.patientIndex
        }),
      );
      print(response2.statusCode);
      if (response2.statusCode == 201) {
        setState(() {
          startDateController.clear();
          endDateTextController.clear();
          retDateTextController.clear();
          futueFiles =
              fetchFiles(endpointFiles + widget.patientIndex.toString());
        });
        // end loading circle
        Navigator.of(context).pop();
        String message =
            "The medical certificate $fileName has been successfully generated and added to ${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}'s record. You can now access and download it for their use.";
        successPopUp(message);
      } else {
        internetConnectionPopUp();
      }
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> uploadSelectedFile(PlatformFile file) async {
    //var strem = new http.ByteStream.fromBytes(file.bytes.)
    //start loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    var request = http.MultipartRequest('POST', Uri.parse(endpointFileUpload));
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(await http.MultipartFile.fromBytes('file', file.bytes!,
        filename: file.name.replaceAll(RegExp(r' '), '-')));
    var response1 = await request.send();
    //print(response1.statusCode);
    if (response1.statusCode == 200) {
      var response2 = await http.post(
        Uri.parse(endpointInsertFiles),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{
          "file_path": file.name.replaceAll(RegExp(r' '), '-'),
          "file_name": file.name.replaceAll(RegExp(r' '), '-'),
          "patient_id": widget.patientIndex
        }),
      );
      //print(response2.statusCode);
      if (response2.statusCode == 201) {
        setState(() {
          selectedFileController.clear();
          futueFiles =
              fetchFiles(endpointFiles + widget.patientIndex.toString());
        });
        // end loading circle
        Navigator.of(context).pop();
        String message =
            "The medical certificate ${file.name.replaceAll(RegExp(r' '), '-')} has been successfully generated and added to ${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}'s record. You can now access and download it for their use.";
        successPopUp(message);
      } else {
        internetConnectionPopUp();
      }
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> getUserDetails() async {
    await getUserEmail();
    var response = await http.get(Uri.parse(endpointUser + userEmail));
    //print(response.body);
    if (response.statusCode == 200) {
      appUser =
          AppUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      internetConnectionPopUp();
      throw Exception('Failed to load user');
    }
  }

  Future<void> getUserEmail() async {
    final res = await client.auth.getUser();
    if (res.user!.email != null) {
      //print("emai not null");
      userEmail = res.user!.email!;
      //print(userEmail);
    }
  }

  Future<List<PFile>> fetchFiles(String endpoint) async {
    final response = await http.get(Uri.parse(endpoint));

    //print(response.statusCode);
    //print(response.body);
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<PFile> files =
          List<PFile>.from(l.map((model) => PFile.fromJson(model)));
      return files;
    } else {
      internetConnectionPopUp();
      throw Exception('failed to load patients');
    }
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

  void messagePopUp(error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(error),
        );
      },
    );
  }

  void medCertPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 700.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.blueAccent, width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Create Medical Certificate",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Medcertinput(
                    startDateController: startDateController,
                    endDateTextController: endDateTextController,
                    retDateTextController: retDateTextController,
                  ),
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: MyButton(
                      onTap: () {
                        if (isMedCertFieldsFilled()) {
                          generateMedCert();
                          Navigator.pop(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const MyErrorMessage(
                                  errorType: "Input Error");
                            },
                          );
                        }
                      },
                      buttonText: "Generate",
                      buttonColor: Colors.blueAccent,
                      textColor: Colors.white,
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
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void prescritionPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 900.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.blueAccent, width: 5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Create Precrition",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  PrescripInput(
                    medicineController: medicineController,
                    quantityController: quantityController,
                    dosageController: dosageController,
                    timesDailyController: timesDailyController,
                    noDaysController: noDaysController,
                    noRepeatsController: noRepeatsController,
                    outputController: outputController,
                  ),
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
                  medicineController.clear();
                  quantityController.clear();
                  dosageController.clear();
                  timesDailyController.clear();
                  noDaysController.clear();
                  noRepeatsController.clear();
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void uploudFilePopUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 700.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.blueAccent, width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Upload File",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  SizedBox(
                    width: 700,
                    child: MyButton(
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'pdf'],
                        );
                        if (result == null) return;
                        final selectedFile = result.files.first;
                        setState(() {
                          selected = selectedFile;
                        });

                        setState(() {
                          selectedFileController.text = selectedFile.name;
                        });
                      },
                      buttonText: "Select File",
                      buttonColor: Colors.blueAccent,
                      textColor: Colors.white,
                    ),
                  ),
                  MyTextField(
                    controller: selectedFileController,
                    hintText: "Selected FIle",
                    editable: false,
                    required: true,
                  ),
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: MyButton(
                      onTap: () {
                        if (isFileFieldsFilled()) {
                          uploadSelectedFile(selected);
                          Navigator.pop(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const MyErrorMessage(
                                  errorType: "Input Error");
                            },
                          );
                        }
                      },
                      buttonText: "Add File",
                      buttonColor: Colors.blueAccent,
                      textColor: Colors.white,
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
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MyErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  bool isMedCertFieldsFilled() {
    if (startDateController.text.isEmpty ||
        endDateTextController.text.isEmpty ||
        retDateTextController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool isFileFieldsFilled() {
    if (selectedFileController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    futueFiles = fetchFiles(endpointFiles + widget.patientIndex.toString());
    //patientDetails = getPatientDetails() as Patient;
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futueFiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final filesList = snapshot.data!;
          return Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                //height: 300.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: Colors.blueAccent, width: 3.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Files",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            medCertPopUp();
                          },
                          icon: const Icon(
                            Icons.sick_outlined,
                            color: Colors.blueAccent,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            prescritionPopUp();
                          },
                          icon: const Icon(
                            Icons.medication_outlined,
                            color: Colors.blueAccent,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            uploudFilePopUp();
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.blueAccent,
                          ),
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(),
                    ),
                    const SizedBox(height: 10),
                    BuildFilesList(files: filesList),
                  ]),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text("Error Loading Files"),
          );
        }
      },
    );
  }
}
