import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:patient_manager/components/buildFilesList.dart';
import 'package:patient_manager/components/medCertInput.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
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
  String endpointUser = "http://localhost:80/docOffices/user/";
  String endpointGenFiles = "http://localhost:80/files/generate/med-cert/";
  String endpointFileUpload = "http://localhost:80/files/upload/file/";
  String endpointInsertFiles = "http://localhost:80/files/insert/";

  final startDateController = TextEditingController();
  final endDateTextController = TextEditingController();
  final retDateTextController = TextEditingController();
  final selectedFileController = TextEditingController();

  late Future<List<PFile>> futueFiles;
  late String userEmail = "";
  late AppUser appUser;
  late PlatformFile selected;

  Future<void> generateMedCert() async {
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
        String message = "Successfully added file";
        messagePopUp(message);
      } else {
        messagePopUp("error response 2");
      }
    } else {
      messagePopUp("error respose 1");
    }
  }

  Future<void> uploadSelectedFile(PlatformFile file) async {
    //var strem = new http.ByteStream.fromBytes(file.bytes.)
    var request = http.MultipartRequest('POST', Uri.parse(endpointFileUpload));
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(await http.MultipartFile.fromBytes('file', file.bytes!,
        filename: file.name.replaceAll(RegExp(r' '), '-')));
    var response1 = await request.send();
    print(response1.statusCode);
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
      print(response2.statusCode);
      if (response2.statusCode == 201) {
        setState(() {
          selectedFileController.clear();
          futueFiles =
              fetchFiles(endpointFiles + widget.patientIndex.toString());
        });
        String message = "Successfully added file";
        messagePopUp(message);
      } else {
        messagePopUp("error response 2");
      }
    } else {
      messagePopUp("error respose 1");
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
      throw Exception('failed to load patients');
    }
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
      builder: (context) => AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create Medical Certificate"),
          ],
        ),
        content: Medcertinput(
          startDateController: startDateController,
          endDateTextController: endDateTextController,
          retDateTextController: retDateTextController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              generateMedCert();
              Navigator.pop(context);
            },
            child: const Text(
              "Generate",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              startDateController.clear();
              endDateTextController.clear();
              retDateTextController.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  void uploudFilePopUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Upload File"),
          ],
        ),
        content: SizedBox(
          width: 700,
          height: 250,
          child: Column(
            children: [
              SizedBox(
                width: 700,
                child: MyButton(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result == null) return;
                      final selectedFile = result.files.first;
                      //selectedFile
                      // print("Name: ${selectedFile.name}");
                      // print("Extension: ${selectedFile.extension}");
                      // print("Content: ${selectedFile.bytes}");

                      setState(() {
                        selected = selectedFile;
                      });

                      setState(() {
                        selectedFileController.text = selectedFile.name;
                      });
                    },
                    buttonText: "Select File"),
              ),
              MyTextField(
                controller: selectedFileController,
                hintText: "Selected FIle",
                editable: false,
                required: true,
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              uploadSelectedFile(selected);
              Navigator.pop(context);
            },
            child: const Text(
              "Upload",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          )
        ],
      ),
    );
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
              child: Card(
                elevation: 20.0,
                child: Container(
                  //height: 300.0,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 219, 218, 218),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
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
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              medCertPopUp();
                            },
                            icon: const Icon(Icons.sick_outlined),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.medication_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              uploudFilePopUp();
                            },
                            icon: const Icon(Icons.add),
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
